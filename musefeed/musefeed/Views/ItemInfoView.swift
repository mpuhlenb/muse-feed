//
//  ItemInfoView.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/24/23.
//

import UIKit

class ItemInfoView: UIView {
    // TODO: refactor information provided and view design, colors.
    let infoView = UIView(frame: CGRect.zero)
    let infoTitle = UILabel(frame: CGRect.zero)
    let infoText = UILabel(frame: CGRect.zero)
    let closeButton = UIButton(frame: CGRect.zero)
    
    let BorderWidth: CGFloat = 2.0
    
    init() {
        super.init(frame: CGRect.zero)
        // Semi-transparent background
//        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // Popup Background
        infoView.backgroundColor = .white
        infoView.layer.borderWidth = BorderWidth
        infoView.layer.masksToBounds = true
        infoView.layer.borderColor = UIColor.white.cgColor
        
        // Popup Title
        infoTitle.textColor = .foreground
        infoTitle.backgroundColor = .background
        infoTitle.layer.masksToBounds = true
        infoTitle.adjustsFontSizeToFitWidth = true
        infoTitle.clipsToBounds = true
        infoTitle.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        infoTitle.numberOfLines = 1
        infoTitle.textAlignment = .center
        
        // Popup Text
        infoText.textColor = .secondaryText
        infoText.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        infoText.numberOfLines = 0
        infoText.textAlignment = .center
        
        // Popup Button
        closeButton.setTitleColor(UIColor.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        closeButton.setTitle("Close", for: .normal)
        closeButton.backgroundColor = .black
        
        infoView.addSubview(infoTitle)
        infoView.addSubview(infoText)
        infoView.addSubview(closeButton)
        
        // Add the popupView(box) in the ItemInfoView (semi-transparent background)
        addSubview(infoView)
        
        
        // PopupView constraints
        infoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoView.widthAnchor.constraint(equalToConstant: 293),
            infoView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        
        // PopupTitle constraints
        infoTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoTitle.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: BorderWidth),
            infoTitle.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -BorderWidth),
            infoTitle.topAnchor.constraint(equalTo: infoView.topAnchor, constant: BorderWidth),
            infoTitle.heightAnchor.constraint(equalToConstant: 55)
            ])
        
        
        // PopupText constraints
        infoText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoText.heightAnchor.constraint(greaterThanOrEqualToConstant: 67),
            infoText.topAnchor.constraint(equalTo: infoTitle.bottomAnchor, constant: 8),
            infoText.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 15),
            infoText.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -15),
            infoText.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -8)
            ])

        
        // PopupButton constraints
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: BorderWidth),
            closeButton.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -BorderWidth),
            closeButton.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -BorderWidth)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
