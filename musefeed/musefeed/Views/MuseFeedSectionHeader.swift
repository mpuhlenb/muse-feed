//
//  MuseFeedSectionHeader.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/30/23.
//

import UIKit

class MuseFeedSectionHeader: UICollectionReusableView {
    static let reuseId = "HeaderView"
    
    var refreshButton: SectionButton?
    var museOption: FeedOption?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // TODO: update with actual sizing and fonts etc
    func setupContent(for option: FeedOption?, sectionIndex: Int?) {
        self.subviews.forEach { $0.removeFromSuperview() }
        guard let option = option, let sectionIndex = sectionIndex else { return }
        self.museOption = option
        setupGradientLayer()
        // TODO: Fix up font
        self.refreshButton = SectionButton(frame: CGRect(x: 5, y: 0, width: self.frame.width, height: 20))
        self.refreshButton?.setup(for: option, sectionIndex: sectionIndex)
        guard let refreshButton = refreshButton else { return }
        addSubview(refreshButton)
        NSLayoutConstraint.activate([
            refreshButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            refreshButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            refreshButton.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer.sectionHeaderGradientLayer(in: self.bounds)
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.contentMode = .scaleAspectFit
        self.layer.addSublayer(gradientLayer)
    }
}
