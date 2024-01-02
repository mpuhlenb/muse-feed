//
//  UIImageView+Helpers.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 12/4/23.
//

import UIKit

extension UIImageView {    
    func setImage(from url: URL) async {
        await showLoading()
        do {
            let image = try await ImageLoader.shared.loadImage(from: url)
            self.image = image
            await stopLoading()
        } catch {
            await stopLoading()
        }
    }
}
