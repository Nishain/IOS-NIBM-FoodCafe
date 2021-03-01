//
//  AuthScreen.swift
//  FoodCafe
//
//  Created by Nishain on 2/25/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit
import FirebaseAuth
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
    var currentMode = FunctionMode.register
    var alertPop:AlertPopup!
    let auth = Auth.auth()
    override func viewDidLoad() {
        alertPop = AlertPopup(self)
    
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        mainScreen.modalPresentationStyle = .overCurrentContext
        self.present(mainScreen, animated: true, completion: nil)
    }
    func loginUser(){
        if(isEmpty([email,password])){
            return alertPop.infoPop(title: "Field error", body: "Some fields are empty")
        }
        auth.signIn(withEmail: email.text!, password: password.text!, completion: ({result,err in
            if(err == nil){
                self.moveToMainScreen()
            }else{
                var message:String
                switch AuthErrorCode(rawValue: err!._code) {
                case .userNotFound,.wrongPassword:
                    message = "Wrong credendials.Please check your credentials"
                case .invalidEmail:
                    message = "Invalid email address.Please enter a valid one"
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
        if (NSPredicate(format: "SELF MATCHES %@", "^\\d{10}$").evaluate(with:phonenumber.text!)){
            return alertPop.infoPop(title: "Invalid contact number", body: "the contact number provided is wrong format")
        }
        auth.createUser(withEmail: email.text!, password: password.text!, completion: ({result,err in
            if(err == nil){
                //homeScreen
                self.moveToMainScreen()
            }else{
                 var message:String
                switch AuthErrorCode(rawValue: err!._code) {
                               case .emailAlreadyInUse:
                                   message = "email is already in use.Please use another email"
                               case .invalidEmail:
                                   message = "Invalid email address.Please enter a valid one"
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
