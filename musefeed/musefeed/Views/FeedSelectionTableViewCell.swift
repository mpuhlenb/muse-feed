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
        
        if state.isHighlighted || state.isSelected {
            contentConfig.image = UIImage(systemName: "checkmark")
        }
        contentConfiguration = contentConfig
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
