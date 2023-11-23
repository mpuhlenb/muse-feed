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
    var firstFeedItems: [MuseItem] = [] {
        didSet {
            if !firstFeedItems.isEmpty {
                applySnapshot()
            }
        }
    }
    var secondFeedItems: [MuseItem] = [] {
        didSet {
            if !firstFeedItems.isEmpty {
                applySnapshot()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = makeDataSource()
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
        }.store(in: &cancellables)
        viewModel?.$secondFeedItems.sink { [weak self] items in
            self?.secondFeedItems = items
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
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
}
    // MARK: - Layout Handling
extension MuseFeedCollectionViewController {
    func configureLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let widthRatio = UIDevice.current.orientation.isLandscape ? 0.25 : 0.9
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(widthRatio), heightDimension: .fractionalHeight(0.4))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            return section
        })
    }
}

