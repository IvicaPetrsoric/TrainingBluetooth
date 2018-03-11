//
//  PeripheralViewController.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 09/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class PeripheralViewController: UIViewController, PeripheralViewDelegate, PeripheralViewInputAccessoryDelegate {
    
    func submitDataForSending() {
        
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .white
        indicator.stopAnimating()
        return indicator
    }()
    
    lazy var containerView: PeripheralViewInputAccessory = {
        let frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 50)
        let peripheralViewInputAccessory = PeripheralViewInputAccessory(frame: frame)
        peripheralViewInputAccessory.translatesAutoresizingMaskIntoConstraints = false
        return peripheralViewInputAccessory
    }()
    
    func sendDataViaBLE() {
        peripheralBLEController.startAdvertising(send: true)
    }
    
    func removeKeyboard() {
        print("Controller")
        self.containerView.removeKeyboard()
    }
    
    private var peripheralView = PeripheralView()
    private var peripheralBLEController = PeripheralBLEController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Peripheral"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        setupViews()
        peripheralView.delegate = self
        
        peripheralBLEController.startPeripheralManager()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
//        inputAccessoryView?.layoutSubviews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if tabBarController?.tabBar.contains(touches)
//        self.view.endEditing(true)
//        print(123)
//        removeKeyboard()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        containerViewBottomAnchor?.isActive = false

        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let addHeight = keyboardSize.height - 50
                self.containerViewBottomAnchor?.constant = -addHeight
                self.containerViewBottomAnchor?.isActive = true
                
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        containerViewBottomAnchor?.isActive = false

        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.containerViewBottomAnchor?.constant = 0
                self.containerViewBottomAnchor?.isActive = true
                
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        peripheralBLEController.stopPeripheralAdvertising()
//        NotificationCenter.default.removeObserver(self)
    }
    
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    private func setupViews() {
        peripheralView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(peripheralView)
        
        peripheralView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        peripheralView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        peripheralView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        peripheralView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(containerView)
        
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
    }
}
