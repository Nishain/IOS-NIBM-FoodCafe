//
//  FoodScreen.swift
//  FoodCafe
//
//  Created by Nishain on 2/23/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

class FoodScreen: UIViewController {

    @IBOutlet weak var orderQty: PendingOrderList!
    @IBOutlet weak var foodCatergories: UICollectionView!
    @IBOutlet weak var foodList: UITableView!
    @IBOutlet weak var cartItemCounter: UILabel!
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    @IBOutlet weak var orderBtn: RoundBtn!
    
    override func viewDidLoad() {
        orderQty.onSumChanged = {quantity,cost in
            self.cartItemCounter.text = "\(quantity) items"
            self.orderBtn.setTitle("Rs. \(cost)", for: .normal)
        }
        orderQty.heightConstraint = heightContraint
        super.viewDidLoad()
       
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

