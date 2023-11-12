//
//  FeedOption.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/12/23.
//

import Foundation

enum FeedOption: String, CaseIterable {
    case rijks
    case metro
    case photo
}

extension FeedOption: FeedSelectionCellModel {
    var feedName: String {
        switch self {
        case .rijks:
            return "Rijks Museum"
        case .metro:
            return "Metropolitan Museum of Art"
        case .photo:
            return "Photo Thingy"
        }
    }
}
