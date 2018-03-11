//
//  CentralViewController.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 09/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class CentralViewController: UIViewController, CentralBLEControllerDelegate {
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .white
        indicator.startAnimating()
        return indicator
    }()
    
    private var centralBLEcontroller = CentralBLEController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Central"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        setupViews()
        
        centralBLEcontroller.delegate = self
        centralBLEcontroller.startCentralManager()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        centralBLEcontroller.stopScanCentralManager()
    }
    
    private func setupViews() {
        let detailsView = CentralDetailsView()
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(detailsView)
        
        detailsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        detailsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        detailsView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        detailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func recivedDataFromPheriperal() {
        print("RECIVED DATA FINISHED!!!!")
    }
    
}
