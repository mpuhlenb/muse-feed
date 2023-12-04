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
    
    func showLoading() async {
        let loading = UIActivityIndicatorView(style: .medium)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.startAnimating()
        loading.hidesWhenStopped = true
        addSubview(loading)
        loading.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loading.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func stopLoading() async {
        guard let loading = subviews.first as? UIActivityIndicatorView else { return }
        loading.stopAnimating()
        loading.removeFromSuperview()
    }
}
