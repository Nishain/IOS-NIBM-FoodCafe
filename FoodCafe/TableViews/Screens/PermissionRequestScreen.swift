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
            openSettings()
        }
        locationService.onPermissionAllowed = { didAllowed in
            if didAllowed{
                self.navigateToMainScreen()
            }else{
                self.openSettings()
            }
        }
        locationService.onPermissionUndetermined = {
            self.locationService.requestWhenInUseAuthorization()
        }
        // Do any additional setup after loading the view.
    }
    func openSettings(){
        let alertController = UIAlertController(title: "Missing Permissions", message: "It seems you have not provided the location permission you have to open settings manually and provide us the location permission", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { action in
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        }))
        alertController.addAction(UIAlertAction(title: "No need", style: .cancel, handler: { action in
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController,animated: true)
    }
    func navigateToMainScreen(){
        let nextScreen = storyboard!.instantiateViewController(identifier: auth.currentUser==nil ? "authScreen":"homeScreen")
        navigationController?.setViewControllers([nextScreen], animated: true)
    }

    @IBAction func requestPermissionBtnTapped(_ sender: Any) {
        let status = locationService.status()
        if status == .denied || status == .restricted{
            openSettings()
        }else{
            locationService.requestWhenInUseAuthorization()
        }
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
