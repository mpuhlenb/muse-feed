//
//  UIImageView+Helpers.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 12/4/23.
//

import UIKit

extension UIImageView {
    func downloadImageData(from url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    func setImage(from url: URL) async {
        await showLoading()
        do {
            let data = try await self.downloadImageData(from: url)
            let image = UIImage(data: data)
            await stopLoading()
            self.image = image
        } catch {
            await stopLoading()
            // TODO: Catch what?
        }
    }
}
