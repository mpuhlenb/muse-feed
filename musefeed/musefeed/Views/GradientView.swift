//
//  GradientView.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 12/24/23.
//

import UIKit

class GradientView: UIView {
    var firstColor: UIColor = .accent
    var middleColor: UIColor = .secondaryText
    var lastColor: UIColor = .background
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        guard let layer = layer as? CAGradientLayer else { return }
        layer.colors = [firstColor.cgColor, middleColor.cgColor, lastColor.cgColor]
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
    }
}
