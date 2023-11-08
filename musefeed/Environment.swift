//
//  Environment.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/8/23.
//

import Foundation

public enum Environment {
    enum Keys {
        static let rijks_api_key = "RIJKS_API_KEY"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary  else {
            fatalError("plist file not found")
        }
        return dict
    }()
    
    static let rijksApiKey: String = {
        guard let apiKeyString = Environment.infoDictionary[Keys.rijks_api_key] as? String else {
            fatalError("Rijks API Key not set in plist")
        }
        return apiKeyString
    }()
}
