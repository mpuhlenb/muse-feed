//
//  MuseFeedViewModel.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/13/23.
//

import Foundation
import Combine

public class MuseFeedViewModel {
    enum Section: CaseIterable {
        case firstFeed
        case secondFeed
    }
    
    @Published var firstFeedItems: [MuseItem] = []
    @Published var secondFeedItems: [MuseItem] = []
    @Published var firstFeedIsRefreshing: Bool = false
    @Published var secondFeedIsRefreshing: Bool = false
    @Published var firstFeedIsEmpty: Bool = false
    @Published var secondFeedIsEmpty: Bool = false
    
    var session: URLSession = URLSession.shared
    
    public let viewTitle = "Muse Feeds"
    var selectedOptions: [FeedOption]
    
    init(selectedOptions: [FeedOption]) {
        self.selectedOptions = selectedOptions
    }
    
    func setFeedItems() async {
        guard let firstOption = selectedOptions.first, let secondOption = selectedOptions.last else { return }
        firstFeedItems.removeAll()
        secondFeedItems.removeAll()
        await setItemsFor(feedOption: firstOption, in: .firstFeed)
        await setItemsFor(feedOption: secondOption, in: .secondFeed)
    }
    
    func refreshItems(in section: Section, feedOption: FeedOption) async {
        switch section {
        case .firstFeed:
            firstFeedItems.removeAll()
            firstFeedIsRefreshing = true
        case .secondFeed:
            secondFeedItems.removeAll()
            secondFeedIsRefreshing = true
        }
        Task {
            await setItemsFor(feedOption: feedOption, in: section)
        }
    }
    
    func setItemsFor(feedOption: FeedOption, in section: Section) async {
        var feedItems: [MuseItem] = []
        switch feedOption {
        case .rijks:
            let service = RijksMusuemApiService(session: session)
            let fetchedItems = await service.getCollectionItems().map { return MuseItem(id: $0.id, title: $0.title, detailId: $0.objectNumber, itemImageUrl: $0.webImage.url, maker: $0.principalOrFirstMaker, feed: .rijks )
            }.shuffled().prefix(6)
            feedItems.append(contentsOf: fetchedItems)
        case .artInstitute:
            let service = ArtInstituteApiService(session: session)
            let data = await service.getArtworks()
            let fetchedItems = data?.data.map { return MuseItem(artwork: $0, imageBaseUrl: data?.config.imageBaseUrl ?? "") }.shuffled().prefix(6) ?? []
            feedItems.append(contentsOf: fetchedItems)
        case .nymet:
            let service = NYMetService(session: session)
            let objects = await service.getMOMAObjects()
            let fetchedItems = objects.map { return MuseItem(id: "\($0.objectID)", title: $0.title, detailId: "\($0.objectID)", itemImageUrl: $0.primaryImage, maker: $0.artistDisplayName, feed: .nymet) }
            feedItems.append(contentsOf: fetchedItems)
        }
        switch section {
        case .firstFeed:
            firstFeedIsEmpty = feedItems.isEmpty
            let appendItems = firstFeedIsEmpty ? [MuseItem()] : feedItems
            firstFeedItems.append(contentsOf: appendItems)
            firstFeedIsRefreshing = false
        case .secondFeed:
            secondFeedIsEmpty = feedItems.isEmpty
            let appendItems = secondFeedIsEmpty ? [MuseItem()] : feedItems
            secondFeedItems.append(contentsOf: appendItems)
            secondFeedIsRefreshing = false
        }
    }
    
    func setTutorialHasBeenViewed() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Defaults.TutorialViewed)
    }
}
