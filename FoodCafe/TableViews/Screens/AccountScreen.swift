//
//  AccountScreen.swift
//  FoodCafe
//
//  Created by Nishain on 2/28/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit
import Firebase
class AccountScreen: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    let db = Firestore.firestore()
    let auth = Auth.auth()
    var storage = Storage.storage()
    @IBOutlet weak var displayName: UITextField!
    @IBOutlet weak var contactDisplay: UITextField!
    @IBOutlet weak var profileImage: AvatarImage!
    @IBOutlet weak var profileEditDoneBtn: RoundBtn!
    
    
    var username:String?
    @IBOutlet weak var overallTotal: UILabel!
    var contactNo:String?
    var data:[Reciept] = []
    @IBOutlet weak var beforeDate: UITextField!
    @IBOutlet weak var toDate: UITextField!
    @IBOutlet weak var billList: RecieptList!
    var currentPhoneNumber:String?
    let dateFormatter = DateFormatter()
    
    func loadData(){
        db.document("user/\(auth.currentUser!.uid)").addSnapshotListener({snapshotDocuement,err in
            
            if(err != nil){
                print(err)
                return
            }
            self.data = []
            self.currentPhoneNumber = snapshotDocuement?.data()?["phoneNumber"] as! String?
            self.contactDisplay.text = self.currentPhoneNumber
            
            let history = (snapshotDocuement?.data()?["history"] as? [[String:Any]]) ?? []
            for entity in history{
                var reciept = Reciept.decodeAsStruct(data: entity)
                reciept.totalCost = reciept.products.map({$0.originalPrice * $0.quantity}).reduce(0, +)
                self.data.append(reciept)
            }
            self.refreshData(newData: self.data)
            })
    }
    @objc func onEditingProfileField(field:UITextField){
        profileEditDoneBtn.isHidden = false
    }
    @IBAction func doneEditingProfile(_ sender: UIButton) {
        profileEditDoneBtn.isHidden = true
        displayName.endEditing(true)
        contactDisplay.endEditing(true)
        let alertPop = AlertPopup(self)
        if contactDisplay.text?.count == 0{
            return alertPop.infoPop(title: "Missing fields", body: "Contact Number field is empty!")
        }
        if(Int(contactDisplay.text!) == nil || contactDisplay.text!.count != 10){
            alertPop.infoPop(title: "Invalid Contact Number", body: "Your contact no should be 10 digits long number!")
        }
        if displayName.text?.count == 0 {
            print("display name is empty")
            displayName.text = nil
        }
        let changeRequest = auth.currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName.text
        changeRequest?.commitChanges(completion: nil)
        if self.displayName.text?.count == 0 {
            self.displayName.text = self.auth.currentUser?.email
        }
        if currentPhoneNumber != contactDisplay.text{
            db.document("user/\(auth.currentUser!.uid)").updateData(["phoneNumber":contactDisplay.text!])
        }
    }
    func setupDatePicker(textField:UITextField,tag:Int){
        textField.tag = tag
        
        //setting intial date ...
        textField.text = tag == 2 ? dateFormatter.string(from: Date()) : "from begining"
        
        //setting the tags
        let datePickerView = UIDatePicker()
                   datePickerView.datePickerMode = .date
        datePickerView.tag = tag
        datePickerView.backgroundColor = .white
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
        
        dateFormatter.dateFormat = DateFormatingStrings.dateOnly
        contactDisplay.text = auth.currentUser?.phoneNumber
        super.viewDidLoad()
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(_:))))
        displayName.text = (auth.currentUser?.displayName?.count ?? 0) == 0  ? auth.currentUser?.email : auth.currentUser?.displayName
        contactDisplay.text = contactNo
        
        setupDatePicker(textField: beforeDate, tag: 1)
        setupDatePicker(textField: toDate, tag: 2)
        
        loadData()
        setUpProfileEditingFields()
        loadProfilePicture()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    func loadProfilePicture(){
       let reference = storage.reference(withPath: "user/\(auth.currentUser!.uid)")
        profileImage.showSkeleton()
        reference.getData(maxSize: 1 * 1024 * 1024, completion: {data,error in
            if data != nil{
                self.profileImage.hideSkeleton()
                self.profileImage.image = UIImage(data: data!)
            }else{
                if(StorageErrorCode(rawValue: error!._code) == StorageErrorCode.objectNotFound){
                    return //no image yet
                }else{
                    print(error)
                }
                
            }
        })
    }
    func refreshData(newData:[Reciept]) {
        self.overallTotal.text = String(newData.map{$0.totalCost}.reduce(0,+))
        self.billList.updateData(newData)
    }
    func filterData(fromDate:String,toDate:String){
        let foreignDataFormater = DateFormatter()
        foreignDataFormater.dateFormat = DateFormatingStrings.cellDateFormat
        print("fromDate \(fromDate) toDate \(toDate)")
        let filteredData = data.filter{
            
            let timeStrippedDateString = dateFormatter.string(from: foreignDataFormater.date(from: $0.date)!)
            print("timeStrippedDateString \(timeStrippedDateString)")
            let isLowerBoundSatisfied = dateFormatter.date(from: timeStrippedDateString)! >= dateFormatter.date(from: fromDate)!
            let isUpperBoundSatisfied = dateFormatter.date(from: timeStrippedDateString)! <= dateFormatter.date(from: toDate)!
            print("a \(isLowerBoundSatisfied) b \(isUpperBoundSatisfied)")
            return isLowerBoundSatisfied && isUpperBoundSatisfied
            
        }
        refreshData(newData: filteredData)
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
    
    //needs to be removed later....
    @objc func handleDatePicker(sender: UIDatePicker) {
        print("called handleDatePicker")
        
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
        
       if sender.tag == 2{
            let beforeDatePicker = beforeDate.inputView as! UIDatePicker
            beforeDatePicker.maximumDate = focusedFieldDatePicker.date
            beforeDate.text = dateFormatter.string(from: beforeDatePicker.date)
       }
       focusedField.text = dateFormatter.string(from: focusedFieldDatePicker.date)
        filterData(fromDate: beforeDate.text!, toDate: toDate.text!)
    }
//   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//       self.view.endEditing(true)
//   }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        var image = info[.originalImage] as! UIImage
        profileImage.showSkeleton()
        image = resizeImage(image: image, targetSize: CGSize(width: profileImage.frame.width, height: profileImage.frame.height))
        storage.reference(withPath: "user/\(auth.currentUser!.uid)")
            .putData(image.pngData()!, metadata: nil) {metaData,error in
                if error == nil{
                    self.profileImage.hideSkeleton()
                    self.profileImage.image = image
                }else{
                    print(error)
                }
            }
    }
    func setUpProfileEditingFields(){
        displayName.addTarget(self, action: #selector(onEditingProfileField(field:)), for: .editingDidBegin)
        contactDisplay.addTarget(self, action: #selector(onEditingProfileField(field:)), for: .editingDidBegin)
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
