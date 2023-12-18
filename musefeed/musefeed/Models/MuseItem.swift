//
//  MuseItem.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/13/23.
//

import UIKit

class MuseItem: Hashable {
    var id: String
    var title: String
    var detailId: String
    var itemImageUrl: URL?
    var sourceLink: URL?
    var maker: String
    var feed: FeedOption?
    
    init(id: String, title: String, detailId: String,  itemImageUrl: String? = nil, link: URL? = nil, maker: String, feed: FeedOption) {
        self.id = id
        self.title = title
        self.detailId = detailId
        self.sourceLink = URL(string: feed.feedUrlString)
        self.maker = maker
        guard let urlString = itemImageUrl, let imageUrl = URL(string: urlString) else { return }
        self.itemImageUrl = imageUrl
        self.feed = feed
    }
    
    init(artwork: ArtInstituteArtwork, imageBaseUrl: String) {
        self.id = "\(artwork.id)"
        self.title = artwork.title
        self.detailId = ""
        self.maker = artwork.artist
        self.feed = .artInstitute
        self.sourceLink = URL(string: FeedOption.artInstitute.feedUrlString)
        if let imageId = artwork.imageId {
            let artUrlString = imageBaseUrl + "/\(imageId)" + "/full/843,/0/default.jpg"
            self.itemImageUrl = URL(string: artUrlString)
        }
        
    }
    
    // Helper init for empty item
    init() {
        self.id = ""
        self.title = ""
        self.detailId = ""
        self.maker = ""
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MuseItem, rhs: MuseItem) -> Bool {
        lhs.id == rhs.id
    }
}
