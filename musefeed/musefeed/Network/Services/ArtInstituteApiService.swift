//
//  ArtInstituteApiService.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/28/23.
//

import Foundation

struct ArtInstituteApiService: APIDataProvidable {
    var session: URLSession = URLSession.shared
    
    func getArtworks() async -> ArtInstituteArtworks? {
        do {
            let result = try await requestAPIData(endpoint: ArtInstituteEndpoint.artworks, responseModel: ArtInstituteArtworks.self)
            switch result {
            case .success(let artworks):
                return artworks
            case .failure:
                return nil
            }
        } catch {
            return nil
        }
    }
}
