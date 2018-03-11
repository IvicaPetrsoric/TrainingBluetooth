//
//  PeripheralViewInputAccessory.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 10/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

protocol PeripheralViewInputAccessoryDelegate: class {
    func submitDataForSending()
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
        
        self.frame.origin.y = 100
        
        addSubview(submitImage)
        addSubview(submitButton)
        addSubview(submitTextView)
        
        submitImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        submitImage.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        submitImage.heightAnchor.constraint(equalToConstant: 42).isActive = true
        submitImage.widthAnchor.constraint(equalToConstant: 42).isActive = true
        
        submitButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        submitButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        submitTextView.leftAnchor.constraint(equalTo: submitImage.rightAnchor, constant: 8).isActive = true
        submitTextView.rightAnchor.constraint(equalTo: submitButton.leftAnchor, constant: -8).isActive = true
        submitTextView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        submitTextView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc func handleSubmit() {
        print("Send")
        delegate?.submitDataForSending()
        submitTextView.showPlaceHolderLabel()
    }
    
    @objc func handleCamera() {
        print("Camera")
    }
    
}











