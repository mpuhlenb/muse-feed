//
//  TermsView.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 12/30/23.
//

import UIKit
import PDFKit


// TODO: Swap magic strings for defaults
class TermsView: UIView, PopUpViewable {
    
    var popUpView: UIView = UIView(frame: .zero)
    var termsPdfView: PDFView = PDFView(frame: .zero)
    var acceptanceButton: UIButton = UIButton(type: .system)
    var closeButton: UIButton = UIButton(type: .system)
    let borderWidth: CGFloat = 2.0
    
    var checkBoxImage: UIImage? {
        return Defaults.termsHasBeenViewed ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
    }
    
    func setup() {
        setupPopUpView()
        setupTermsPdfView()
        setupAcceptButton()
        setupCloseButton()
        addSubviews()
        addViewConstraints()
    }

    private func addSubviews() {
        popUpView.addSubview(termsPdfView)
        popUpView.addSubview(acceptanceButton)
        popUpView.addSubview(closeButton)
        addSubview(popUpView)
    }
    
    private func setupPopUpView() {
        popUpView.backgroundColor = .background
        popUpView.layer.borderWidth = borderWidth
        popUpView.layer.cornerRadius = 10.0
        popUpView.layer.masksToBounds = true
        popUpView.layer.borderColor = UIColor.secondaryText.cgColor
    }
    
    private func setupTermsPdfView() {
        termsPdfView.backgroundColor = .clear
        termsPdfView.isUserInteractionEnabled = true
        termsPdfView.layer.masksToBounds = true
        guard let path = Bundle.main.url(forResource: Defaults.termsFileName, withExtension: "pdf") else { return }
        if let document = PDFDocument(url: path) {
            termsPdfView.autoScales = true
            termsPdfView.document = document
        }
    }
    
    private func setupAcceptButton() {
        acceptanceButton.frame = CGRect(x:0, y: 0, width: popUpView.frame.width, height: 44)
        acceptanceButton.setTitle("Check box to accept Terms and Conditions", for: .normal)
        acceptanceButton.tintColor = .foreground
        acceptanceButton.layer.borderColor = UIColor.clear.cgColor
        acceptanceButton.backgroundColor = .clear
        acceptanceButton.setImage(checkBoxImage, for: .normal)
        acceptanceButton.isEnabled = !Defaults.termsHasBeenViewed
        acceptanceButton.isHidden = Defaults.termsHasBeenViewed
        acceptanceButton.addTarget(self, action: #selector(tappedAcceptanceButton), for: .touchUpInside)
        
    }
    
    @objc func tappedAcceptanceButton() {
        closeButton.isEnabled.toggle()
        let defaults = UserDefaults.standard
        defaults.set(closeButton.isEnabled, forKey: Defaults.TermsViewed)
        acceptanceButton.setImage(checkBoxImage, for: .normal)
    }
    
    private func setupCloseButton() {
        closeButton.frame = CGRect(x: 0, y: 0, width: 150, height: 44)
        closeButton.layer.borderWidth = 1.5
        closeButton.layer.cornerRadius = 10.0
        closeButton.setTitleColor(UIColor.background, for: .normal)
        closeButton.layer.borderColor = UIColor.clear.cgColor
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(UIColor.secondaryText, for: .disabled)
        closeButton.backgroundColor = .foreground
        closeButton.isEnabled = Defaults.termsHasBeenViewed
    }
    
    func addViewConstraints() {
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popUpView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            popUpView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            popUpView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            popUpView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            popUpView.topAnchor.constraint(equalTo: self.topAnchor),
            popUpView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            
        ])

        
        termsPdfView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            termsPdfView.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor),
            termsPdfView.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor),
            termsPdfView.topAnchor.constraint(equalTo: popUpView.topAnchor),
            termsPdfView.bottomAnchor.constraint(equalTo: acceptanceButton.topAnchor, constant: -5)
        ])
        
        acceptanceButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            acceptanceButton.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor),
            acceptanceButton.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor),
            acceptanceButton.topAnchor.constraint(equalTo: termsPdfView.bottomAnchor, constant: 5),
            acceptanceButton.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -5),
            acceptanceButton.heightAnchor.constraint(equalToConstant: 44),
            acceptanceButton.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor)
        ])
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor, constant: -18)
        ])
    }
}
