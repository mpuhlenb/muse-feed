//
//  SectionButton.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 12/5/23.
//

import UIKit

class SectionButton: UIButton {
    var sectionIndex: Int?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(for option: FeedOption?, sectionIndex: Int?) {
        let imagePointSize = 15.0
        let buttonFontSize = 17.0
        let imageConfig = UIImage.SymbolConfiguration(pointSize: imagePointSize)
        let image = UIImage(systemName: "arrow.2.circlepath.circle.fill", withConfiguration: imageConfig)
        self.sectionIndex = sectionIndex
        guard let option = option else { return }
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .background
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        config.imagePadding = 2
        config.image = image
        self.configuration = config
        self.configuration?.attributedTitle = AttributedString(option.feedName, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: "Verdana", size: buttonFontSize)!]))
        self.contentHorizontalAlignment = .left
        self.contentVerticalAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.tintColor = .background
        self.semanticContentAttribute = .forceLeftToRight
    }
    
    func updateIsRefreshing(to refreshing: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.configuration?.showsActivityIndicator = refreshing
        }
    }
}
