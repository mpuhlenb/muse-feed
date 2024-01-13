//
//  APIDataProvidable.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/5/23.
//

import Foundation

protocol APIDataProvidable {
    var session: URLSessionable { get }
    func fetch<T: Decodable>(type: T.Type, with request: URLRequest) async throws -> Result<T, ApiError>
    func requestAPIData<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> Result<T, ApiError>
}

extension APIDataProvidable {
    func requestAPIData<T>(endpoint: Endpoint, responseModel: T.Type) async throws -> Result<T, ApiError> where T : Decodable {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        guard let url = urlComponents.url else { return .failure(.requestFailed(description: "Invalid url serialization")) }
        let request = URLRequest(url: url)
        do {
           return try await fetch(type: responseModel, with: request)
        } catch let error as ApiError {
            return .failure(.requestFailed(description: error.customDescription))
        }
    }
    
    func fetch<T: Decodable>(type: T.Type, with request: URLRequest) async throws -> Result<T, ApiError> {
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw ApiError.requestFailed(description: "Invalid response")
        }
        guard httpResponse.statusCode == 200 else {
            throw ApiError.responseUnsuccessful(description: "Status code: \(httpResponse.statusCode)")
        }
        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(type, from: data)
            return .success(decodedResponse)
        } catch {
            throw ApiError.jsonConversionFailure(description: error.localizedDescription)
        }
    }
}
