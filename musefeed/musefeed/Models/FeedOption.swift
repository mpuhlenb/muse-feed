//
//  FeedOption.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/12/23.
//

import Foundation

enum FeedOption: String, CaseIterable, Equatable {
    case rijks
    case artInstitute
    case moma
}

extension FeedOption: FeedSelectionCellModel {
    var feedUrlString: String {
        switch self {
        case .rijks:
            return "https://www.rijksmuseum.nl/en" // TODO: make this toggle to locale NL or EN
        case .artInstitute:
            return "https://www.artic.edu/"
        case .moma:
            return "https://www.moma.org/"
        }
    }
    
    var feedName: String {
        switch self {
        case .rijks:
            return "Rijks Museum"
        case .artInstitute:
            return "Chicago Art Institute"
        case .moma:
            return "Museum of Modern Art"
        }
    }
}
