//
//  ItemInfoViewController.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/24/23.
//

import UIKit

class ItemInfoViewController: UIViewController {
    private let infoView = ItemInfoView()
    
    init(title: String, text: String, buttonText: String = "Close") {
        super.init(nibName: nil, bundle: nil)
        
        infoView.infoTitle.text = title
        infoView.infoText.text = text
        infoView.closeButton.titleLabel?.text = buttonText
        infoView.closeButton.addTarget(self, action: #selector(dissmisView), for: .touchUpInside)
        view = infoView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dissmisView() {
        self.dismiss(animated: true, completion: nil)
    }
}
