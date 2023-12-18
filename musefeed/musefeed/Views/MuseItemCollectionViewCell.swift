//
//  MuseItemCollectionViewCell.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/13/23.
//

import UIKit

class MuseItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    var museItem: MuseItem? {
        didSet {
            if let imageUrl = museItem?.itemImageUrl {
                Task {
                    await itemImageView.setImage(from: imageUrl)
                    itemImageView.contentMode = .scaleAspectFill
                }
            } else {
                itemImageView.image = UIImage(systemName: "photo.fill")
                itemImageView.contentMode = .scaleAspectFit
            }
        }
    }
}
