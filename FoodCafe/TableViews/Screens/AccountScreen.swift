//
//  AccountScreen.swift
//  FoodCafe
//
//  Created by Nishain on 2/28/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class AccountScreen: UIViewController {
    let db = Firestore.firestore()
    let auth = Auth.auth()
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contactNoLabel: UILabel!
    
    var username:String?
    @IBOutlet weak var overallTotal: UILabel!
    var contactNo:String?
    var data:[Reciept] = []
    @IBOutlet weak var beforeDate: UITextField!
    @IBOutlet weak var billList: RecieptList!
    override func viewDidLoad() {
        usernameLabel.text = auth.currentUser?.displayName
        contactNoLabel.text = contactNo
        db.document("userHistory/\(42383)").addSnapshotListener({snapshotDocuement,err in
            if(err != nil){
                print(err)
                return
            }
            self.data = []
            let history = (snapshotDocuement?.data()?["history"] as? [[String:Any]]) ?? []
            for entity in history{
                let reciept = Reciept.decodeAsStruct(data: entity)
                reciept.products.map({$0.originalPrice * $0.quantity}).reduce(0, +)
//                var dateCategory:Reciept? = self.data.first(where: {$0.date == reciept.date})
//                if(dateCategory != nil){
//                    dateCategory!.products += reciept.products
//                    dateCategory!.totalCost = dateCategory!.products.map({$0.originalPrice * $0.quantity}).reduce(0, +)
//                }else{
//                    self.data.append(reciept)
//                }
                
                self.data.append(reciept)
            }
            self.overallTotal.text = String(self.data.map{$0.totalCost}.reduce(0,+))
            self.billList.updateData(self.data)
        })
        super.viewDidLoad()
        
        let datePickerView = UIDatePicker()
                   datePickerView.datePickerMode = .date
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.endEditingDate(sender:)))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        beforeDate.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        beforeDate.inputAccessoryView = toolBar
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        beforeDate.text = dateFormatter.string(from: sender.date)
    }
    @objc func endEditingDate(sender:UITextField){
        sender.endEditing(true)
    }
//   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//       self.view.endEditing(true)
//   }

}
