//
//  PeripheralCollectionViewController.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 11/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class PeripheralCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PeripheralViewInputAccessoryDelegate, PeripheralBLEControllerDelegate {
    
    func bleAvailabel(status: Bool) {
        bleOn = status
    }

    var bleOn = Bool()
    
    func postSended(_ success: Bool) {
        containerView.showActivityIndicator(show: false)

        if success {
            containerView.postSuccessfullySended()
            collectionView?.reloadData()
            showLastPost()

        } else {
            posts.removeLast()
            showAllert(message: alertMessage.errorWithSendingPost.rawValue)
        }
    }
    
    var posts = [Post]()
    
    func submitDataForSending(text: String) {
        if !bleOn{
            showAllert(message: alertMessage.errorWithSendingPost.rawValue)
            containerView.showActivityIndicator(show: false)
            return
        }
        
        let newPost = Post(text: text , image: nil)
        posts.append(newPost)
        
        peripheralBLEController.startAdvertising(send: true, dataToSend: text)
    }
    
    let cellId = "cellId"
    
    lazy var containerView: PeripheralViewInputAccessory = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let peripheralViewInputAccessory = PeripheralViewInputAccessory(frame: frame)
        peripheralViewInputAccessory.translatesAutoresizingMaskIntoConstraints = false
        peripheralViewInputAccessory.delegate = self
        return peripheralViewInputAccessory
    }()
    
    func removeKeyboard() {
        containerView.removeKeyboard()
    }
    
    private var peripheralBLEController = PeripheralBLEController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Peripheral"

        collectionView?.backgroundColor = .white
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0)
        collectionView?.register(PeripheralCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        setupViews()
        
        peripheralBLEController.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
                
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        peripheralBLEController.startPeripheralManager()
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {        
        guard let location = sender?.location(in: self.view)  else { return }
        
        if !containerView.frame.contains(location) {
            removeKeyboard()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PeripheralCollectionViewCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 56)
        let dummyCell = PeripheralCollectionViewCell(frame: frame)
        dummyCell.post = posts[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: 500, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 4, estimatedSize.height)
        let width = max(16 + 16 + 8, estimatedSize.width)
        
        dummyCell.textView.frame.size = CGSize(width: width, height: height)
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func showLastPost() {
        if posts.count > 0 {
            let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
            let lastItemIndex = IndexPath(item: item, section: 0)
            self.collectionView?.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.top, animated: true)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        containerViewBottomAnchor?.isActive = false
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
           
            let addHeight = keyboardSize.height - 50
            self.containerViewBottomAnchor?.constant = -addHeight
            self.containerViewBottomAnchor?.isActive = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (compleated: Bool) in
                if compleated {
                    self.showLastPost()
                }
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        containerViewBottomAnchor?.isActive = false
        
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.containerViewBottomAnchor?.constant = 0
            self.containerViewBottomAnchor?.isActive = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        peripheralBLEController.stopPeripheralAdvertising()
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    private func setupViews() {
        view.addSubview(containerView)
        
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
    }
}
