//
//  DetailViewController.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/22/23.
//

import UIKit

class DetailViewController: UIViewController, Storyboarded {
    var museItem: MuseItem?
    var coordinator: MainCoordinator?
    @IBOutlet var detailImageView: PanZoomImageView?
    @IBOutlet var creatorLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = museItem?.title
        creatorLabel?.text = "Creator: " + (museItem?.maker ?? "")
        creatorLabel?.textColor = .secondary
        setImage()
    }
    
    
    func setImage() {
        guard let item = museItem, let imageUrl = item.itemImageUrl else { return }
        detailImageView?.setScrollImage(with: imageUrl)
    }
}
