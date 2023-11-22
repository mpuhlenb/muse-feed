//
//  UITableView+Cell.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/11/23.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ type: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func reuse<T: UITableViewCell>(_ type: T.Type, _ indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }

    var reuseIdentifier: String {
        type(of: self).reuseIdentifier
    }
}

public extension UITableView {
    func select(_ indexPaths: [IndexPath],
                animated: Bool = true,
                scrollPosition: UITableView.ScrollPosition = .none) {
        for indexPath in indexPaths {
            selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        }
    }
    

    func deselect(_ indexPaths: [IndexPath], animated: Bool = true) {
        for indexPath in indexPaths {
            deselectRow(at: indexPath, animated: animated)
        }
    }
    
    func deselectAll(animated: Bool = true) {
        deselect(indexPathsForSelectedRows ?? [], animated: animated)
    }
}
