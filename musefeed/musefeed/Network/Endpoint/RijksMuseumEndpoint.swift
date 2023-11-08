//
//  RijksMuseumEndpoint.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/8/23.
//

import Foundation

enum RijksMuseumEndpoint: Endpoint {
    case collection
    
    var host: String {
        return "www.rijksmuseum.nl"
    }
    
    var path: String {
        return "/api/en/collection" // TODO: update 'en' to be dynamic to either en or nl
    }
    
    var parameters: [String : String] {
        return [
            "key": "\(Environment.rijksApiKey)",
            "imgOnly": "True",
            "p": "1", // TODO: set value to random between 1 to 100
            "ps": "100"
        ]
    }
    
    
}
