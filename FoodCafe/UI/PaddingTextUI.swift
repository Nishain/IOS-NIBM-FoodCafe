//
//  PaddingTextUI.swift
//  FoodCafe
//
//  Created by Nishain on 2/21/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

@IBDesignable
class PaddingTextUI: UITextField {

    @IBInspectable var padding:CGFloat = 0.0
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        //let padding = UIEdgeInsets(top: self.padding, left: padding, bottom: padding, right: padding)
        return bounds.insetBy(dx: padding, dy: padding)
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
