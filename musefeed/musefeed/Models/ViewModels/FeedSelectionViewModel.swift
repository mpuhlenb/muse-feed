//
//  FeedSelectionViewModel.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/10/23.
//

import Foundation
import Combine



public class FeedSelectionViewModel {
    public let viewTitle = "Feed Selections (Choose 2)"
    @Published var shouldButtonEnable: Bool = false
    
    func shouldButtonEnable(for selectedItems: Int) {
        shouldButtonEnable = selectedItems == 2
    }

}
