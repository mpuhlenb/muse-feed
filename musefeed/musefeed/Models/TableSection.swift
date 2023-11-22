//
//  TableSection.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/12/23.
//

import Foundation

// TODO: Move into FeedSelectionViewModel
enum TableSection: Hashable {
    case feeds
}

enum TableSectionItem: Hashable {
    case source(FeedOption)
}

struct TableSectionData {
    var key: TableSection
    var values: [TableSectionItem]
}
