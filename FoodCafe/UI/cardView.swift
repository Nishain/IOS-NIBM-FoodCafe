//
//  cardView.swift
//  FoodCafe
//
//  Created by Nishain on 2/28/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

class cardView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 20.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
        // Drawing code
    }
    

}
