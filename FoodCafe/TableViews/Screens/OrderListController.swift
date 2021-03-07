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
    var newOrderToAdded:[PendingOrder]?

    
    var finishedOrder:[Reciept] = []{
        didSet{
            updatePastOrders(finishedOrder)
        }
    }
    func updatePastOrders(_ reciepts :[Reciept]) {
        db.document("user/\(auth.currentUser!.uid)").updateData(["history":FieldValue.arrayUnion(reciepts.map{$0.asDictionary()}) ])
    }
    var data:[OrderStatus] = []//[OrderStatus(orderID: 345, status: "On the way")]
    var didDataLoaded = false
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
                var expiredOrdersPresent = false
        
                let orderList = (documentSnapshot!.data()?["orderList"] ?? []) as! [[String:Any]]
                self.data = []
            
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = DateFormatingStrings.cellDateFormat
                for order in orderList{
                    let orderStatus = self.mapDictionaryToData(order: order)
                    if orderStatus.isRemovable() {
                        expiredOrdersPresent = true
                        self.finishedOrder.append(Reciept(date: dateFormater.string(from: Date()), products: orderStatus.orderInfo!))
                    }else{
                        self.data.append(orderStatus)
                    }
                    
                }
                if(expiredOrdersPresent){
                   // let dataToBeRemoved = self.data.filter{$0.isRemovable()}
                    self.data = self.data.filter{!$0.isRemovable()}
                    self.db.document("orders/\(self.auth.currentUser!.uid)").updateData(["orderList":self.mapDataToDictionary()])
                }
            }
            if(!self.didDataLoaded && self.newOrderToAdded != nil){
                let newOrder = self.addOrderToData()
                self.db.document("orders/\(self.auth.currentUser!.uid)").updateData(["orderList":FieldValue.arrayUnion([newOrder])])
                
                self.newOrderToAdded = nil
            }
            self.tableView.reloadData()
            self.didDataLoaded = true
        })
 
    }
    func addOrderToData()->[String:Any]{
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
        return data.count == 0 ? 1 : data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if data.count == 0{
            return tableView.dequeueReusableCell(withIdentifier: "noOrder")!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderDetail") as! OrderCell
        cell.orderID.text = String(data[indexPath.row].orderID)
        if(data[indexPath.row].status == 3){
            cell.orderStatus.textColor = .green
        }else{
            cell.orderStatus.textColor = .black
        }
        cell.orderStatus.text = statusConstants[data[indexPath.row].status]
        return cell
    }
    

}
