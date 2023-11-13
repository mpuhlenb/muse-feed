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
    
    private lazy var dataSource = makeDataSource()
    
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
        title = viewModel?.viewTitle ?? ""
        configureLayout()
        getItems()
        subscribeToViewModel()
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, museItem) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MuseItemCollectionViewCell
            cell?.museItem = museItem
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
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
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
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 6)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return section
//            let size = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(0.33), heightDimension: NSCollectionLayoutDimension.fractionalHeight(0.5))
//            let itemCount = 6
//            let item = NSCollectionLayoutItem(layoutSize: size)
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, repeatingSubitem: item, count: itemCount)
//            let section = NSCollectionLayoutSection(group: group)
//            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//            return section
        })
    }
}
