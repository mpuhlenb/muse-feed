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
    @IBOutlet var backgroundView: UIImageView!
    @IBOutlet var contentBackground: UIView!
    @IBOutlet var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.image = UIImage(resource: .welcomeBackground)
        coordinator?.navigationController.navigationBar.backgroundColor = .clear
        navigationController?.setToolbarHidden(false, animated: false)
        contentBackground.layer.borderWidth = 1.5
        contentBackground.layer.cornerRadius = 10.0
        contentBackground.backgroundColor = .background
        contentBackground.layer.borderColor = UIColor.clear.cgColor
        contentBackground.alpha = 0.6
        getStartedButton.layer.borderWidth = 1.5
        getStartedButton.layer.cornerRadius = 10.0
        let welcomeText = NSMutableAttributedString(string: "Welcome to Muse Feed!\n\nAre you ready to be inspired by images from museums across the globe?\n\nYou never know what you might discover!")
        welcomeText.addAttribute(.font, value: UIFont.systemFont(ofSize: 25.0), range: NSMakeRange(0, 21))
        welcomeLabel.attributedText = welcomeText

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        navigationController?.setToolbarHidden(false, animated: true)
        coordinator?.navigationController.navigationBar.backgroundColor = .clear
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: Defaults.TermsViewed) {
            coordinator?.presentTermsPopUp(in: view, delegate: self)
        }
    }
    
    @IBAction func tappedGetStarted() {
        coordinator?.showFeedsSelection()
    }
}

