//
//  ConnectionInfoBLE.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 12/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class ConnectionInfoBLE: UIView {

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    @objc func handleClose(){
        containerViewBottomAnchor?.isActive = false
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 150)
        containerViewBottomAnchor?.isActive = true
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
            self.alpha = 0
        }, completion: { (compleated: Bool) in
            if compleated {
                self.removeFromSuperview()
            }
        })
    }
    
    let headerLabel: UILabel = {
        var label = UILabel()
        label.text = "Info"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dividerLine: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let leftLabels: UILabel = {
        var label = UILabel()
        label.text = "Status:\nConnected to:\nRSSI:"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rightLabels: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var width = CGFloat()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        width = frame.width
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(connectedTo: String, RSSI: String) {
        if connectedTo.isEmpty && RSSI.isEmpty {
            rightLabels.text = "Not Connected\n/\n/"
        }
        else if connectedTo.isEmpty {
            rightLabels.text = "Bad signal \n / \n\(RSSI)"
        }
        else {
            rightLabels.text = "Connected\n\(connectedTo)\n\(RSSI)"
        }
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setupViews() {
        alpha = 0
        backgroundColor = UIColor.clear
        
        addSubview(containerView)
        containerView.addSubview(closeButton)
        containerView.addSubview(headerLabel)
        containerView.addSubview(dividerLine)
        containerView.addSubview(leftLabels)
        containerView.addSubview(rightLabels)
        
        containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        containerViewBottomAnchor?.isActive = true
        
        closeButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        closeButton.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        headerLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: closeButton.bottomAnchor).isActive = true

        dividerLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        dividerLine.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        dividerLine.topAnchor.constraint(equalTo: closeButton.bottomAnchor).isActive = true
        dividerLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        leftLabels.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        leftLabels.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        leftLabels.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 8).isActive = true
        leftLabels.widthAnchor.constraint(equalToConstant: width / 2).isActive = true
        
        rightLabels.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        rightLabels.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        rightLabels.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 8).isActive = true
        rightLabels.widthAnchor.constraint(equalToConstant: width / 2).isActive = true
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 1
        })
    }
    
}
