//
//  ArtInstituteArtworks.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/28/23.
//

import Foundation

struct ArtInstituteArtworks: Decodable {
    let data: [ArtInstituteArtwork]
    let config: ArtInstituteImageConfig
}

struct ArtInstituteArtwork: Decodable {
    let id: Int
    let title: String
    let artist: String
    var imageId: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case artist = "artist_display"
        case imageId = "image_id"
        case description = "description"
    }
}

struct ArtInstituteImageConfig: Decodable {
    var imageBaseUrl: String
    
    enum CodingKeys: String, CodingKey {
        case imageBaseUrl = "iiif_url"
    }
}