//
//  MainCoordinator+ToolBarUsable.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 12/27/23.
//

import UIKit

protocol ToolBarUsable {
    var termsButton: UIBarButtonItem { get }
    var privacyButton: UIBarButtonItem { get }
    var emptyItem: UIBarButtonItem { get }
    func tappedTermsButton()
    func tappedPrivacyButton()
}

extension MainCoordinator: ToolBarUsable {
    var termsButton: UIBarButtonItem {
        return UIBarButtonItem(title: "Terms & Conditions", style: .plain, target: self, action: #selector(tappedTermsButton))
    }
    
    var privacyButton: UIBarButtonItem {
        return UIBarButtonItem(title: "Privacy Policy", style: .plain, target: self, action: #selector(tappedPrivacyButton))
    }
    
    var emptyItem: UIBarButtonItem {
        return UIBarButtonItem(systemItem: .flexibleSpace)
    }
    
    @objc func tappedTermsButton() {
        guard let view = navigationController.topViewController?.view, let delegate = navigationController.topViewController as? UIPopoverPresentationControllerDelegate else { return }
        self.presentTermsPopUp(in: view, delegate: delegate)
    }
    
    @objc func tappedPrivacyButton() {
        self.displayPrivacy()
    }
}
