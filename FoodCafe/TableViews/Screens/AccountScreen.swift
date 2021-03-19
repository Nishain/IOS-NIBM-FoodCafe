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
    var isOnlySingleItemAdded = false
    let BEGINING_OF_TIME = "from begining"
    func loadData(){
        db.document("user/\(auth.currentUser!.uid)").addSnapshotListener({snapshotDocuement,err in
            
            if(err != nil){
                print(err)
                return
            }
            var history = (snapshotDocuement?.data()?["history"] as? [[String:Any]]) ?? []
            
            //check if the change in the databse is due to change in phone number only.Then no need to refresh the data again
            let isPhoneNumberEditedOnly = (history.count == self.data.count && self.currentPhoneNumber != (snapshotDocuement?.data()?["phoneNumber"] as! String?) ?? nil)
            self.currentPhoneNumber = snapshotDocuement?.data()?["phoneNumber"] as! String?
            self.contactDisplay.text = self.currentPhoneNumber
            if isPhoneNumberEditedOnly{
                return //no need to update the data
            }
           
            self.isOnlySingleItemAdded = ((history.count - self.data.count) == 1)
            self.data = []
            if self.isOnlySingleItemAdded{
                history = [history.last!]
            }
            for entity in history{
     
                var reciept = Reciept.decodeAsStruct(data: entity)//decode the dictionary entity back to structure
                //the total cost will sum of products unit price * quantity in single reciept
                reciept.totalCost = reciept.products.map({$0.originalPrice * $0.quantity}).reduce(0, +)
                self.data.append(reciept)
            }
            //refresh data based on date filtering
            self.filterData(fromDate: self.beforeDate.text!, toDate: self.toDate.text!)
            })
    }
    //show the edit done button when editing start user profile texfields
    @objc func onEditingProfileField(field:UITextField){
        profileEditDoneBtn.isHidden = false
    }
    @IBAction func doneEditingProfile(_ sender: UIButton) {
        profileEditDoneBtn.isHidden = true
        //force stop editing
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
            displayName.text = nil
        }
        let changeRequest = auth.currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName.text
        changeRequest?.commitChanges(completion: nil)
        //if the user remove the display name - when display string length is 0 then display the email...
        if self.displayName.text?.count == 0 && self.displayName.text != self.auth.currentUser?.email{
            self.displayName.text = self.auth.currentUser?.email
        }
        //the updathe phoneNumber in database when there is a change only...
        if currentPhoneNumber != contactDisplay.text{
            db.document("user/\(auth.currentUser!.uid)").updateData(["phoneNumber":contactDisplay.text!])
        }
    }
    
    //setting the dataTime pick texfields
    //tag 1 - before date
    //tag 3 - after date
    func setupDatePicker(textField:UITextField,tag:Int){
        textField.tag = tag
        
        //setting intial date ...
        textField.text = tag == 2 ? dateFormatter.string(from: Date()) //today date
            : BEGINING_OF_TIME
        
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
        
       /*
         setting the secondary button
         before date - the from beging of time
         after date - set for today date
        */
        var secondaryFunctionButton:UIBarButtonItem
        if tag == 1{
            secondaryFunctionButton = UIBarButtonItem(title: "From begining of time", style: .plain, target: self, action: #selector(onSetttingBegingOfTime(sender:)))
        }else{
            secondaryFunctionButton = UIBarButtonItem(title: "Set Today", style: .plain, target: self, action: #selector(onSettingTodayDate(sender:)))
        }
        doneButton.tag = tag
        //setting the toolbar
        let buttonList = [UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),secondaryFunctionButton,doneButton]
        toolBar.setItems(buttonList, animated: true)

        textField.inputAccessoryView = toolBar
    }
    @objc func onSettingTodayDate(sender:UIBarButtonItem){
        let datePicker = toDate.inputView as! UIDatePicker
        datePicker.date = Date()
        endEditingDate(sender: sender)
    }
    @objc func onSetttingBegingOfTime(sender:UIBarButtonItem){
        beforeDate.text = BEGINING_OF_TIME
        beforeDate.endEditing(true)
        //start refreshing data
        filterData(fromDate: beforeDate.text!, toDate: toDate.text!)
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
    
        
    }
    func loadProfilePicture(){
       let reference = storage.reference(withPath: "user/\(auth.currentUser!.uid)")
        profileImage.showAnimatedGradientSkeleton()
        reference.getData(maxSize: 1 * 1024 * 1024, completion: {data,error in
            if data != nil{
                self.profileImage.hideSkeleton()
                self.profileImage.image = UIImage(data: data!)
            }else{
                if(StorageErrorCode(rawValue: error!._code) == StorageErrorCode.objectNotFound){
                    self.profileImage.hideSkeleton()
                    return //no image yet
                }else{
                    print(error)
                }
                
            }
        })
    }
    //refresh the data in the tableView
    func refreshData(newData:[Reciept]) {
        //updating total cost of all fitered items
        self.overallTotal.text = String(newData.map{$0.totalCost}.reduce(0,+))
        self.billList.updateData(newData,isOnlySingleItemAdded) //indicate that no need to update entire tableView if isOnlySingleItemAdded is true - only just append to end of tableView
        isOnlySingleItemAdded = false
    }
    
    //function to filter the list of reciept by date
    func filterData(fromDate:String,toDate:String){
        let foreignDataFormater = DateFormatter()
        foreignDataFormater.dateFormat = DateFormatingStrings.cellDateFormat
        let filteredData = data.filter{
            /*Stripping the time component from date instnace this is because in example if after date is set today and if recipet has date like today + 8:30 AM then isUpperBoundSatisfied is never satisfied its after the today date.
             isLowerBoundSatisfied - before date condition, always satisfied if from begining of time
             isUpperBoundSatisfied - after date condition
             */
            let timeStrippedDateString = dateFormatter.string(from: foreignDataFormater.date(from: $0.date)!)
            let isLowerBoundSatisfied = (fromDate == BEGINING_OF_TIME) || dateFormatter.date(from: timeStrippedDateString)! >= dateFormatter.date(from: fromDate)!
            let isUpperBoundSatisfied = dateFormatter.date(from: timeStrippedDateString)! <= dateFormatter.date(from: toDate)!
        
            return isLowerBoundSatisfied && isUpperBoundSatisfied
            
        }
        refreshData(newData: filteredData)
    }
    
    //when avatar image is tapped user is promt to select a file from the gallery
    @objc func profileImageTapped(_: Any){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = ["public.image"]
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.modalPresentationStyle = .fullScreen
        present(imagePickerController,animated: true)
    }
    
   
    @objc func endEditingDate(sender:UIBarButtonItem){
        let focusedField:UITextField = sender.tag == 1 ? beforeDate : toDate
        let focusedFieldDatePicker = focusedField.inputView as! UIDatePicker
        focusedField.endEditing(true)
        
       if sender.tag == 2{
            let beforeDatePicker = beforeDate.inputView as! UIDatePicker
            beforeDatePicker.maximumDate = focusedFieldDatePicker.date
            if beforeDate.text != BEGINING_OF_TIME{
                beforeDate.text = dateFormatter.string(from: beforeDatePicker.date)
            }
       }
        focusedField.text = dateFormatter.string(from: focusedFieldDatePicker.date)
        filterData(fromDate: beforeDate.text!, toDate: toDate.text!)
    }

    //this function is called user finished selecting an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        var image = info[.originalImage] as! UIImage //retrieve the image
        //start displaying skeleton loading on avatar image
        profileImage.showAnimatedGradientSkeleton()
        //we should resize the image or takes very lont time for image upload
        image = resizeImage(image: image, targetSize: CGSize(width: profileImage.frame.width, height: profileImage.frame.height))
        storage.reference(withPath: "user/\(auth.currentUser!.uid)")
            //saving the profile image by user image id as png file
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
