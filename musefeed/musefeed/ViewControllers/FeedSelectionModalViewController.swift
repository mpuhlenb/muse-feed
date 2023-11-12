//
//  FeedSelectionModalViewController.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/11/23.
//

import UIKit

class FeedSelectionModalViewController: UIViewController, Storyboarded {
    
    var coordinator: MainCoordinator?
    var feedTableView: TableView
    var feedDataSource: DataSource
    var viewModel: FeedSelectionViewModel?
    
    required init?(coder: NSCoder) {
        self.feedTableView = TableView(style: .insetGrouped)
        self.feedDataSource = DataSource(feedTableView)
        super.init(coder: coder)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        feedTableView.intialize()
        view.addSubview(feedTableView)
        NSLayoutConstraint.activate(feedTableView.layoutConstraints(in: view))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel?.viewTitle
        feedTableView.register(FeedSelectionTableViewCell.self)
        feedTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reload()
    }
    
    func reload() {
        feedDataSource.reload([
            .init(key: .feeds, values: FeedOption.allCases.map { .source($0) })
        ])
    }
}

extension FeedSelectionModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// coming soon...
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        /// coming soon...
    }
}


