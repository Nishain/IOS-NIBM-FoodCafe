//
//  RoundBtn.swift
//  FoodCafe
//
//  Created by Nishain on 2/21/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

@IBDesignable
class RoundBtn: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable var borderRadius: CGFloat = 0.0{
        didSet{
            self.layer.cornerRadius = frame.height / 2
        }
        
    }
    @IBInspectable var padding:CGFloat = 0.0{
        didSet{
            contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        }
    }
    override func contentRect(forBounds bounds: CGRect) -> CGRect {
       // self.layer.cornerRadius = layer.frame.height / 2
        let padding = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
               return bounds.inset(by: padding)
    }

}
