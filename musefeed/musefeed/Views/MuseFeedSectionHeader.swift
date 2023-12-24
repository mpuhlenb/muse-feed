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
    var gradientView: GradientView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupContent(for option: FeedOption?, sectionIndex: Int?) {
        backgroundColor = .clear
        guard let option = option, let sectionIndex = sectionIndex else { return }
        self.museOption = option
        // TODO: Fix up font
        self.refreshButton = SectionButton(frame: CGRect(x: 5, y: 0, width: self.frame.width, height: 20))
        self.gradientView = GradientView()
        self.refreshButton?.setup(for: option, sectionIndex: sectionIndex)
        guard let refreshButton = refreshButton, let gradientView = gradientView else { return }
        gradientView.layer.cornerRadius = 5.0
        gradientView.layer.masksToBounds = true
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gradientView)
        addSubview(refreshButton)
        addViewConstraints()
    }
    
    func addViewConstraints() {
        guard let refreshButton = refreshButton, let gradientView = gradientView else { return }
        NSLayoutConstraint.activate([
            refreshButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            refreshButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            refreshButton.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        NSLayoutConstraint.activate([
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            gradientView.topAnchor.constraint(equalTo: self.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
        ])
    }
}
