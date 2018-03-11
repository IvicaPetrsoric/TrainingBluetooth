//
//  PeripheralViewTextView.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 10/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class PeripheralViewTextView: UITextView {

    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Comment"
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func showPlaceHolderLabel(){
        placeHolderLabel.isHidden = false
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeHolderLabel)
        placeHolderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        placeHolderLabel.rightAnchor.constraint(equalTo:  rightAnchor, constant: -8).isActive = true
        placeHolderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        placeHolderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: .UITextViewTextDidChange, object: nil)
    }
    
    @objc func handleTextChange(){
        placeHolderLabel.isHidden = !self.text.isEmpty
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}














