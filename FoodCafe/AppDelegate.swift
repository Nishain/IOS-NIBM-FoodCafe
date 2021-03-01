//
//  AppDelegate.swift
//  FoodCafe
//
//  Created by Nishain on 2/21/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        var authenticateScreen:AuthScreen?
        var locationRequestScreen:PermissionRequestScreen?
        let locationManager = LocationService()
        
        let canContinue = locationManager.canConinue()
        print("canContinue? \(canContinue)")
        
        let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if(canContinue){
            print("here we go")
            if(Auth.auth().currentUser == nil){
                authenticateScreen = storyboard.instantiateViewController(identifier: "authScreen") as AuthScreen
                keyWindow?.rootViewController = authenticateScreen
            }else{
                //homeScreen
                let homeScreen = storyboard.instantiateViewController(identifier:"homeScreen")
                keyWindow?.rootViewController = homeScreen
            }
            
        }else{
            print("but went this way")
            locationRequestScreen = storyboard.instantiateViewController(identifier: "permissionRequestScreen") as PermissionRequestScreen
            keyWindow?.rootViewController = locationRequestScreen
        }
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

