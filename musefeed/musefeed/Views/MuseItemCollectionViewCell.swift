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
            guard let imageUrl = museItem?.itemImageUrl else { return }
            Task {
                await itemImageView.setImage(from: imageUrl)
                itemImageView.contentMode = .scaleAspectFill
            }
        }
    }
}
