//
//  FeedSelectionModalViewController.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/11/23.
//

import UIKit
import Combine

class FeedSelectionModalViewController: UIViewController, Storyboarded {
    
    var coordinator: MainCoordinator?
    var feedTableView: TableView
    var feedDataSource: TableDataSource
    var viewModel: FeedSelectionViewModel?
    var feedButton: UIButton?
    
    var numberOfSelectedFeeds: Int {
        return feedTableView.visibleCells.lazy.filter({ $0.isSelected }).count
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    
    required init?(coder: NSCoder) {
        self.feedTableView = TableView(style: .plain)
        self.feedDataSource = TableDataSource(feedTableView)
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
        subscribeToViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reload()
    }
    
    private func subscribeToViewModel() {
        viewModel?.$shouldButtonEnable.sink { [weak self] shouldEnable in
            self?.feedButton?.isEnabled = shouldEnable
        }.store(in: &cancellables)
    }
    
    func reload() {
        feedDataSource.reload([
            .init(key: .feeds, values: FeedOption.allCases.map { .source($0) })
        ])
    }
    
    @objc func getItemsAction(sender: UIButton!) {
        var feedOptions: [FeedOption] = []
        for (index, option) in FeedOption.allCases.enumerated() {
            if feedTableView.visibleCells[index].isSelected == true {
                feedOptions.append(option)
            }
        }
        coordinator?.showMuseFeed(for: feedOptions)
    }
}

extension FeedSelectionModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.shouldButtonEnable(for: numberOfSelectedFeeds)
    }
    
    func getFeedOptionFor(row: Int) -> FeedOption {
        return FeedOption.allCases[row]
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // Only 2 maximum selected
        if numberOfSelectedFeeds < 2 {
            return indexPath
        } else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel?.shouldButtonEnable(for: numberOfSelectedFeeds)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        footerView.contentView.contentMode = .center
        feedButton = UIButton(type: .system)
        feedButton?.addTarget(self, action: #selector(getItemsAction), for: .touchUpInside)
        feedButton?.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        feedButton?.layer.borderWidth = 1.5
           feedButton?.layer.cornerRadius = 10.0
           feedButton?.layer.masksToBounds = true
        feedButton?.translatesAutoresizingMaskIntoConstraints = false
        feedButton?.setTitle("Get Items", for: .normal)
        feedButton?.setTitleColor(.background, for: .normal)
        feedButton?.setTitleColor(.secondary, for: .disabled)
        feedButton?.backgroundColor = .foreground
        feedButton?.isEnabled = viewModel?.shouldButtonEnable ?? false
        feedButton?.isOpaque = true
        guard let feedButton = feedButton else { return footerView }
        footerView.addSubview(feedButton)
        NSLayoutConstraint.activate([
            feedButton.widthAnchor.constraint(equalToConstant: 150),
            feedButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            feedButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        return footerView
    }
    
}


