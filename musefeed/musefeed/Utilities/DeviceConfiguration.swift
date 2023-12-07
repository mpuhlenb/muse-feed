//
//  DeviceConfiguration.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 12/7/23.
//

import Foundation
import UIKit

struct DeviceConfiguration {
    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    static var loadingTag: Int {
        return 350
    }
}
