//
//  MuseItemCollectionViewCell.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/13/23.
//

import UIKit

extension UIImageView {
    func downloadImageData(from url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    func setImage(from url: URL) async {
        do {
            let data = try await self.downloadImageData(from: url)
            let image = UIImage(data: data)
            self.image = image
        } catch {
            
        }
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
