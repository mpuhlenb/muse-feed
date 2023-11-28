//
//  FeedOption.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/12/23.
//

import Foundation

enum FeedOption: String, CaseIterable {
    case rijks
    case artInstitute
    case photo
}

extension FeedOption: FeedSelectionCellModel {
    var feedUrlString: String {
        return ""
    }
    
    var feedName: String {
        switch self {
        case .rijks:
            return "Rijks Museum"
        case .artInstitute:
            return "Chicago Art Institute"
        case .photo:
            return "Photo Thingy"
        }
    }
}
