//
//  MuseItemCollectionViewCell.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/13/23.
//

import UIKit

// TODO: Move to own file
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
        var loading = UIActivityIndicatorView(style: .medium)
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

class MuseItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    var museItem: MuseItem? {
        didSet {
            guard let imageUrl = museItem?.itemImageUrl else { return }
            Task {
                await itemImageView.setImage(from: imageUrl)
                itemImageView.contentMode = .scaleAspectFill
            }
        }
    }
}
