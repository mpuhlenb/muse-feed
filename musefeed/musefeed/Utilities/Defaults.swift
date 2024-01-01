//
//  Defaults.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 12/23/23.
//

import Foundation

struct Defaults {
    static let TutorialViewed = "TutorialViewed"
    static let TermsViewed = "TermsViewed"
    
    static var tutorialHasBeenViewed: Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: TutorialViewed)
    }
    
    static var termsHasBeenViewed: Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: TermsViewed)
    }
    
    static let termsFileName: String = "TermsAndConditions"
    
    static let privacyUrl: URL? = URL(string: "https://concisioncomms.com/musefeed-privacy-policy/")
}
