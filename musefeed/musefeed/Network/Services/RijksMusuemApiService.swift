//
//  RijksMusuemApiService.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/8/23.
//

import Foundation

struct RijksMusuemApiService: APIDataProvidable {
    var session: URLSession = URLSession.shared
    
    func getCollectionItems() async -> [RijksArtObject] {
        do {
            let result = try await requestAPIData(endpoint: RijksMuseumEndpoint.collection, responseModel: RijksArtObjects.self)
            switch result {
            case .success(let artObjects):
                return artObjects.artObjects
            case .failure:
                return [] // TODO: Update with error event handling
            }
        } catch {
            return []
        }
    }
}
