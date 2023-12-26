//
//  GetStartedViewController.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/5/23.
//

import UIKit

class GetStartedViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    @IBOutlet var welcomeLabel: UILabel!
    
    @IBOutlet var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator?.navigationController.setToolbarHidden(false, animated: false)
        getStartedButton.layer.borderWidth = 1.5
        getStartedButton.layer.cornerRadius = 10.0
        let welcomeText = NSMutableAttributedString(string: "Welcome to Muse Feed!\n\nAre you ready to be inspired by images from museums across the globe?\n\nYou never know what you might discover!")
        welcomeText.addAttribute(.font, value: UIFont.systemFont(ofSize: 25.0), range: NSMakeRange(0, 21))
        welcomeLabel.attributedText = welcomeText
        welcomeLabel.textColor = .foreground

    }

    @IBAction func tappedGetStarted() {
        coordinator?.showFeedsModal()
    }
}

