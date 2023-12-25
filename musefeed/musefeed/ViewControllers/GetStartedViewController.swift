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
        welcomeLabel.text = "Welcome to Muse Feed! Are you ready to be inspired by images from museums across the globe? You never know what you might discover!"
        welcomeLabel.textColor = .foreground

    }

    @IBAction func tappedGetStarted() {
        coordinator?.showFeedsModal()
    }
}

