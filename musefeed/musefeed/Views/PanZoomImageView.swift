//
//  PanZoomImageView.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/22/23.
//

import UIKit

class PanZoomImageView: UIScrollView {

    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
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
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapRecognizer)
    }
    
    func setScrollImage(with imageUrl: URL) {
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
    
    @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if zoomScale == 1 {
            setZoomScale(2, animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
    }
}


extension PanZoomImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
