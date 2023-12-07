//
//  UIView+Spinner.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 12/7/23.
//

import UIKit

extension UIView {
    func showLoading() async {
        let loading = UIActivityIndicatorView(style: DeviceConfiguration.isPad ? .large : .medium)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.tag = DeviceConfiguration.loadingTag
        loading.startAnimating()
        loading.hidesWhenStopped = true
        addSubview(loading)
        loading.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loading.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func stopLoading() async {
        guard let loading = viewWithTag(DeviceConfiguration.loadingTag) as? UIActivityIndicatorView else { return }
        loading.stopAnimating()
        loading.removeFromSuperview()
    }
}
