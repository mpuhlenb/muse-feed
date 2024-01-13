//
//  NYMetService.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/28/23.
//

import Foundation

struct NYMetService: APIDataProvidable {
    var session: URLSessionable
    
    init(session: URLSessionable) {
        self.session = session
    }
    
    // TODO: Refactor better way to get 6 items with images, not all items images.
    func getMOMAObjects() async -> [NYMetObject] {
        let ids = await getMOMAObjectIds()
        var objects: [NYMetObject] = []
        for id in ids {
            if let object = await getMOMAObject(with: id) {
                objects.append(object)
            }
        }
        let sixObjects = Array(objects.filter { !$0.primaryImage.isEmpty }.prefix(6))
        return sixObjects
    }
    
    func getMOMAObject(with id: Int) async -> NYMetObject? {
        do {
            let result = try await requestAPIData(endpoint: NYMetEndpoint.object(id), responseModel: NYMetObject.self)
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
            let result = try await requestAPIData(endpoint: NYMetEndpoint.objectIds, responseModel: NYMetObjectIds.self)
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
