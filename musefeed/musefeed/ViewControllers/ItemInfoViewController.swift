//
//  ItemInfoViewController.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/24/23.
//

import UIKit

class ItemInfoViewController: UIViewController {
    var viewModel: ItemInfoViewModel?
    
    init(viewModel: ItemInfoViewModel?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel

    }
    
    func setupInfoView() {
        guard let viewModel = viewModel else { return }
        let newInfoView = NewItemInfoView()
        newInfoView.setup(with: viewModel)
        newInfoView.closeButton.addTarget(self, action: #selector(dissmisView), for: .touchUpInside)
        view = newInfoView
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func dissmisView() {
        self.dismiss(animated: true, completion: nil)
    }
}
