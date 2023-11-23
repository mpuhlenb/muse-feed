//
//  TableView.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/11/23.
//

import UIKit

open class TableView: UITableView {
    
    public init(style: UITableView.Style = .plain) {
        super.init(frame: .zero, style: style)
//        initialize()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   func intialize() {
       self.backgroundColor = UIColor(resource: .background)
     translatesAutoresizingMaskIntoConstraints = false
       allowsMultipleSelection = true
    }
    
    func layoutConstraints(in view: UIView) -> [NSLayoutConstraint] {
        [
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
    }
}
