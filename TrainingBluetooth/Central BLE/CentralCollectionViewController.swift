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
    
    lazy var infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.addTarget(self, action: #selector(handleInfoButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        navigationItem.title = "Central"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        centralBLEcontroller.delegate = self
        
        collectionView?.register(CentralCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        centralBLEcontroller.startCentralManager()
    }
    
    @objc func handleInfoButton() {        
        if let keyWindow = UIApplication.shared.keyWindow{
            let infoView = ConnectionInfoBLE(frame: keyWindow.frame)
            infoView.setupData(connectedTo: centralBLEcontroller.peripheralDevice, RSSI: centralBLEcontroller.peripheralRSSI)
            infoView.translatesAutoresizingMaskIntoConstraints = false

            keyWindow.addSubview(infoView)
            
            infoView.rightAnchor.constraint(equalTo: keyWindow.rightAnchor).isActive = true
            infoView.leftAnchor.constraint(equalTo: keyWindow.leftAnchor).isActive = true
            infoView.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor).isActive = true
            infoView.topAnchor.constraint(equalTo: keyWindow.topAnchor).isActive = true
        }
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
