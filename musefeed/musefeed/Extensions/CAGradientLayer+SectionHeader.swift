//
//  CAGradientLayer+SectionHeader.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 12/20/23.
//

import UIKit

extension CAGradientLayer {
    static func sectionHeaderGradientLayer(in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = headerColors
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return layer
    }
    
    private static var headerColors: [CGColor] {
        return [UIColor.accent.cgColor, UIColor.secondaryText.cgColor, UIColor.background.cgColor]
    }
}
