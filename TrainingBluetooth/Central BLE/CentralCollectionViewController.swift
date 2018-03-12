//
//  CentralViewController.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 09/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class CentralCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CentralBLEControllerDelegate {
    
    let cellId = "cellId"
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .white
        indicator.startAnimating()
        return indicator
    }()
    
    private var centralBLEcontroller = CentralBLEController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        navigationItem.title = "Central"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
                
        centralBLEcontroller.delegate = self
        centralBLEcontroller.startCentralManager()
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        centralBLEcontroller.stopScanCentralManager()
    }
    
    
    func recivedDataFromPheriperal() {
        print("RECIVED DATA FINISHED!!!!")
    }
    
}
