//
//  FoodCategoryCell.swift
//  FoodCafe
//
//  Created by Nishain on 2/24/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

class FoodCategoryCell: UICollectionViewCell {
    @IBOutlet weak var bodyBtn: RoundBtn!
    var userPressBtn:((UIButton)->Void)?
    @IBAction func onBtnPress(_ sender: UIButton) {
        userPressBtn?(sender)
    }
    
    
}
