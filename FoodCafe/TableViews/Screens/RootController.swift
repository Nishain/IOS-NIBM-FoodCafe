//
//  RootController.swift
//  FoodCafe
//
//  Created by Nishain on 3/3/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit
import FirebaseAuth
class RootController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var authenticateScreen:AuthScreen!
        var locationRequestScreen:PermissionRequestScreen!
        let locationManager = LocationService()
        let homeScreen:UITabBarController!
        let canContinue = locationManager.canConinue()
        
        navigationBar.isHidden = true
        if(canContinue){

            if(Auth.auth().currentUser == nil){
                authenticateScreen = storyboard!.instantiateViewController(identifier: "authScreen") as AuthScreen
                setViewControllers([authenticateScreen], animated: true)
                //pushViewController(authenticateScreen!,animated: false)
            }else{
                homeScreen = storyboard!.instantiateViewController(identifier: "homeScreen") as UITabBarController
                setViewControllers([homeScreen], animated: true)
            }
            
        }else{
            locationRequestScreen = storyboard!.instantiateViewController(identifier: "permissionRequestScreen") as PermissionRequestScreen
            setViewControllers([locationRequestScreen], animated: true)
            //pushViewController(locationRequestScreen!,animated: false)
        }
        // Do any additional setup after loading the view.
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
