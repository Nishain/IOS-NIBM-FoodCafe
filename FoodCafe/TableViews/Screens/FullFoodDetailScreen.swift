//
//  FullFoodDetailScreen.swift
//  FoodCafe
//
//  Created by Nishain on 2/25/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

class FullFoodDetailScreen: UIViewController {

    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var foodDescription: UILabel!
    @IBOutlet weak var promotion: UIPaddingLabel!
    var foodDetail:FoodDetail!
    override func viewDidLoad() {
        super.viewDidLoad()
        foodImage.image = foodDetail.image
        name.text = foodDetail.title
        price.text = "Rs. \(foodDetail.cost)"
        foodDescription.text = foodDetail.foodDescription
        if(foodDetail.promotion == 0){
            promotion.isHidden = true
        }else{
            promotion.text = "\(foodDetail.promotion)% OFF"
        }
        
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
