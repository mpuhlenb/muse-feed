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
        await setItemsFor(feedOption: firstOption)
        await setItemsFor(feedOption: secondOption)
    }
    
    func setItemsFor(feedOption: FeedOption) async {
        // TODO: Expand once more services are added
        switch feedOption {
        case .rijks, .metro, .photo:
            let service = RijksMusuemApiService()
            let feedItems = await service.getCollectionItems().map { return MuseItem(id: $0.id, title: $0.title, detailId: $0.objectNumber, itemImageUrl: $0.webImage.url, maker: $0.principalOrFirstMaker )
            }
            let firstItems = feedItems.shuffled().prefix(6)
            let secondItems = feedItems.shuffled().suffix(6)
            firstFeedItems.append(contentsOf: firstItems)
            secondFeedItems.append(contentsOf: secondItems)
//            secondFeedItems = await service.getCollectionItems().suffix(6).map { return MuseItem(id: $0.id, title: $0.title, detailId: $0.objectNumber, itemImageUrl: $0.webImage.url, maker: $0.principalOrFirstMaker)
                
//            }
        }
    }
}
