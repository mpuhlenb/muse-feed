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
    
    func setItemsFor(feedOption: FeedOption, in section: Section) async {
        // TODO: Expand once more services are added
        switch feedOption {
        case .rijks, .photo:
            let service = RijksMusuemApiService()
            let feedItems = await service.getCollectionItems().map { return MuseItem(id: $0.id, title: $0.title, detailId: $0.objectNumber, itemImageUrl: $0.webImage.url, maker: $0.principalOrFirstMaker )
            }.shuffled().prefix(6)
            switch section {
            case .firstFeed:
                firstFeedItems.append(contentsOf: feedItems)
            case .secondFeed:
                secondFeedItems.append(contentsOf: feedItems)
            }
        case .artInstitute:
            let service = ArtInstituteApiService()
            guard let data = await service.getArtworks() else { return }
            let feedItems = data.data.map { return MuseItem(artwork: $0, imageBaseUrl: data.config.imageBaseUrl) }.shuffled().prefix(6)
            switch section {
            case .firstFeed:
                firstFeedItems.append(contentsOf: feedItems)
            case .secondFeed:
                secondFeedItems.append(contentsOf: feedItems)
            }
        }
    }
}
