//
//  MOMAService.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/28/23.
//

import Foundation

struct MOMAService: APIDataProvidable {
    var session: URLSession = URLSession.shared
    
    // TODO: Refactor better way to get 6 items with images, not all items images.
    func getMOMAObjects() async -> [MOMAObject] {
        let ids = await getMOMAObjectIds()
        var objects: [MOMAObject] = []
        for id in ids {
            if let object = await getMOMAObject(with: id) {
                objects.append(object)
            }
        }
        let sixObjects = Array(objects.filter { !$0.primaryImage.isEmpty }.prefix(6))
        return sixObjects
    }
    
    func getMOMAObject(with id: Int) async  -> MOMAObject? {
        do {
            let result = try await requestAPIData(endpoint: MOMAEndpoint.object(id), responseModel: MOMAObject.self)
            switch result {
            case .success(let object):
                return object
            case .failure:
                return nil
            }
        } catch {
            return nil
        }
    }
    // TODO: Refactor to cache all available ids, refresh if stale.
    private func getMOMAObjectIds() async -> [Int] {
        do {
            let result = try await requestAPIData(endpoint: MOMAEndpoint.objectIds, responseModel: MOMAObjectIds.self)
            switch result {
            case .success(let ids):
                let fifteenIds = Array(ids.objectIDs.shuffled().prefix(15))
                return fifteenIds
            case .failure:
                return []
            }
        } catch {
            return []
        }
    }
    
}
