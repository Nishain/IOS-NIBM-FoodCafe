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
        
        //we need to hide the first  top navigation baer...
        navigationBar.isHidden = true
        
        //check if user has provided location permission then navigate to screen accordingly
        
        //with setViewControllers I replace the the stack screen with the screen to display
        if(canContinue){

            if(Auth.auth().currentUser == nil){
                authenticateScreen = storyboard!.instantiateViewController(identifier: "authScreen") as AuthScreen
                setViewControllers([authenticateScreen], animated: true)
               
            }else{
                homeScreen = storyboard!.instantiateViewController(identifier: "homeScreen") as UITabBarController
                setViewControllers([homeScreen], animated: true)
            }
            
        }else{
            locationRequestScreen = storyboard!.instantiateViewController(identifier: "permissionRequestScreen") as PermissionRequestScreen
            setViewControllers([locationRequestScreen], animated: true)
        }
        // Do any additional setup after loading the view.
    }
    


}
