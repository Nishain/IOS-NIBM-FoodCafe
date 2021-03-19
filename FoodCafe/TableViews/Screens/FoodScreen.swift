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

    @IBOutlet weak var activeOrderList: PendingOrderList!
    @IBOutlet weak var foodCatergories: FoodCategoryList!
    @IBOutlet weak var foodList: FoodList!
    @IBOutlet weak var cartItemCounter: UILabel!
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    @IBOutlet weak var orderBtn: RoundBtn!
    
    let db = Firestore.firestore()
    let imageStore = Storage.storage()
    
   @IBAction func onOrdered(_ sender: Any) {
    let activeOrderScreen = tabBarController!.viewControllers![1] as! OrderListController
        activeOrderScreen.newOrderToAdded = activeOrderList.data
        activeOrderList.resetList()
        tabBarController?.selectedViewController = activeOrderScreen
        
    }
    func loadData(catergory:String?){
        var foodList:[FoodDetail] = []
        var catergories:[String] = ["All"] // the first catergory type is 'all' where no filtering is applied
        
        //the all list to limited to show only first 200 foods from all catergory
        var reference = db.collection("Foods").limit(to: 200)
        if(catergory != nil){
            //if user has selected a catergory the databse use where filtering
            reference = db.collection("Foods").whereField("type", isEqualTo:catergory!)
        }
        reference.getDocuments(completion: {snapshot,err in
            if(err != nil){
               print(err)
            }
            //each docuemnt reflect detail about a single food item..
            for (index,document) in (snapshot?.documents ?? []).enumerated(){
                let food = document.data() //single food instance..
                //populating date into data model....
                var foodDetail = FoodDetail(image: nil,
                    title: food["title"] as! String,
                    foodDescription: food["description"] as? String,
                    promotion:(food["promotion"] as? Int) ?? 0,
                    cost: food["cost"] as! Int,
                    phoneNumber: food["phoneNumber"] as? String,
                    type: food["type"] as! String
                )
                //if contains a promotion field then add the promotion
                if(food.keys.contains("promotion")){
                    foodDetail.promotion = food["promotion"] as! Int
                }
                
                //if user select items from all the catergories then 'catergory' is nil
                //so the caterory list is updated by distinct catergory names of food item
                if(catergory == nil){
                    //append only if not contain promising distinct values...
                    if(!catergories.contains(foodDetail.type)){
                        catergories.append(foodDetail.type)
                    }
                }
                
                /*images are loaded afterwards the food details are loaded allowing user to view partially loaded data.
                 this is callback for image loading and later refresh the relvant cell when image is available.The image is identified by food ID - docuemnt id*/
                self.imageStore.reference(withPath: "foods/\(document.documentID).jpg").getData(maxSize: 1 * 1024 * 1024, completion: {data,imageErr in
                    
                    if(imageErr != nil){
                        
                        switch StorageErrorCode(rawValue: imageErr!._code) {
                        case .objectNotFound:
                            //if the image is not available in the database then display a default image
                            self.foodList.provideImage(index: index, newImage: #imageLiteral(resourceName: "foodDefault"))
                        default:
                            print(imageErr)
                        }
                    }else{
                        //if no error then update the revant cell against the index to with newly fetched food picture
                        self.foodList.provideImage(index: index, newImage: UIImage(data: data!))
                    }
                })
                foodList.append(foodDetail)
            }
            /*
             the food catergory List only updates when 'all' catergory selected means param 'catergory' is nil
            */
            if(catergory==nil){
                self.foodCatergories.setData(catergories)
            }
            //finally refresh the food list
            self.foodList.updateData(foodList)
            })
    }
    
    override func viewDidLoad() {
        //order btn is intially invisble since there is no order
        orderBtn.isHidden = true
        //since there there is no order the pending list is empty therefore the list height should be 0.
        heightContraint.constant = 0
        
        //when a removal or quantity change on items on the cart 'onSumChanged' is called thus changing the
        //value in total item counter and total cart cost in parent viewController (this class)
        activeOrderList.onSumChanged = {quantity,cost in
            self.orderBtn.isHidden = (cost == 0)
            self.cartItemCounter.text = "\(quantity) items"
            self.orderBtn.setTitle("Order (Rs. \(cost))", for: .normal)
        }
        //passing the cart list's height constraint to cart tableView (activeOrderList) so it can change the list height
        //dynamically when item is removed or added...
        activeOrderList.heightConstraint = heightContraint
        
        super.viewDidLoad()
        
        //onItemSelected callback is called when item is food list is selected and navigated to view full food description
        foodList.onItemSelected = {selectedDetail in
            let detailScreen = self.storyboard?.instantiateViewController(identifier: "foodDetailScreen") as! FullFoodDetailScreen
            detailScreen.foodDetail = selectedDetail
            //onOrderedRecieved is called user add the item to cart
            detailScreen.onOrderedRecieved = {
                self.activeOrderList.addOrder(foodDetail: selectedDetail) // add the item to cart
            }
            self.navigationController?.pushViewController(detailScreen, animated: false)
        }
        //callback on selecting catergory in catergory tableview
        foodCatergories.onCatergorySelected = {index,catergory in
            self.loadData(catergory: index == 0 ? nil : catergory)
        }
        //first time load fetch all foods without category filtering
        loadData(catergory: nil)
  
    }
    @IBAction func onSignOut(_ sender: Any) {
        try? Auth.auth().signOut()
        let rootNavigator = navigationController?.tabBarController?.navigationController
        let loginScreen = storyboard!.instantiateViewController(withIdentifier: "authScreen")
        rootNavigator!.setViewControllers([loginScreen], animated: true)
       
    }
    


}


