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
}

class MuseItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    var museItem: MuseItem? {
        didSet {
            guard let imageUrl = museItem?.itemImageUrl else { return }
            Task {
                do {
                    let data = try await itemImageView.downloadImageData(from: imageUrl)
                    let image = UIImage(data: data)
                    itemImageView.contentMode = .scaleAspectFill
                    itemImageView.image = image
                } catch  {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
