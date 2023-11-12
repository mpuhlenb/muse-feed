//
//  Section.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/12/23.
//

import Foundation

enum Section: Hashable {
    case feeds
}

enum SectionItem: Hashable {
    case source(FeedOption)
}

struct SectionData {
    var key: Section
    var values: [SectionItem]
}
