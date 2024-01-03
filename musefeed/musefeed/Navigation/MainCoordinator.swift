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
    
    var toolBarButtons: [UIBarButtonItem] {
        return [emptyItem, termsButton, privacyButton, emptyItem]
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.backgroundColor = .clear
        self.navigationController.navigationBar.barTintColor = .background
        self.navigationController.toolbar.backgroundColor = .clear
        self.navigationController.toolbar.barTintColor = .background
    }
    
    func start() {
        let vc = GetStartedViewController.instantiate()
        vc.coordinator = self
        vc.setToolbarItems(toolBarButtons, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    
    
    func showFeedsSelection() {
        let vc = FeedSelectionViewController.instantiate()
        vc.coordinator = self
        vc.viewModel = FeedSelectionViewModel()
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showMuseFeed(for feeds: [FeedOption]) {
        let vc = MuseFeedCollectionViewController.instantiate()
        vc.coordinator = self
        self.navigationController.navigationBar.backgroundColor = .background
        vc.viewModel = MuseFeedViewModel(selectedOptions: feeds)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showDetailView(for item: MuseItem) {
        let vc  = DetailViewController.instantiate()
        vc.coordinator = self
        vc.museItem = item
        self.navigationController.navigationBar.backgroundColor = .background
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
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.popoverPresentationController?.sourceView = view
        vc.view.frame = view.bounds
        vc.popoverPresentationController?.delegate = delegate
        navigationController.present(vc, animated: true)
    }
    
    func presentTermsPopUp(in view: UIView, delegate: UIPopoverPresentationControllerDelegate) {
        let vc = PopUpViewController.instantiate()
        vc.coordinator = self
        vc.setup(for: .terms)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.popoverPresentationController?.sourceView = view
        vc.popoverPresentationController?.sourceRect = view.bounds
        vc.popoverPresentationController?.delegate = delegate
        navigationController.present(vc, animated: true)
    }
    
    func displayPrivacy() {
        guard let privacyUrl = Defaults.privacyUrl else { return }
        UIApplication.shared.open(privacyUrl)
    }
}
