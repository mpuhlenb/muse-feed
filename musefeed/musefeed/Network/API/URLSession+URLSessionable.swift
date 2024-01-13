//
//  URLSession+URLSessionable.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 1/13/24.
//

import Foundation

protocol URLSessionable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSessionable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request)
    }
}

extension URLSession: URLSessionable {}

class MockSession: URLSessionable {
    var results = [Result<Data, Error>.success(Data())]
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        
        let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let result = results.first!
        results.removeFirst()
        return try (result.get(), httpResponse!)
    }
}
