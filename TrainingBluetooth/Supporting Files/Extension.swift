//
//  Extension.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 09/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let someColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    static let tealColor = UIColor(red: 48/255, green: 164/255, blue: 182/255, alpha: 1)
    
    static let lightRed = UIColor(red: 247/255, green: 66/255, blue: 82/255, alpha: 1)
    
    static let darkBlue = UIColor(red: 9/255, green: 45/255, blue: 64/255, alpha: 1)
    
    static let lightBlue = UIColor(red: 218/255, green: 235/255, blue: 243/255, alpha: 1)
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
