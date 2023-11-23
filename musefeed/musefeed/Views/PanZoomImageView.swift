//
//  PanZoomImageView.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/22/23.
//

import UIKit

class PanZoomImageView: UIScrollView {
    var imageUrl: URL? {
        didSet {
            guard let imageUrl = imageUrl else { return }
            Task {
                do {
                    let data = try await imageView.downloadImageData(from: imageUrl)
                    let image = UIImage(data: data)
                    imageView.image = image
                } catch {
                    print("**** error getting image")
                }
            }
        }
    }
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
//    convenience init(imageUrl: URL) {
//        self.init(frame: .zero)
//        self.imageUrl = imageUrl
//    }
    
    private func commonInit() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        minimumZoomScale = 1
        maximumZoomScale = 3
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
    }
}

extension PanZoomImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
