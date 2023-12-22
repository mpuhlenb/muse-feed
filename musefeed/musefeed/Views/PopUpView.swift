//
//  PopUpView.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 12/22/23.
//

import UIKit

enum PopUp {
    case info(ItemInfoViewModel)
    case tutorial
}

protocol PopUpViewable {
    var popUpView: UIView { get set }
    var closeButton: UIButton { get set }
    func setup(for type: PopUp)
    func addViewConstraints()
}
