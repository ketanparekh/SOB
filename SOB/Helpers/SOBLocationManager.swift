//
//  SOBLocationManager.swift
//  SOB
//
//  Created by Ketan Parekh on 18/11/20.
//

import Foundation
import CoreLocation
import UIKit
class SOBLocationManager:
    NSObject,CLLocationManagerDelegate {
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var locationManager: CLLocationManager?
    private static var privateShared :
        SOBLocationManager?
    var traveledDistance: Double = 0
    class func shared() -> SOBLocationManager {
        guard let uwShared = privateShared else {
            privateShared = SOBLocationManager()
            return privateShared!
        }
        return uwShared
    }
    class func destroy() {
        privateShared = nil
    }
    
    func startMonitoringLocation(){
        if locationManager != nil{
            locationManager?.stopMonitoringSignificantLocationChanges()
        }
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager?.activityType = CLActivityType.otherNavigation
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startMonitoringSignificantLocationChanges()
    }
    func restartMonitoringLocation(){
        locationManager?.stopMonitoringSignificantLocationChanges()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations.last
        let defaults = UserDefaults.standard
        defaults.set(location?.coordinate.latitude, forKey: Constants.Common.lastLocationLatitude)
        defaults.set(location?.coordinate.longitude, forKey: Constants.Common.lastLocationLongitude)
    }
}
