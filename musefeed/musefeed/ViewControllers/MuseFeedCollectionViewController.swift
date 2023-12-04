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
    }
    
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
                headerView.setupContent(for: viewModel.selectedOptions[indexPath.section])
                headerView.setSectionText(with: viewModel.selectedOptions[indexPath.section].feedName)
                headerView.backgroundColor = .foreground
                headerView.sectionLabel.textColor = .background
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapRefreshFeed))
                headerView.addGestureRecognizer(tapGesture)
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
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.firstFeed, .secondFeed])
        guard firstFeedItems.count != 0, secondFeedItems.count != 0 else { return }
        snapshot.appendItems(firstFeedItems, toSection: .firstFeed)
        snapshot.appendItems(secondFeedItems, toSection: .secondFeed)
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
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
        guard let sectionHeader = tapGesture.view as? MuseFeedSectionHeader, let option = sectionHeader.museOption, let viewModel = viewModel, let sectionIndex = viewModel.selectedOptions.firstIndex(of: option) else { return }
        let section = MuseFeedViewModel.Section.allCases[sectionIndex]
        Task {
            await viewModel.refreshItems(in: section, feedOption: option)
        }
    }
}
    // MARK: - Layout Handling
extension MuseFeedCollectionViewController {
    func configureLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let widthRatio = UIDevice.current.orientation.isLandscape ? 0.25 : 0.9
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.9))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(widthRatio), heightDimension: .fractionalHeight(0.35))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            
            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        })
    }
}

