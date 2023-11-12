//
//  FeedSelectionCellModel.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/11/23.
//

import Foundation

protocol FeedSelectionCellModel {
    var feedName: String { get }
    var feedUrlString: String { get }
}
