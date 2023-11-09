//
//  Storyboarded.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/8/23.
//

import UIKit

protocol Storyboarded {
    var coordinator: MainCoordinator? { get }
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboad = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        return storyboad.instantiateViewController(withIdentifier: className) as! Self
    }
}
