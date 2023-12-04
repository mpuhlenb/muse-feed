//
//  MuseFeedSectionHeader.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/30/23.
//

import UIKit

class MuseFeedSectionHeader: UICollectionReusableView {
    static let reuseId = "HeaderView"
    
    let sectionLabel = UILabel()
    let refreshButton = UIButton()
    var museOption: FeedOption?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent(for: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // TODO: update with actual sizing and fonts etc
    func setupContent(for option: FeedOption?) {
        self.museOption = option
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        
        // TODO: Fix up button sizing, font, image, tapping on header etc
        refreshButton.frame = CGRect(x: 15, y: 0, width: self.frame.width, height: self.frame.height)
        var config = UIButton.Configuration.plain()
        config.imagePadding = 20
        config.baseForegroundColor = .background
        config.image = UIImage(systemName: "arrow.2.circlepath.circle.fill")
        if let option = option {
            config.attributedTitle = AttributedString(option.feedName, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: "Verdana", size: 12)!]))
        }

        refreshButton.configuration = config
        refreshButton.contentHorizontalAlignment = .left
        refreshButton.contentVerticalAlignment = .center
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.imageView?.tintColor = .background
        refreshButton.semanticContentAttribute = .forceRightToLeft
        addSubview(refreshButton)
        
        NSLayoutConstraint.activate([
            refreshButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            refreshButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15.0),
            refreshButton.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    func setIsRefreshing(isRefreshing: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.refreshButton.configuration?.showsActivityIndicator = isRefreshing
        }
        
    }
}
