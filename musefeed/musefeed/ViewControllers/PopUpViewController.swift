//
//  PopUpViewController.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/24/23.
//

import UIKit

class PopUpViewController: UIViewController, Storyboarded {
    var coordinator: MainCoordinator?
    
    var popUp: PopUpViewable?
    
    func setup(for type: PopUp) {
        switch type {
        case .info(let viewModel):
            popUp = ItemInfoView()
            guard let popUp = popUp as? ItemInfoView else { return }
            popUp.viewModel = viewModel
        case .tutorial:
            popUp = FeedTutorialView()
        case .terms:
            popUp = TermsView()
        }
        popUp?.setup()
        popUp?.closeButton.addTarget(self, action: #selector(dissmisView), for: .touchUpInside)
        guard let popUp = popUp as? UIView else { return }
        view = popUp
    }
    
    @objc func dissmisView() {
        self.dismiss(animated: true, completion: nil)
    }
}
