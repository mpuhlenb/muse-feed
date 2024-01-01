//
//  NYMetEndpoint.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/28/23.
//

import Foundation

enum NYMetEndpoint: Endpoint {
    case objectIds
    case object(Int)
    
    var host: String {
        return "collectionapi.metmuseum.org"
    }
    
    var path: String {
        switch self {
        case .objectIds:
            // TODO: Maybe use objects endpoint if searching for hasImages is not truly filtering
            return "/public/collection/v1/objects"
        case .object(let id):
            return "/public/collection/v1/objects/\(id)"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .objectIds:
            return [:]
        case .object:
            return [:]
        }

    }
    
    
}
