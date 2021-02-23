//
//  AvatarImage.swift
//  FoodCafe
//
//  Created by Nishain on 2/23/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit
@IBDesignable
class AvatarImage: UIImageView {
    @IBInspectable var roundBorder:Bool = true{
        didSet{
            if(roundBorder){
                layer.cornerRadius = frame.height / 2
            }
            
        }
    }
}
