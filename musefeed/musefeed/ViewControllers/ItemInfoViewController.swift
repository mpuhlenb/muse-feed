//
//  ItemInfoViewController.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/24/23.
//

import UIKit

class ItemInfoViewController: UIViewController, Storyboarded {
    var coordinator: MainCoordinator?
    
    var viewModel: ItemInfoViewModel?
    
    init(viewModel: ItemInfoViewModel?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel

    }
    
    func setupInfoView() {
        guard let viewModel = viewModel else { return }
        let infoView = ItemInfoView()
        infoView.setup(with: viewModel)
        infoView.closeButton.addTarget(self, action: #selector(dissmisView), for: .touchUpInside)
        view = infoView
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func dissmisView() {
        self.dismiss(animated: true, completion: nil)
    }
}
