//
//  ArtInstituteEndpoint.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/28/23.
//

import Foundation

enum ArtInstituteEndpoint: Endpoint {
    case artworks
    case art
    
    var host: String {
        return "api.artic.edu"
    }
    
    var path: String {
        return "/api/v1/artworks"
    }
    
    var parameters: [String : String] {
        switch self {
        case .artworks:
            return [
                "fields": "id,title,artist_display,description,image_id",
                "page" : "\(Int.random(in: 1..<100))", // TODO: setup picking random page
                "limit" : "30"]
        case .art:
            return [
                "" : ""
            ]
        }

    }
    
    
}
