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
        print("created")
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
                        print("should be removed")
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
 
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func addOrderToData()->[String:Any]{
        print("adding an order")
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
            print("new order added")
            //self.data.append(OrderStatus(orderID: (self.data.map({$0.orderID}).max() ?? 99) + 1, status: 1))
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
        // #warning Incomplete implementation, return the number of rows
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
