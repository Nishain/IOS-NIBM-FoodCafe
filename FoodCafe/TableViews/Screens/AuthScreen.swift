//
//  AuthScreen.swift
//  FoodCafe
//
//  Created by Nishain on 2/25/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func primaryBtnTaped(_ sender: UIButton) {
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
