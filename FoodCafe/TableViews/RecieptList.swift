//
//  RecieptList.swift
//  FoodCafe
//
//  Created by Nishain on 2/28/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

class RecieptList: UITableView, UITableViewDelegate, UITableViewDataSource {

    var data:[Reciept] = [Reciept(date: "2/4/22", products: [
        PendingOrder(foodName: "food 1", quantity: 43, originalPrice: 23),
        PendingOrder(foodName: "food 2", quantity: 12, originalPrice: 45)
    ])]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecieptCell") as! DailyRecieptCell
        let reciept = data[indexPath.row]
        cell.date.text = reciept.date
        cell.priceFrequencyList.text = ""
        cell.itemList.text = ""
        for r in reciept.products{
            cell.itemList.text! += "\(r.foodName)\n"
            cell.priceFrequencyList.text! += "\(r.quantity) x Rs.\(r.originalPrice)\n"
        }
        cell.totalPrice.text = String(reciept.totalCost)
        return cell
    }
    func updateData(_ data:[Reciept]){
        self.data = data
        reloadData()
    }

    required init?(coder: NSCoder) {
        super.init(coder:coder)
        delegate = self
        dataSource = self
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}
