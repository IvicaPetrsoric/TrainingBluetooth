//
//  PeripheralView.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 09/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

protocol PeripheralViewDelegate: class {
    func sendDataViaBLE()
    func removeKeyboard()
}

class PeripheralView: BaseView, UITextFieldDelegate {
    
    weak var delegate: PeripheralViewDelegate?
    
    let inputTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Enter text"
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 2
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "send").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(sendData), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func setupViews() {
        addSubview(submitButton)
        addSubview(inputTextView)
        
        submitButton.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        submitButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        inputTextView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        inputTextView.rightAnchor.constraint(equalTo:  submitButton.leftAnchor, constant: -8).isActive = true
        inputTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        inputTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.endEditing(true)
        delegate?.removeKeyboard()
//        print(123)
    }
    
    @objc func sendData() {
        print("Send")
        delegate?.sendDataViaBLE()
    }    
    
    
}
