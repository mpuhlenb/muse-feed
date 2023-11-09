//
//  MuseFeeds.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/8/23.
//

import Foundation

enum MuseFeeds: CaseIterable {
    case rijksMuseum
    
    var title: String {
        switch self {
        case .rijksMuseum:
            return "Rijks Museum"
        }
    }
}
