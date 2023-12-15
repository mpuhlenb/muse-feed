//
//  DetailViewController.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/22/23.
//

import UIKit

class DetailViewController: UIViewController, UIPopoverPresentationControllerDelegate, Storyboarded {
    var museItem: MuseItem?
    var coordinator: MainCoordinator?
    @IBOutlet var detailImageView: PanZoomImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = museItem?.title
        setupInfoButton()
        setImage()
    }
    
    private func setupInfoButton() {
        let infoButton = UIBarButtonItem(title: "", image: UIImage(systemName: "info.circle"), target: self, action: #selector(infoTapped(_:)))
        infoButton.tintColor = .foreground
        self.navigationItem.setRightBarButton(infoButton, animated: true)
    }
    
    private func setImage() {
        guard let item = museItem, let imageUrl = item.itemImageUrl else { return }
        detailImageView?.setScrollImage(with: imageUrl)
    }
    
    @objc private func infoTapped(_ sender: UIBarButtonItem) {
        guard let item = museItem else { return }
        let infoViewModel = ItemInfoViewModel(itemTitle: item.title, itemArtist: item.maker, itemOrigin: item.feed?.feedName ?? "", feedUrl: item.sourceLink)
        coordinator?.presentInfoPopUp(with: infoViewModel, from: sender, delegate: self)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // Force popover style
        return UIModalPresentationStyle.none
    }
}
