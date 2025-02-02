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
    case nymet
}

extension FeedOption: FeedSelectionCellModel {
    var feedUrlString: String {
        switch self {
        case .rijks:
            return "https://www.rijksmuseum.nl/en" // TODO: make this toggle to locale NL or EN
        case .artInstitute:
            return "https://www.artic.edu/"
        case .nymet:
            return "https://www.metmuseum.org/"
        }
    }
    
    var feedName: String {
        switch self {
        case .rijks:
            return "Rijksmuseum"
        case .artInstitute:
            return "Art Institute of Chicago"
        case .nymet:
            return "Metropolitan Museum of Art"
        }
    }
    
    var feedDescription: String {
        switch self {
        case .rijks:
            return "The national museum of the Netherlands offering access to 400,000 collection objects spanning the years 1200 to today, from masterpieces to model ships."
        case .artInstitute:
            return "Explore thousands of artworks from every corner of the globe, from renowned icons to lesser-known works."
        case .nymet:
            return "Iconic New York City institution provides access to over 400,000 rare and beautiful objects from around the world representing over 5,000 years of art."
        }
    }
}
