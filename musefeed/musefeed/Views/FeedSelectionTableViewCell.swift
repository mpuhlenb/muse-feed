//
//  FeedSelectionTableViewCell.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/11/23.
//

import UIKit

class FeedSelectionTableViewCell: UITableViewCell {

    var cellModel: FeedSelectionCellModel?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        var contentConfig = defaultContentConfiguration().updated(for: state)
        contentConfig.text = cellModel?.feedName
        contentConfig.textProperties.color = UIColor(resource: .foreground)
        contentConfig.secondaryText = cellModel?.feedDescription
        contentConfig.secondaryTextProperties.adjustsFontSizeToFitWidth = true
        if state.isHighlighted || state.isSelected {
            contentConfig.image = UIImage(systemName: "checkmark.square.fill")
        } else {
            contentConfig.image = UIImage(systemName: "square")
        }
        contentConfig.image?.withTintColor(.secondaryText)

        contentConfiguration = contentConfig
        self.backgroundColor = UIColor(resource: .background)
    }
}
