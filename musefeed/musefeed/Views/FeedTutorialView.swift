//
//  FeedTutorialView.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 12/22/23.
//

import UIKit

class FeedTutorialView: UIView, PopUpViewable {
    var popUpView: UIView = UIView(frame: .zero)
    
    var closeButton: UIButton = UIButton(type: .system)
    
    
    var tutorialTextView: UILabel = UILabel(frame: .zero)
    let borderWidth: CGFloat = 2.0
    
    func setup(for type: PopUp) {
        switch type {
        case .info:
            break
        case .tutorial:
            setupPopUpView()
            setupTextView()
            setupButton()
            popUpView.addSubview(tutorialTextView)
            popUpView.addSubview(closeButton)
            addSubview(popUpView)
            self.backgroundColor = .clear
            addViewConstraints()
        }
    }
    
    func setupPopUpView() {
        popUpView.backgroundColor = .background
        popUpView.layer.borderWidth = borderWidth
        popUpView.layer.cornerRadius = 10.0
        popUpView.layer.masksToBounds = true
        popUpView.layer.borderColor = UIColor.secondaryText.cgColor
    }
    
    func setupTextView() {
        tutorialTextView.textColor = .foreground
        tutorialTextView.backgroundColor = .background
        tutorialTextView.layer.masksToBounds = true
        tutorialTextView.adjustsFontSizeToFitWidth = true
        tutorialTextView.clipsToBounds = true
        tutorialTextView.numberOfLines = 0
        tutorialTextView.textAlignment = .center
        tutorialTextView.contentMode = .center
        let fullString = NSMutableAttributedString(string: "We show you 6 random images from each of your chosen feeds. Press refresh ")
        let refreshImageAttachment = NSTextAttachment()
        refreshImageAttachment.image = UIImage(systemName: "arrow.2.circlepath.circle.fill")?.withTintColor(.foreground)
       let refreshString = NSAttributedString(attachment: refreshImageAttachment)
        fullString.append(refreshString)
        let endString = NSAttributedString(string: " to get a new set of images.\n\nTap on an image for a closer look and to view details like the work’s title and creator.")
        
        fullString.append(endString)
        tutorialTextView.attributedText = fullString
    }
    
    func setupButton() {
        closeButton.frame = CGRect(x: 0, y: 0, width: 150, height: 44)
        closeButton.layer.borderWidth = 1.5
        closeButton.layer.cornerRadius = 10.0
        closeButton.setTitleColor(UIColor.background, for: .normal)
        closeButton.layer.borderColor = UIColor.clear.cgColor
        closeButton.setTitle("Close", for: .normal)
        closeButton.backgroundColor = .foreground
    }
    
    func addViewConstraints() {
        
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popUpView.widthAnchor.constraint(equalToConstant: 293),
            popUpView.heightAnchor.constraint(equalToConstant: 200),
            popUpView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            popUpView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        tutorialTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tutorialTextView.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor, constant: 12),
            tutorialTextView.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -12),
            tutorialTextView.topAnchor.constraint(equalTo: popUpView.topAnchor, constant: 12),
            tutorialTextView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor, constant: -12)
        ])
    }
    
    
}
