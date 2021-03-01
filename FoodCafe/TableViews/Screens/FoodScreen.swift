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
    @IBOutlet weak var foodCatergories: FoodCategoryList!
    @IBOutlet weak var foodList: FoodList!
    @IBOutlet weak var cartItemCounter: UILabel!
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    @IBOutlet weak var orderBtn: RoundBtn!
    
    let db = Firestore.firestore()
    let imageStore = Storage.storage()
    
    func loadData(catergory:String?){
        var foodList:[FoodDetail] = []
        var catergories:[String] = ["All"]
        var reference = db.collection("Foods").limit(to: 200)
        if(catergory != nil){
            reference = reference.whereField("type", isEqualTo:catergory!)
        }
        reference.getDocuments(completion: {snapshot,err in
            if(err != nil){
               print(err)
            }
            for (index,document) in (snapshot?.documents ?? []).enumerated(){
                let food = document.data()
                var foodDetail = FoodDetail(image: nil,
                    title: food["title"] as! String,
                    foodDescription: food["description"] as! String,
                    promotion:(food["promotion"] as? Int) ?? 0,
                    cost: food["cost"] as! Int,
                    phoneNumber: food["phoneNumber"] as! Int,
                    type: food["type"] as! String
                )
                if(food.keys.contains("promotion")){
                    foodDetail.promotion = food["promotion"] as! Int
                }
                if(catergory == nil){
                    catergories.append(foodDetail.type)
                }
                
                self.imageStore.reference(withPath: "foods/\(document.documentID).jpg").getData(maxSize: 1 * 1024 * 1024, completion: {data,imageErr in
                    print("foods/\(document.documentID).jpg")
                    if(imageErr != nil){
                        print(imageErr)
                    }else{
                        self.foodList.provideImage(index: index, newImage: UIImage(data: data!))
                    }
                })
                foodList.append(foodDetail)
            }
            if(catergory==nil){
                self.foodCatergories.setData(catergories)
            }
            self.foodList.updateData(foodList)
            })
    }
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
        foodCatergories.onCatergorySelected = {index,catergory in
            self.loadData(catergory: index == 0 ? nil : catergory)
        }
        loadData(catergory: nil)
        // Do any additional setup after loading the view.
    }
    @IBAction func onSignOut(_ sender: Any) {
        try? Auth.auth().signOut()
       // let authenticateScreen = storyboard!.instantiateViewController(identifier: "authScreen")
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

