//
//  LocationService.swift
//  FoodCafe
//
//  Created by Nishain on 2/28/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LocationService: CLLocationManager {
    override init() {
        super.init()
        delegate = self
    }
    func status()->CLAuthorizationStatus{
        return CLLocationManager.authorizationStatus()
    }
    
    func canConinue()->Bool{
        let state = status()
        if(state == .authorizedWhenInUse){
            return true
        }
        return false
    }
    var onLocationRecived : ((CLLocation?) -> Void)?
    var onPermissionAllowed : ((Bool) -> Void)?
    var onPermissionUndetermined: (() -> Void)?
    
}
extension LocationService:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedWhenInUse){
            onPermissionAllowed?(true)
        }else if status == .notDetermined{
            onPermissionUndetermined?()
        }else{
            onPermissionAllowed?(false)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        onLocationRecived?(locations.first)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
