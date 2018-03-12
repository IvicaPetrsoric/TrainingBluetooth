//
//  CentralViewController.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 09/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class CentralCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CentralBLEControllerDelegate {
    
    var posts = [Post]()
    
    let cellId = "cellId"
    
    private var centralBLEcontroller = CentralBLEController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        navigationItem.title = "Central"
        
        let infoButton = UIButton(type: .infoLight)
        
        // You will need to configure the target action for the button itself, not the bar button itemr
//        infoButton.addTarget(self, action: #selector(getInfoAction), for: .touchUpInside)
        
        // Create a bar button item using the info button as its custom view
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        // Use it as required
        navigationItem.rightBarButtonItem = infoBarButtonItem
        
        centralBLEcontroller.delegate = self
        centralBLEcontroller.startCentralManager()
        
        collectionView?.register(CentralCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CentralCollectionViewCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 56)
        let dummyCell = CentralCollectionViewCell(frame: frame)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        centralBLEcontroller.stopScanCentralManager()
    }
    
    
    func recivedDataFromPheriperal(post: Post) {
        posts.append(post)
        collectionView?.reloadData()
        let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
        let lastItemIndex = IndexPath(item: item, section: 0)
        self.collectionView?.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.top, animated: true)
    }
    
}
