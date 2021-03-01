//
//  FoodScreen.swift
//  FoodCafe
//
//  Created by Nishain on 2/23/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit
import Firebase
class FoodScreen: UIViewController {

    @IBOutlet weak var orderQty: PendingOrderList!
    @IBOutlet weak var foodCatergories: UICollectionView!
    @IBOutlet weak var foodList: FoodList!
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
        foodList.onItemSelected = {selectedDetail in
            let detailScreen = self.storyboard?.instantiateViewController(identifier: "foodDetailScreen") as! FullFoodDetailScreen
            detailScreen.foodDetail = selectedDetail
            self.navigationController?.pushViewController(detailScreen, animated: false)
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func onSignOut(_ sender: Any) {
        
        try? Auth.auth().signOut()
        print("user signed out")
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

