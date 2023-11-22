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
}
