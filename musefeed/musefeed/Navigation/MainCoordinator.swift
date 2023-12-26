//
//  MainCoordinator.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/8/23.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    var termsButton: UIBarButtonItem?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.backgroundColor = .background
        self.navigationController.toolbar.backgroundColor = .background
        self.navigationController.toolbar.barTintColor = .foreground
    }
    
    func start() {
        let vc = GetStartedViewController.instantiate()
        vc.coordinator = self
        termsButton = UIBarButtonItem(title: "Terms & Conditions", style: .plain, target: self, action: #selector(displayTerms))
        let emptyItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        if let termsButton = termsButton {
            vc.setToolbarItems([emptyItem, termsButton, emptyItem], animated: true)
        }
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showFeedsModal() {
        let vc = FeedSelectionModalViewController.instantiate()
        vc.coordinator = self
        termsButton = UIBarButtonItem(title: "Terms & Conditions", style: .plain, target: self, action: #selector(displayTerms))
        let emptyItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        if let termsButton = termsButton {
            vc.setToolbarItems([emptyItem, termsButton, emptyItem], animated: true)
        }
        vc.viewModel = FeedSelectionViewModel()
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showMuseFeed(for feeds: [FeedOption]) {
        let vc = MuseFeedCollectionViewController.instantiate()
        vc.coordinator = self
        vc.viewModel = MuseFeedViewModel(selectedOptions: feeds)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showDetailView(for item: MuseItem) {
        let vc  = DetailViewController.instantiate()
        vc.coordinator = self
        vc.museItem = item
        navigationController.pushViewController(vc, animated: false)
    }
    
    func presentInfoPopUp(with viewModel: ItemInfoViewModel, from sender: UIBarButtonItem, delegate: UIPopoverPresentationControllerDelegate) {
        let vc = PopUpViewController.instantiate()
        vc.coordinator = self
        vc.setup(for: .info(viewModel))
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.sourceItem = sender
        vc.popoverPresentationController?.delegate = delegate
        vc.popoverPresentationController?.permittedArrowDirections = .up
        navigationController.present(vc, animated: true)
    }
    
    func presentFeedTutorialPopUp(in view: UIView, delegate: UIPopoverPresentationControllerDelegate) {
        let vc = PopUpViewController.instantiate()
        vc.coordinator = self
        vc.setup(for: .tutorial)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.popoverPresentationController?.sourceView = view
        vc.popoverPresentationController?.sourceRect = view.bounds
        vc.popoverPresentationController?.delegate = delegate
        navigationController.present(vc, animated: true)
    }
    
    @objc func displayTerms() {
        print("***** terms tapped")
    }
}
