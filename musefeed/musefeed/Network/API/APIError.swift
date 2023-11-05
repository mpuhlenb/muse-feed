//
//  APIError.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/5/23.
//

import Foundation

enum ApiError: Error {
    case requestFailed(description: String)
    case invalidData
    case responseUnsuccessful(description: String)
    case jsonConversionFailure(description: String)
    case jsonParsingFailure
    case failedSerialization
    case noInternet
    
    var customDescription: String {
        switch self {
        case let .requestFailed(description):
            return "Request Failed: \(description)"
        case .invalidData:
            return "Invalid Data"
        case let .responseUnsuccessful(description):
            return "Unsuccessful: \(description)"
        case let .jsonConversionFailure(description):
            return "JSON Conversion Failure: \(description)"
        case .jsonParsingFailure:
            return "JSON Parsing Failure"
        case .failedSerialization:
            return "Serialization failed."
        case .noInternet:
            return "No Internet Connection"
        }
    }
}
