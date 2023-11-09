//
//  GetStartedViewController.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/5/23.
//

import UIKit

class GetStartedViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    
    @IBOutlet var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tappedGetStarted() {
        coordinator?.showFeedsModal()
    }
}
