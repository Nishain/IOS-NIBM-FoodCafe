//
//  AuthScreen.swift
//  FoodCafe
//
//  Created by Nishain on 2/25/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class AuthScreen: UIViewController {

    enum FunctionMode{
        case login
        case register
    }
    @IBOutlet weak var email: PaddingTextUI!
    @IBOutlet weak var phonenumber: PaddingTextUI!
    @IBOutlet weak var password: PaddingTextUI!
    @IBOutlet weak var confirmPassword: PaddingTextUI!
    @IBOutlet weak var primaryBtn: RoundBtn!
    @IBOutlet weak var secondaryBtn: UIButton!
    @IBOutlet weak var forgetPassword: UIButton!
    @IBOutlet weak var toast: Toast!
    var currentMode = FunctionMode.register
    var alertPop:AlertPopup!
    let auth = Auth.auth()
    override func viewDidLoad() {
//        let screen  = storyboard!.instantiateViewController(identifier: "homeScreen")
//        screen.modalPresentationStyle = .overCurrentContext
//        present(screen,animated: true)
        alertPop = AlertPopup(self)
    
        super.viewDidLoad()
        swapFunctioningMode()
        toast.isHidden = true
        // Do any additional setup after loading the view.
    }
    @IBAction func onForgetPassword(_ sender: Any) {
        if isEmpty([email]){
            return alertPop.infoPop(title: "Field Empty", body: "You should at least provide your email address for forget password")
        }
        auth.sendPasswordReset(withEmail: email.text!, completion: {error in
            if error == nil{
                self.showtoast(message: "A Email is successfully submited to \(self.email.text ?? "undefined")")
            }else{
                self.alertEmailValidationErrorIfPresent(err: error!)
            }
        })
    }
    func alertEmailValidationErrorIfPresent(err:Error){
        var message:String?
        switch AuthErrorCode(rawValue: err._code) {
        case .emailAlreadyInUse:
            message = "email is already in use.Please use another email"
        case.invalidEmail,.invalidRecipientEmail:
            message = "Invalid email address.Please enter a valid one"
        default:
            message = nil
        }
        if(message != nil){
            alertPop.infoPop(title: "Email field error", body: message!)
        }
    }
    func showtoast(message:String){
        toast.isHidden = false
        toast.alpha = 1.0
        toast.text = message
        UIView.animate(withDuration: 1.0, delay: 3, options: .curveEaseOut, animations: {
            self.toast.alpha = 0.0
        }, completion: {(isCompleted) in
            self.toast.isHidden = true
        })
    }
    @IBAction func primaryBtnTaped(_ sender: UIButton) {
        if currentMode == .login{
            loginUser()
        }else{
            registerUser()
        }
    }
    @IBAction func secondaryBtnTaped(_ sender: Any) {
        swapFunctioningMode()
    }
    
    func swapFunctioningMode(){
        currentMode = (currentMode == .login) ? .register:.login
        confirmPassword.isHidden = (currentMode == .login)
        phonenumber.isHidden = (currentMode == .login)
        forgetPassword.isHidden = (currentMode == .register)
        primaryBtn.setTitle(currentMode == .login ? "Login" : "Register", for: .normal)
        secondaryBtn.setTitle(currentMode == .login ? "Register?" : "Login?", for: .normal)
        
    }
    func moveToMainScreen() {
        let mainScreen = self.storyboard!.instantiateViewController(identifier: "homeScreen")
        navigationController?.setViewControllers([mainScreen], animated: true)
    }
    func loginUser(){
        if(isEmpty([email,password])){
            return alertPop.infoPop(title: "Field error", body: "Some fields are empty")
        }
        auth.signIn(withEmail: email.text!, password: password.text!, completion: ({result,err in
            if(err == nil){
                self.moveToMainScreen()
            }else{
                self.alertEmailValidationErrorIfPresent(err: err!)
                var message:String
                switch AuthErrorCode(rawValue: err!._code) {
                case .userNotFound,.wrongPassword:
                    message = "Wrong credendials.Please check your credentials"
                case .networkError:
                    message = "Something went wrong with connection.Try again later"
                default:
                    message = "unknown error had occured"
                }
                AlertPopup(self).infoPop(title: "Authentication failed", body:message )
            }
        }))
    }
    func isEmpty(_ fields:[UITextField]) -> Bool {
        for field in fields{
            if field.text == nil || field.text!.count == 0{
                return true
            }
        }
        return false
    }
    func registerUser(){
        if(isEmpty([email,phonenumber,password,confirmPassword])){
            return alertPop.infoPop(title: "Field error", body: "Some fields are empty")
        }
        if(password.text! != confirmPassword.text!){
            return alertPop.infoPop(title: "Field mismatch", body: "confirmation password doesn't match")
        }
        if Int(phonenumber.text!) == nil || phonenumber.text!.count != 10{
            return alertPop.infoPop(title: "Invalid contact number", body: "the contact number provided should be 10 digits long numbert")
        }
        
        auth.createUser(withEmail: email.text!, password: password.text!, completion: ({result,err in
            if(err == nil){
                //homeScreen
                let db = Firestore.firestore()
                db.document("user/\(result!.user.uid)").setData(["phoneNumber":self.phonenumber.text!])
                db.document("orders/\(result!.user.uid)").setData(["orderList":[]])
                self.moveToMainScreen()
            }else{
                self.alertEmailValidationErrorIfPresent(err: err!)
                 var message:String
                switch AuthErrorCode(rawValue: err!._code) {
                   case .networkError:
                       message = "Something went wrong with connection.Try again later"
                   case .weakPassword:
                       message = "passowrd is too weak"
                   default:
                       message = "unknown error had occured"
                   }
                AlertPopup(self).infoPop(title: "User registration failed", body:message )
            }
        }))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
