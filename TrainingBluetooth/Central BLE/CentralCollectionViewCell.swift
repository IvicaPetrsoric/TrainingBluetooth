//
//  CentralCollectionViewCell.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 12/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class CentralCollectionViewCell: BaseCell {
    
    var post: Post? {
        didSet{
            if let postText = post?.text {
                textView.text = postText
            }
        }
    }
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 2
        return textView
    }()
    
    override func setupViews() {
        addSubview(textView)
        
        textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
}
