//
//  MainTabBarViewController.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 09/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        let index = viewControllers?.index(of: viewController)
        
//        if index == 1 {
//            let navController = UINavigationController(rootViewController: PeripheralViewController())
////            self.navigationController?.pushViewController(navController, animated: true)
//            if let controller = self.viewControllers![0] as? CentralViewController {
//                navigationController?.pushViewController(navController, animated: true)
//            }
////            self.childViewControllers.pushViewController(navController, animated: true)
//
////            present(navController, animated: true, completion: nil)
//
//
//            return false
//        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        setupViewsController()
    }
    
    private func setupViewsController() {
        let centralViewController = templateNavController(unselectedImage: #imageLiteral(resourceName: "first"), selectedImage: #imageLiteral(resourceName: "first"), rootViewController: CentralViewController())
        let peripheralViewController = templateNavController(unselectedImage: #imageLiteral(resourceName: "second"), selectedImage: #imageLiteral(resourceName: "second"), rootViewController: PeripheralViewController())
        
        viewControllers = [centralViewController, peripheralViewController]
//        viewControllers = [peripheralViewController, centralViewController]
        
        //  modify tab bar insets
        guard let items = tabBar.items else { return }
        
        for item in items{
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    private func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController rootVC: UIViewController = UIViewController()) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootVC)
        navController.tabBarItem.image = unselectedImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navController.tabBarItem.selectedImage = selectedImage

        return navController
    }
    
}
