//
//  PeripheralCollectionViewCell.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 11/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class PeripheralCollectionViewCell: BaseCell {
    
    var post: Post? {
        didSet{
            if let postText = post?.text {
                textView.text = postText
            }
        }
    }
    
    // add image in textView
    /*
     let textView = UITextView(frame: CGRectMake(50, 50, 200, 300))
     let attributedString = NSMutableAttributedString(string: "before after")
     let textAttachment = NSTextAttachment()
     textAttachment.image = UIImage(named: "sample_image.jpg")!
     
     let oldWidth = textAttachment.image!.size.width;
     
     //I'm subtracting 10px to make the image display nicely, accounting
     //for the padding inside the textView
     let scaleFactor = oldWidth / (textView.frame.size.width - 10);
     textAttachment.image = UIImage(CGImage: textAttachment.image!.CGImage, scale: scaleFactor, orientation: .Up)
     var attrStringWithImage = NSAttributedString(attachment: textAttachment)
     attributedString.replaceCharactersInRange(NSMakeRange(6, 1), withAttributedString: attrStringWithImage)
     textView.attributedText = attributedString;
     self.view.addSubview(textView)
 */
    
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
        
//        textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
//        textView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        textView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
}
