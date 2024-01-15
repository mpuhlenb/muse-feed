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
        return "/api/en/collection"
    }
    
    var parameters: [String : String] {
        return [
            "key": "\(Environment.rijksApiKey)",
            "imgOnly": "True",
            "p": "\(Int.random(in: 1..<500))",
            "ps": "20"
        ]
    }
    
    
}
