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
    let sectionRefreshButton = UIButton()
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
        sectionLabel.frame = CGRect(x: 10, y: 0 , width: self.frame.width, height: self.frame.height)
        sectionLabel.font = UIFont(name: "Montserratarm-Medium", size: 8)
        addSubview(sectionLabel)
        sectionLabel.contentMode = .center
        NSLayoutConstraint.activate([
            sectionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15.0),
            sectionLabel.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    // TODO: Update with animated refresh image?
    func setSectionText(with feedName: String) {
        let fullString = NSMutableAttributedString(string: feedName + "   ")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "arrow.2.circlepath.circle.fill")?.withTintColor(.background)
        
        let imageString = NSAttributedString(attachment: imageAttachment)
        fullString.append(imageString)
        sectionLabel.isUserInteractionEnabled = true
        sectionLabel.attributedText = fullString
    }
}
