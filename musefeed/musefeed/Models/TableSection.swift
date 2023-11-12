//
//  TableSection.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/12/23.
//

import Foundation

enum TableSection: Hashable {
    case feeds
}

enum SectionItem: Hashable {
    case source(FeedOption)
}

struct SectionData {
    var key: TableSection
    var values: [SectionItem]
}
