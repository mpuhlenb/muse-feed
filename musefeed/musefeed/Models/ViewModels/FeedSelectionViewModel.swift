//
//  FeedSelectionViewModel.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/10/23.
//

import Foundation
import Combine



public class FeedSelectionViewModel {
    public let viewTitle = "Choose Your Feeds"
    @Published var shouldButtonEnable: Bool = false
    
    func shouldButtonEnable(for selectedItems: Int) {
        shouldButtonEnable = selectedItems == 2
    }

}
