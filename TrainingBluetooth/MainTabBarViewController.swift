//
//  MainTabBarViewController.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 09/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewsController()
    }
    
    private func setupViewsController() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let centralViewController = templateNavController(unselectedImage: #imageLiteral(resourceName: "first"), selectedImage: #imageLiteral(resourceName: "first"),
                                                          collectionRootViewController: CentralCollectionViewController(collectionViewLayout: layout))
        
        let peripheralViewController = templateNavController(unselectedImage: #imageLiteral(resourceName: "second"), selectedImage: #imageLiteral(resourceName: "second"),
                                                             collectionRootViewController: PeripheralCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        viewControllers = [centralViewController, peripheralViewController]
//        viewControllers = [peripheralViewController, centralViewController]
        
        //  modify tab bar insets
        guard let items = tabBar.items else { return }
        
        for item in items{
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    private func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, collectionRootViewController collectionRootVC: UICollectionViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: collectionRootVC)
        navController.tabBarItem.image = unselectedImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navController.tabBarItem.selectedImage = selectedImage

        return navController
    }
    
}
