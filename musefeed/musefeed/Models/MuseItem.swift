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
    var itemImageUrl: URL?
    var link: URL?
    
    init(id: String, title: String, itemImageUrl: String? = nil, link: URL? = nil) {
        self.id = id
        self.title = title
        self.link = link
        guard let urlString = itemImageUrl, let imageUrl = URL(string: urlString) else { return }
        self.itemImageUrl = imageUrl
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MuseItem, rhs: MuseItem) -> Bool {
        lhs.id == rhs.id
    }
}
