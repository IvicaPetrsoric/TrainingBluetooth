//
//  BaseCell.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 11/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}
