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
class AccountScreen: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    let db = Firestore.firestore()
    let auth = Auth.auth()
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contactNoLabel: UILabel!
    @IBOutlet weak var profileImage: AvatarImage!
    
    var username:String?
    @IBOutlet weak var overallTotal: UILabel!
    var contactNo:String?
    var data:[Reciept] = []
    @IBOutlet weak var beforeDate: UITextField!
    @IBOutlet weak var toDate: UITextField!
    @IBOutlet weak var billList: RecieptList!
    func loadData(){
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
    }
    
    func setupDatePicker(textField:UITextField,tag:Int){
        textField.tag = tag
        
        //setting intial date ...
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        textField.text = dateFormatter.string(from: Date())
        
        //setting the tags
        let datePickerView = UIDatePicker()
                   datePickerView.datePickerMode = .date
        datePickerView.tag = tag
        if(tag == 2){
            datePickerView.maximumDate = Date()
        }else{
            datePickerView.maximumDate = Date()
        }
        
        //setting the tool bar buttons
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(endEditingDate(sender:)))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        textField.inputView = datePickerView
        
       // datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .edi)
        doneButton.tag = tag
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)

        textField.inputAccessoryView = toolBar
    }
    override func viewDidLoad() {
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(_:))))
        usernameLabel.text = auth.currentUser?.displayName
        contactNoLabel.text = contactNo
        
        super.viewDidLoad()
        
        setupDatePicker(textField: beforeDate, tag: 1)
        setupDatePicker(textField: toDate, tag: 2)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    @objc func profileImageTapped(_: Any){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = ["public.image"]
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.modalPresentationStyle = .fullScreen
        present(imagePickerController,animated: true)
    }
    @objc func handleDatePicker(sender: UIDatePicker) {
        print("called handleDatePicker")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        if sender.tag == 2{
            (beforeDate.inputView as! UIDatePicker).maximumDate = sender.date
        }
        let focusedField:UITextField = sender.tag == 1 ? beforeDate : toDate
        focusedField.text = dateFormatter.string(from: sender.date)
    }
    @objc func endEditingDate(sender:UIBarButtonItem){
        let focusedField:UITextField = sender.tag == 1 ? beforeDate : toDate
        let focusedFieldDatePicker = focusedField.inputView as! UIDatePicker
        focusedField.endEditing(true)
        
        let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "dd MMM yyyy"
       if sender.tag == 2{
            let beforeDatePicker = beforeDate.inputView as! UIDatePicker
            beforeDatePicker.maximumDate = focusedFieldDatePicker.date
            beforeDate.text = dateFormatter.string(from: beforeDatePicker.date)
       }
       focusedField.text = dateFormatter.string(from: focusedFieldDatePicker.date)
    }
//   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//       self.view.endEditing(true)
//   }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        profileImage.image = info[.originalImage] as? UIImage
    }
}
