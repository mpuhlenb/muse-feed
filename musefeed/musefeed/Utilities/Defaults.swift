//
//  Defaults.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 12/23/23.
//

import Foundation

struct Defaults {
    static let TutorialViewed = "TutorialViewed"
    
    static var tutorialHasBeenViewed: Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: TutorialViewed)
    }
}
