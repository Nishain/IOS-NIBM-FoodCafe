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
        db.document("userHistory/\(42383)").updateData(["history":FieldValue.arrayUnion(reciepts.map{$0.asDictionary()}) ])
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
        print("created")
        db.document("user/\(42383)")
            .addSnapshotListener({documentSnapshot,err in
            
            if(err == nil){
                if !documentSnapshot!.exists{
                    return
                }
                var expiredOrdersPresent = false
                self.data = []
                let orderList = (documentSnapshot!.data()?["orderList"] ?? []) as! [[String:Any]]
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "dd-MM-YY HH:mm"
                for order in orderList{
                    let orderStatus = self.mapDictionaryToData(order: order)
                    if orderStatus.status > 3{
                        expiredOrdersPresent = true
                        self.finishedOrder.append(Reciept(date: dateFormater.string(from: Date()), products: orderStatus.orderInfo!))
                    }else{
                        self.data.append(orderStatus)
                    }
                    
                }
                if(expiredOrdersPresent){
                    self.data = self.data.filter{$0.status < 4}
                    self.db.document("user/\(42383)").updateData(["orderList":self.mapDataToDictionary()])
                }
            }
            if(!self.didDataLoaded && self.newOrderToAdded != nil){
                self.addOrderToData()
                self.db.document("user/\(42383)").updateData(["orderList":self.mapDataToDictionary()])
                
                self.newOrderToAdded = nil
            }
            self.tableView.reloadData()
            self.didDataLoaded = true
        })
 
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func addOrderToData(){
        print("adding an order")
        self.data.append(OrderStatus(orderID: (self.data.map({$0.orderID}).max() ?? 99) + 1, status: 1, orderInfo:newOrderToAdded))
    }
    func mapDictionaryToData(order:[String:Any])->OrderStatus{
        return OrderStatus.decodeAsStruct(data: order)
//        return OrderStatus(
//            orderID: order["orderID"] as! Int,
//            status: order["status"] as! Int,
//            orderInfo: nil /*(order["catalog"] as! [[String:Any]]).map({
//                PendingOrder(foodName: $0["foodName"] as! String,
//                            quantity: $0["quantity"] as! Int,
//                            originalPrice: $0["originalPrice"] as! Int)
//            })*/
//            //,"catalog":$0.orderInfo
//        )
    }
    func mapDataToDictionary()->[[String:Any]]{
        
        return data.map({$0.asDictionary()})
//            data.map({
//            ["orderID":$0.orderID,"status":$0.status,"catalog":$0.orderInfo!.map({f in
//                f.asDictionary()
////                [
////                    "foodName":f.foodName,
////                    "originalPrice":f.originalPrice,
////                    "quantity":f.quantity
////                ]
//
//            })]
//        })
    }
    override func viewWillAppear(_ animated: Bool) {
        if(newOrderToAdded != nil && didDataLoaded){
            print("new order added")
            //self.data.append(OrderStatus(orderID: (self.data.map({$0.orderID}).max() ?? 99) + 1, status: 1))
            addOrderToData()
            self.newOrderToAdded = nil
            db.document("user/\(42383)").updateData(["orderList":mapDataToDictionary()])
        }
    }

 
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderDetail") as! OrderCell
        cell.orderID.text = String(data[indexPath.row].orderID)
        if(data[indexPath.row].status == 3){
            cell.orderStatus.textColor = .green
        }
        cell.orderStatus.text = statusConstants[data[indexPath.row].status]
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
