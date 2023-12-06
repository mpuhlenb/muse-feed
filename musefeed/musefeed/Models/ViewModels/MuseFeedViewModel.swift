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
    
    public let viewTitle = "Your Muses"
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
            let service = RijksMusuemApiService()
            let fetchedItems = await service.getCollectionItems().map { return MuseItem(id: $0.id, title: $0.title, detailId: $0.objectNumber, itemImageUrl: $0.webImage.url, maker: $0.principalOrFirstMaker, feed: .rijks )
            }.shuffled().prefix(6)
            feedItems.append(contentsOf: fetchedItems)
        case .artInstitute:
            let service = ArtInstituteApiService()
            guard let data = await service.getArtworks() else { return }
            let fetchedItems = data.data.map { return MuseItem(artwork: $0, imageBaseUrl: data.config.imageBaseUrl) }.shuffled().prefix(6)
            feedItems.append(contentsOf: fetchedItems)
        case .moma:
            let service = MOMAService()
            let objects = await service.getMOMAObjects()
            let fetchedItems = objects.map { return MuseItem(id: "\($0.objectID)", title: $0.title, detailId: "\($0.objectID)", itemImageUrl: $0.primaryImage, maker: $0.artistDisplayName, feed: .moma) }
            feedItems.append(contentsOf: fetchedItems)
        }
        switch section {
        case .firstFeed:
            firstFeedItems.append(contentsOf: feedItems)
            firstFeedIsRefreshing = false
        case .secondFeed:
            secondFeedItems.append(contentsOf: feedItems)
            secondFeedIsRefreshing = false
        }
    }
}
