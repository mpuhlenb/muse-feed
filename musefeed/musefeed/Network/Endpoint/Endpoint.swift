//
//  Endpoint.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/5/23.
//

import Foundation

protocol Endpoint {
    var host: String { get }
    var scheme: String { get }
    var path: String { get }
    var method: String { get }
    var parameters: [String: String] { get }
}

extension Endpoint {
    // All APIs will use secure htttp requests
    var scheme: String {
        return "https"
    }
    
    // Musuem open APIs use GET requests
    var method: String {
        return "GET"
    }
}
