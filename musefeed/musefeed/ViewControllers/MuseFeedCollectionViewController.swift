//
//  MuseFeedCollectionViewController.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/13/23.
//

import UIKit
import Combine

private let reuseIdentifier = "MuseItemCollectionViewCell"

class MuseFeedCollectionViewController: UICollectionViewController, Storyboarded {
    var coordinator: MainCoordinator?
    
    private var dataSource: DataSource?
    
    typealias DataSource = UICollectionViewDiffableDataSource<MuseFeedViewModel.Section, MuseItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MuseFeedViewModel.Section, MuseItem>
    
    private var cancellables = Set<AnyCancellable>()

    var viewModel: MuseFeedViewModel?
    var firstFeedItems: [MuseItem] = []
    var secondFeedItems: [MuseItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = makeDataSource()
        configureSupplementaryView()
        title = viewModel?.viewTitle ?? ""
        configureLayout()
        collectionView.backgroundColor = .background
        getItems()
        subscribeToViewModel()
        Task {
            await view.showLoading()
        }
        navigationController?.setToolbarHidden(true, animated: false)
    }

    func displayTutorial() {
        if !Defaults.tutorialHasBeenViewed {
            viewModel?.setTutorialHasBeenViewed()
            coordinator?.presentFeedTutorialPopUp(in: self.view, delegate: self)
        }
    }
    
    func showEmptyFeedAlert(for section: MuseFeedViewModel.Section) {
        let sectionIndex = section == .firstFeed ? 0 : 1
        let feedTitle = viewModel?.selectedOptions[sectionIndex].feedName ?? ""
        let alert = UIAlertController(title: "Feed Slow", message: "The \(feedTitle) timed out returning images. Please tap refresh button in the feed header to try again or navigate back to select a different feed", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alert, animated: false)
        }
    }
    
    // MARK: - Diffable Data Source
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, museItem) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MuseItemCollectionViewCell
            cell?.museItem = museItem
            cell?.contentView.layer.cornerRadius = 5.0
            cell?.contentView.layer.masksToBounds = true
            cell?.layer.cornerRadius = 5.0
            cell?.layer.masksToBounds = false
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapItem(_:)))
            cell?.addGestureRecognizer(tapGesture)
            return cell
        })
        return dataSource
    }
    
    
    func configureSupplementaryView() {
        dataSource?.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let viewModel = self.viewModel, let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MuseFeedSectionHeader.reuseId, for: indexPath) as? MuseFeedSectionHeader else { return UICollectionReusableView() }
                let section = MuseFeedViewModel.Section.allCases[indexPath.section]
                headerView.setupContent(for: viewModel.selectedOptions[indexPath.section], sectionIndex: indexPath.section)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapRefreshFeed))
                headerView.refreshButton?.addGestureRecognizer(tapGesture)
                switch section {
                case .firstFeed:
                        viewModel.$firstFeedIsRefreshing.sink { isRefreshing in
                            guard let headerMuse = headerView.museOption, headerMuse == viewModel.selectedOptions[indexPath.section] else { return }
                            headerView.refreshButton?.updateIsRefreshing(to: isRefreshing)
                            DispatchQueue.main.async {
                                collectionView.isUserInteractionEnabled = !isRefreshing
                            }
                        }.store(in: &self.cancellables)

                case .secondFeed:
                        viewModel.$secondFeedIsRefreshing.sink { isRefreshing in
                            guard let headerMuse = headerView.museOption, headerMuse == viewModel.selectedOptions[indexPath.section] else { return }
                            headerView.refreshButton?.updateIsRefreshing(to: isRefreshing)
                            DispatchQueue.main.async {
                                collectionView.isUserInteractionEnabled = !isRefreshing
                            }
                        }.store(in: &self.cancellables)
                }
                return headerView
            default:
                return UICollectionReusableView()
            }
        }
    }
    
    private func getItems() {
        Task {
            do {
                await viewModel?.setFeedItems()
            }
        }
    }
    
    private func subscribeToViewModel() {
        viewModel?.$firstFeedItems.sink { [weak self] items in
            self?.firstFeedItems = items
            self?.applySnapshot()
        }.store(in: &cancellables)
        viewModel?.$secondFeedItems.sink { [weak self] items in
            self?.secondFeedItems = items
            self?.applySnapshot()
        }.store(in: &cancellables)
        viewModel?.$firstFeedIsEmpty.sink { [weak self] isEmpty in
            if isEmpty {
                self?.showEmptyFeedAlert(for: .firstFeed)
            }
        }.store(in: &cancellables)
        viewModel?.$secondFeedIsEmpty.sink { [weak self] isEmpty in
            if isEmpty {
                self?.showEmptyFeedAlert(for: .secondFeed)
            }
        }.store(in: &cancellables)
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.firstFeed, .secondFeed])
        guard !firstFeedItems.isEmpty, !secondFeedItems.isEmpty else { return }
        snapshot.appendItems(firstFeedItems, toSection: .firstFeed)
        snapshot.appendItems(secondFeedItems, toSection: .secondFeed)
        Task {
            await view.stopLoading()
            DispatchQueue.main.async {
                self.displayTutorial()
            }
        }
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    // MARK: - Actions
    @IBAction func didTapItem(_ sender: UITapGestureRecognizer) {
        guard let indexPath = collectionView.indexPathForItem(at: sender.location(in: self.collectionView)) else { return }
        let section = MuseFeedViewModel.Section.allCases[indexPath.section]
        var item: MuseItem
        switch section {
        case .firstFeed:
            item = firstFeedItems[indexPath.row]
        case .secondFeed:
            item = secondFeedItems[indexPath.row]
        }

        coordinator?.showDetailView(for: item)
    }
    
    @objc func didTapRefreshFeed(_ tapGesture: UITapGestureRecognizer) {
        guard let refreshButton = tapGesture.view as? SectionButton, let sectionIndex = refreshButton.sectionIndex, let viewModel = viewModel else { return }
        let section = MuseFeedViewModel.Section.allCases[sectionIndex]
        let option = viewModel.selectedOptions[sectionIndex]
        Task {
            await viewModel.refreshItems(in: section, feedOption: option)
        }
        
    }
}
    // MARK: - Layout Handling
extension MuseFeedCollectionViewController {
    func configureLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let widthRatio = DeviceConfiguration.isLandscape ? 0.6 : 0.6
            let headerHeight = DeviceConfiguration.isPad ? 35.0 : 27.0
            let sectionInset = DeviceConfiguration.isPad ? 15.0 : 10.0
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(widthRatio), heightDimension: .fractionalHeight(0.4))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: sectionInset, leading: 0, bottom: sectionInset, trailing: 0)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            
            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(headerHeight))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            sectionHeader.extendsBoundary = true
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        })
    }
}
