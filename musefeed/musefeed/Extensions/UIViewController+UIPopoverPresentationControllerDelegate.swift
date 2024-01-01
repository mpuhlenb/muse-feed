//
//  UIViewController+UIPopoverPresentationControllerDelegate.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 1/1/24.
//

import UIKit

extension UIViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // Force popover style
        return UIModalPresentationStyle.none
    }
}
