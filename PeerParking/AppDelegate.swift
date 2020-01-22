//
//  AppDelegate.swift
//  PeerParking
//
//  Created by Munzareen Atique on 28/08/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import SideMenuController
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import CoreLocation
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager:CLLocationManager!
    var currentLocation:CLLocation?
    var currentLocationAddress:String?
    var camera:GMSCameraPosition!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupLocationManager()
        
        IQKeyboardManager.shared.enable = true
        setSideMenu()
  
        GMSServices.provideAPIKey(Key.Google.placesKey)
        
        GMSPlacesClient.provideAPIKey(Key.Google.placesKey)
        
        Fabric.with([Crashlytics.self])
        
        //Just add this line to get it done.
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)], for: UIControl.State.normal)

        
        //Stripe
//         Stripe.setDefaultPublishableKey("pk_test_RXoa7kPDBX5WbbFUwobIagRn00bNqh0qyQ")
        STPPaymentConfiguration.shared().publishableKey = "pk_test_RXoa7kPDBX5WbbFUwobIagRn00bNqh0qyQ"

        // Override point for customization after application launch.
        return true
    }

    func setSideMenu()
    {
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "icon_menu")
        SideMenuController.preferences.drawing.sidePanelPosition = .underCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = 300
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .horizontalPan
        SideMenuController.preferences.animating.transitionAnimator = FadeAnimator.self
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    

}

extension AppDelegate:CLLocationManagerDelegate{
    
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        self.locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.startUpdatingLocation()
        
    }
    
    // Below method will provide you current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentLocation == nil {
            currentLocation = locations.last
            locationManager?.stopMonitoringSignificantLocationChanges()
            let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
            
            print("locations = \(locationValue)")
            
            //location.
            
            self.camera = GMSCameraPosition.camera(withLatitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!, zoom: 14.0)
            
            let geoCoder = CLGeocoder()
            
            geoCoder.reverseGeocodeLocation(currentLocation!, completionHandler:
                {
                    placemarks, error in
                    
                    guard let placemark = placemarks?.first else {
                        let errorString = error?.localizedDescription ?? "Unexpected Error"
                        print("Unable to reverse geocode the given location. Error: \(errorString)")
                        return
                    }
                    
                    let reversedGeoLocation = ReversedGeoLocation(with: placemark)
                    print("LOC=:\(reversedGeoLocation.formattedAddress)")
                    self.currentLocationAddress = reversedGeoLocation.formattedAddressName
                    // Apple Inc.,
                    // 1 Infinite Loop,
                    // Cupertino, CA 95014
                    // United States
            })
            locationManager?.stopUpdatingLocation()
        }
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
}
