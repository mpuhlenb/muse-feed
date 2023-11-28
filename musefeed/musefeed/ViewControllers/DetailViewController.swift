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
        let infoButton = UIBarButtonItem(title: "", image: UIImage(systemName: "info.circle"), target: self, action: #selector(infoTapped(_:)))
        infoButton.tintColor = .foreground
        self.navigationItem.setRightBarButton(infoButton, animated: true)
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
        var infoWindow = ItemInfoViewController(title: item.title, text: item.maker, buttonText: "Close")
        infoWindow.modalPresentationStyle = .popover
        infoWindow.popoverPresentationController?.barButtonItem = sender
        infoWindow.popoverPresentationController?.delegate = self
        infoWindow.popoverPresentationController?.permittedArrowDirections = .up
        self.present(infoWindow, animated: true)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // Force popover style
        return UIModalPresentationStyle.none
    }
}
