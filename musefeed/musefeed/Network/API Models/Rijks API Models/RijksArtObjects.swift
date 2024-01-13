//
//  RijksArtObjects.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/8/23.
//

import Foundation

struct RijksArtObjects: Codable {
    let artObjects: [RijksArtObject]
}

struct RijksArtObject: Codable {
    let id: String
    let title: String
    let objectNumber: String
    let principalOrFirstMaker: String
    let hasImage: Bool
    let webImage: RijksWebImage
}

struct RijksWebImage: Codable {
    let guid: String
    let width: Int
    let height: Int
    let url: String
}
