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
            firstFeedItems = await service.getCollectionItems().prefix(6).map { return MuseItem(id: $0.id, title: $0.title, itemImageUrl: $0.webImage.url)
            }
            secondFeedItems = await service.getCollectionItems().suffix(6).map { return MuseItem(id: $0.id, title: $0.title, itemImageUrl: $0.webImage.url)
                
            }
        }
    }
}
