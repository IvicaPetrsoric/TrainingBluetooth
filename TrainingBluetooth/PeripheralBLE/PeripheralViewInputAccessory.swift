//
//  PeripheralViewInputAccessory.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 10/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

protocol PeripheralViewInputAccessoryDelegate: class {
    func submitDataForSending(text: String)
}

class PeripheralViewInputAccessory: BaseView {
    
    var delegate: PeripheralViewInputAccessoryDelegate?
    
    let submitImage: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "camera").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCamera), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let submitTextView: PeripheralViewTextView = {
        let tv = PeripheralViewTextView()
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        tv.layer.cornerRadius = 8
        tv.layer.masksToBounds = true
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.layer.borderWidth = 2
        return tv
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .white
        indicator.color = .tealColor
        indicator.stopAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "send").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func removeKeyboard() {
        submitTextView.endEditing(true)
        submitTextView.resignFirstResponder()
    }
    
    override func setupViews() {
        backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        
        autoresizingMask = .flexibleHeight
        
        addSubview(submitImage)
        addSubview(submitButton)
        addSubview(submitTextView)
        addSubview(activityIndicator)
        
        submitImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        submitImage.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        submitImage.heightAnchor.constraint(equalToConstant: 42).isActive = true
        submitImage.widthAnchor.constraint(equalToConstant: 42).isActive = true
        
        submitButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        submitButton.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        submitTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        submitTextView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        submitTextView.leftAnchor.constraint(equalTo: submitImage.rightAnchor, constant: 8).isActive = true
        submitTextView.rightAnchor.constraint(equalTo: submitButton.leftAnchor, constant: -8).isActive = true
        
        activityIndicator.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 44).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
            submitButton.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            submitButton.isHidden = false
        }
    }
    
    func postSuccessfullySended() {
        submitTextView.text = nil
        submitTextView.showPlaceHolderLabel()
    }
    
    @objc func handleSubmit() {
        guard let textToSend = submitTextView.text, textToSend.count > 0 else { return }

        showActivityIndicator(show: true)

        delegate?.submitDataForSending(text: textToSend)
    }
    
    @objc func handleCamera() {
        print("Camera")
    }
    
}











