//
//  ImageLoader.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 1/2/24.
//

import UIKit

final class ImageLoader {
    private let cache: ImageCacheType
    public static let shared = ImageLoader()
    
    public init(cache: ImageCacheType = ImageCache()) {
        self.cache = cache
    }
    
    func loadImage(from url: URL) async throws -> UIImage? {
        if let image = cache[url] {
            return image
        }
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let image = UIImage(data: data)
        self.cache[url] = image
        return image
    }
}
