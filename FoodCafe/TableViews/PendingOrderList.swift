//
//  PendingOrderList.swift
//  FoodCafe
//
//  Created by Nishain on 2/23/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

class PendingOrderList:UITableView {
    
    var data:[PendingOrder] = [
        PendingOrder(foodName:"burger",quantity:4,originalPrice :250),
        PendingOrder(foodName:"pizza",quantity:2,originalPrice :456),
        PendingOrder(foodName:"burger",quantity:4,originalPrice :250)
    ]
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        delegate = self
        dataSource = self
    }
    

    // MARK: - Table view data source
}

extension PendingOrderList : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingOrder", for: indexPath) as! PendingOrderCell
        cell.information = data[indexPath.row]
        cell.itemName.text = data[indexPath.row].foodName
        cell.itemPrice.text = String(data[indexPath.row].originalPrice * data[indexPath.row].quantity)
        cell.qty.text = String(data[indexPath.row].quantity)
        cell.onQuantityChange = {change in
            let currentValue = Int(cell.qty.text!)!
            if(change == -1 && currentValue == 1){
                self.data.remove(at: indexPath.row)
                self.reloadData()
                return
            }
            
            cell.qty.text = String(currentValue + change)
            cell.itemPrice.text = String(cell.information!.originalPrice * cell.information!.quantity)
        }
                 // Configure the cell...

        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
        /*override func numberOfSections(in tableView: UITableView) -> Int {
               // #warning Incomplete implementation, return the number of sections
               return 0
           }

           override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               // #warning Incomplete implementation, return the number of rows
               return 0
           }
     
           */
         
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


