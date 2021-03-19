//
//  OrderListController.swift
//  FoodCafe
//
//  Created by Nishain on 2/28/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class OrderListController: UITableViewController {
    let db = Firestore.firestore()
    let auth = Auth.auth()
    var newOrderToAdded:[PendingOrder]? //this is single instance of new order called from parent viewController

    
    var finishedOrder:[Reciept] = []{
        //whenever this array is updated database is updated with proccessed orders
        didSet{
            updatePastOrders(finishedOrder)
        }
    }
    func updatePastOrders(_ reciepts :[Reciept]) {
        db.document("user/\(auth.currentUser!.uid)").updateData(["history":FieldValue.arrayUnion(reciepts.map{$0.asDictionary()}) ])
    }
    var data:[OrderStatus] = []
    var didDataLoaded = false //variable to hold wether data array is firstime populated with data...
    //dictionary for status constants
    let statusConstants:[Int:String] = [
        1:"waiting to accept",
        2:"Preparing Food",
        3:"ready to pickup"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        db.document("orders/\(auth.currentUser!.uid)")
            .addSnapshotListener({documentSnapshot,err in
            
            if(err == nil){
                if !documentSnapshot!.exists{
                    return
                }
                var expiredOrdersPresent = false //variable to indicate if proccessed orders present in the list of orders
        
                let orderList = (documentSnapshot!.data()?["orderList"] ?? []) as! [[String:Any]]
                self.data = []//when populating data the array is fully truncated and refreshed
            
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = DateFormatingStrings.cellDateFormat //the date format to display datetime in recipets in account viewController
                for order in orderList{
                    let orderStatus = self.mapDictionaryToData(order: order)
                    if orderStatus.isRemovable() {//check if status is other than 1-3
                        expiredOrdersPresent = true
                        self.finishedOrder.append(Reciept(date: dateFormater.string(from: Date()), products: orderStatus.orderInfo!))
                    }else{
                        self.data.append(orderStatus)
                    }
                    
                }
                if(expiredOrdersPresent){
                   /*with expiredOrdersPresent variable the databse is not unessarily called for removing inactive orders.
                     first remove orders which are inactive the update the database with updated data array.Thus this function will be called again with snaphot listener*/
                    self.data = self.data.filter{!$0.isRemovable()}//remove
                    self.db.document("orders/\(self.auth.currentUser!.uid)").updateData(["orderList":self.mapDataToDictionary()])
                }
            }
            //check if a new order is present and data has not yet populated to data array
            if(!self.didDataLoaded && self.newOrderToAdded != nil){
                let newOrder = self.addOrderToData()
                //append the orderList in databse with new order
                self.db.document("orders/\(self.auth.currentUser!.uid)").updateData(["orderList":FieldValue.arrayUnion([newOrder])])
                
                self.newOrderToAdded = nil
            }
            self.tableView.reloadData()
            self.didDataLoaded = true
        })
 
    }
    func addOrderToData()->[String:Any]{
        //when a new order arrives, the order if shall be the max id from existing data array + 1
        //for this to operate the data array should already populated with data.
        let orderToBeAdded = OrderStatus(orderID: (self.data.map({$0.orderID}).max() ?? 99) + 1, status: 1, orderInfo:newOrderToAdded)
        self.data.append(orderToBeAdded)
        return orderToBeAdded.asDictionary()
    }
    func mapDictionaryToData(order:[String:Any])->OrderStatus{
        return OrderStatus.decodeAsStruct(data: order)
    }
    func mapDataToDictionary()->[[String:Any]]{
        
        return data.map({$0.asDictionary()})

    }
    override func viewWillAppear(_ animated: Bool) {
        /*when the viewControoler is apppeared we check data array already contain data and there is a new order pressent to be added.
         addOrderToData() is called in 2 scenarios when there is new order, when data is first time loaded and after data is loaded, whenever a this viewController is visible
         */
        if(newOrderToAdded != nil && didDataLoaded){
            let newOrder = addOrderToData()
            self.newOrderToAdded = nil
            db.document("orders/\(auth.currentUser!.uid)").updateData(["orderList":FieldValue.arrayUnion([newOrder])])
        }
    }

 
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count == 0 ? 1 : data.count //if there is no data then a cell is show to user about no data
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //show a poster to user when there are no items in the list...
        if data.count == 0{
            return tableView.dequeueReusableCell(withIdentifier: "noOrder")!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderDetail") as! OrderCell
        cell.orderID.text = String(data[indexPath.row].orderID)
        
        if(data[indexPath.row].status == 3){ //if status is ready to pick then color is green
            cell.orderStatus.textColor = .green
        }else{
            cell.orderStatus.textColor = .black
        }
        cell.orderStatus.text = statusConstants[data[indexPath.row].status]
        return cell
    }
    

}
