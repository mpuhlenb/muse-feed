//
//  ItemInfoView.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 12/5/23.
//

import UIKit
// TODO: Refactor with custom label and constraints
class ItemInfoView: UIView, PopUpViewable {
    
    var popUpView: UIView = UIView(frame: .zero)
    var itemTitleLabel = UILabel(frame: .zero)
    var itemArtistLabel = UILabel(frame: .zero)
    var itemFeedTextUrl = UITextView(frame: .zero)
    var closeButton: UIButton = UIButton(type: .system)
    let borderWidth: CGFloat = 2.0
    
    var viewModel: ItemInfoViewModel?
    
    func setup() {
        guard viewModel != nil else { return }
        setupInfoView()
        setupLabels()
        setupCloseButton()
        popUpView.addSubview(itemTitleLabel)
        popUpView.addSubview(itemArtistLabel)
        popUpView.addSubview(itemFeedTextUrl)
        popUpView.addSubview(closeButton)
        addSubview(popUpView)
        addViewConstraints()
    }
    
    private func setupInfoView() {
        popUpView.backgroundColor = .background
        popUpView.layer.borderWidth = borderWidth
        popUpView.layer.cornerRadius = 10.0
        popUpView.layer.masksToBounds = true
        popUpView.layer.borderColor = UIColor.secondaryText.cgColor
    }
    
    private func setupLabels() {
        itemTitleLabel.textColor = .foreground
        itemTitleLabel.backgroundColor = .background
        itemTitleLabel.layer.masksToBounds = true
        itemTitleLabel.adjustsFontSizeToFitWidth = true
        itemTitleLabel.clipsToBounds = true
        itemTitleLabel.numberOfLines = 0
        itemTitleLabel.textAlignment = .center
        itemTitleLabel.contentMode = .center
        itemTitleLabel.text = viewModel?.itemTitle
        
        itemArtistLabel.backgroundColor = .background
        itemArtistLabel.layer.masksToBounds = true
        itemArtistLabel.adjustsFontSizeToFitWidth = true
        itemArtistLabel.textColor = .secondaryText
        itemArtistLabel.clipsToBounds = true
        itemArtistLabel.numberOfLines = 0
        itemArtistLabel.textAlignment = .center
        if let viewModel = viewModel {
            itemArtistLabel.text = viewModel.itemArtist.isEmpty ? "N/A" : viewModel.itemArtist
        }
        
        itemFeedTextUrl.isEditable = false
        itemFeedTextUrl.isUserInteractionEnabled = true
        itemFeedTextUrl.isSelectable = true
        itemFeedTextUrl.backgroundColor = .background
        itemFeedTextUrl.layer.masksToBounds = true
        itemFeedTextUrl.translatesAutoresizingMaskIntoConstraints = false
        itemFeedTextUrl.clipsToBounds = true

        
        let attributedString = NSMutableAttributedString(string: viewModel?.itemOrigin ?? "")
        guard let url = viewModel?.feedUrl else { return }
        attributedString.setAttributes([.link: url], range: NSMakeRange(0, attributedString.length))
        itemFeedTextUrl.attributedText = attributedString
        itemFeedTextUrl.linkTextAttributes = [
            .foregroundColor: UIColor.secondaryText,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        itemFeedTextUrl.textAlignment = .center
        itemFeedTextUrl.contentMode = .center
        
        
    }
    
    private func setupCloseButton() {
        closeButton.frame = CGRect(x: 0, y: 0, width: 150, height: 44)
        closeButton.layer.borderWidth = 1.5
        closeButton.layer.cornerRadius = 10.0
        closeButton.setTitleColor(UIColor.background, for: .normal)
        closeButton.layer.borderColor = UIColor.clear.cgColor
        closeButton.setTitle("Close", for: .normal)
        closeButton.backgroundColor = .foreground
    }
    
    internal func addViewConstraints() {
        // PopupView constraints
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        if DeviceConfiguration.isPad {
            NSLayoutConstraint.activate([
                popUpView.widthAnchor.constraint(equalToConstant: 293),
                popUpView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                popUpView.topAnchor.constraint(equalTo: self.topAnchor, constant: 13),
                popUpView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                popUpView.widthAnchor.constraint(equalToConstant: 293),
                popUpView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                popUpView.centerXAnchor.constraint(equalTo: self.centerXAnchor)])
        }
        
        // PopupTitle constraints
        itemTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemTitleLabel.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor, constant: (borderWidth + 5)),
            itemTitleLabel.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -(borderWidth + 5)),
            itemTitleLabel.topAnchor.constraint(equalTo: popUpView.topAnchor, constant: (borderWidth + 5)),
            itemTitleLabel.heightAnchor.constraint(equalToConstant: 55)
            ])
        
        // PopupText constraints

        itemArtistLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemArtistLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 67),
            itemArtistLabel.topAnchor.constraint(equalTo: itemTitleLabel.bottomAnchor, constant: 0),
            itemArtistLabel.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor, constant: 15),
            itemArtistLabel.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -15),
            itemArtistLabel.bottomAnchor.constraint(equalTo: itemFeedTextUrl.topAnchor, constant: -3)
            ])
        
        itemFeedTextUrl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemFeedTextUrl.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            itemFeedTextUrl.topAnchor.constraint(equalTo: itemArtistLabel.bottomAnchor, constant: 0),
            itemFeedTextUrl.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -15),
            itemFeedTextUrl.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor, constant: 15),
            itemFeedTextUrl.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -5)
        ])

        // PopupButton constraints
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor, constant: -12)
            ])
    }
}
