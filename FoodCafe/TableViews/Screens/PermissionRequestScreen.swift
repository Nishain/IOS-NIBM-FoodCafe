//
//  PermissionRequestScreen.swift
//  FoodCafe
//
//  Created by Nishain on 2/28/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit
import FirebaseAuth
class PermissionRequestScreen: UIViewController {
    let locationService = LocationService()
    let auth = Auth.auth()
    override func viewDidLoad() {
        super.viewDidLoad()
            let status = locationService.status()
        if status == .denied || status == .restricted{
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        }
        locationService.onPermissionAllowed = {
            self.navigateToMainScreen()
        }
        // Do any additional setup after loading the view.
    }
    func navigateToMainScreen(){
        navigationController?.pushViewController(storyboard!.instantiateViewController(identifier: auth.currentUser==nil ? "authScreen":"homeScreen"), animated: true)
    }

    @IBAction func allowPermssionTapped(_ sender: Any) {
        locationService.requestWhenInUseAuthorization()
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
