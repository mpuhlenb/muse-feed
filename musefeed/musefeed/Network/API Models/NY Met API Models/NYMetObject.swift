//
//  NYMetObject.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/28/23.
//

import Foundation

struct NYMetObject: Codable {
    let objectID: Int
    let title: String
    let artistDisplayName: String
    let primaryImage: String
    let additionalImages: [String?]
    let primaryImageSmall: String?
}
