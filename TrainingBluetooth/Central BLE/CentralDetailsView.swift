//
//  CentralDetailsView.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 09/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class CentralDetailsView: BaseView {
    
    let recivedDataLabel: UILabel = {
        let label = UILabel()
        label.text = "Recived data:"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let recivedTextView: UITextView = {
        let tv = UITextView()
        tv.textAlignment = .center
        tv.textColor = .black
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.text = "MArko\nasd\ndarkoMArko\nasd\ndarkoMArko\nasd\ndarkoMArko\nasd\ndarko"
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 8
        tv.layer.masksToBounds = true
        tv.layer.borderColor = UIColor.black.cgColor
        tv.layer.borderWidth = 2
        tv.isSelectable = false
        return tv
    }()
    
    override func setupViews(){        
        addSubview(recivedDataLabel)
        addSubview(recivedTextView)
        
        recivedDataLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        recivedDataLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        recivedDataLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        recivedDataLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        recivedTextView.topAnchor.constraint(equalTo: recivedDataLabel.bottomAnchor, constant: 8).isActive = true
        recivedTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        recivedTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        recivedTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
}
