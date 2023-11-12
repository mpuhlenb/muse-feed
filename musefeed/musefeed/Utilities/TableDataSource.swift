//
//  DataSource.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/12/23.
//

import UIKit

final class TableDataSource: UITableViewDiffableDataSource<TableSection, TableSectionItem> {
    
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.reuse(FeedSelectionTableViewCell.self, indexPath)
            cell.selectionStyle = .none
            switch itemIdentifier {
            case .source(let model):
                cell.cellModel = model
            }
            return cell
        }
    }
    
    func reload(_ data: [TableSectionData], animated: Bool = true) {
        var snapshot = snapshot()
        snapshot.deleteAllItems()
        for item in data {
            snapshot.appendSections([item.key])
            snapshot.appendItems(item.values, toSection: item.key)
        }
        apply(snapshot, animatingDifferences: animated)
    }
}
