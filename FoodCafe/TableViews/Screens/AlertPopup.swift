//
//  AlertPopup.swift
//  FoodCafe
//
//  Created by Nishain on 3/1/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import Foundation
import UIKit
class AlertPopup{
    let context:UIViewController
    init(_ context:UIViewController) {
        self.context = context
    }
    
    func infoPop(title:String,body:String){
        let alert = UIAlertController(title: title, message:body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        context.present(alert,animated: true)
    }
}
