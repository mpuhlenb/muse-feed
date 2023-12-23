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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.backgroundColor = .background
    }
    
    func start() {
        let vc = GetStartedViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showFeedsModal() {
        let vc = FeedSelectionModalViewController.instantiate()
        vc.coordinator = self
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
}
