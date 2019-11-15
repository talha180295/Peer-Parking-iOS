//
//  SellParkingVC.swift
//  PeerParking
//
//  Created by Apple on 25/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import StepIndicator
import EzPopup
import CoreLocation



class SellParkingVC: UIViewController, CLLocationManagerDelegate {

    var counter = 0
    
    var locationManager = CLLocationManager()
    
    let story = UIStoryboard(name: "Main", bundle: nil)
    
    @IBOutlet weak var step_progress: StepIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
      
    }
   
    override func viewWillAppear(_ animated: Bool) {
        
        tab_index = 2
        print("parking_post_details=\(GLOBAL_VAR.PARKING_POST_DETAILS)")
        print("::--=viewWillAppear|SellParking")
        self.tabBarController!.navigationItem.title = "Sell Parking"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        print("::--=viewWillDisappear|SellParking")
    }
    
    @IBAction func pre_btn(_ sender: UIButton) {
        
        if(counter != 0){
            counter-=1
            step_progress.currentStep = counter
            let data = ["counter":counter]
            NotificationCenter.default.post(name: Notification.Name("btn_tap"), object: nil,userInfo: data)
        }
        
       
    }
    
    @IBAction func for_btn(_ sender: UIButton) {
        if(counter != 5){
            counter+=1
            step_progress.currentStep = counter
            let data = ["counter":counter]
            NotificationCenter.default.post(name: Notification.Name("btn_tap"), object: nil,userInfo: data)
        }
        if(counter == 5){
            
            
            print("parking_post_details=\(GLOBAL_VAR.PARKING_POST_DETAILS)")
            if Helper().IsUserLogin(){
                
               
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FinishPopup")
    
    
                let popupVC = PopupViewController(contentController: vc, popupWidth: 320, popupHeight: 365)
                popupVC.canTapOutsideToDismiss = true
    
                //properties
                //            popupVC.backgroundAlpha = 1
                //            popupVC.backgroundColor = .black
                //            popupVC.canTapOutsideToDismiss = true
                //            popupVC.cornerRadius = 10
                //            popupVC.shadowEnabled = true
    
                // show it by call present(_ , animated:) method from a current UIViewController
                present(popupVC, animated: true)
                
            }
            else{
                
                let vc = self.story.instantiateViewController(withIdentifier: "FBPopup")
                
                
                let popupVC = PopupViewController(contentController: vc, popupWidth: 320, popupHeight: 365)
                popupVC.canTapOutsideToDismiss = true
                
                //properties
                //            popupVC.backgroundAlpha = 1
                //            popupVC.backgroundColor = .black
                //            popupVC.canTapOutsideToDismiss = true
                //            popupVC.cornerRadius = 10
                //            popupVC.shadowEnabled = true
                
                // show it by call present(_ , animated:) method from a current UIViewController
                present(popupVC, animated: true)
                
            }
            
            
            
            
        }
        
    }
    
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        print(":=:lat==::\(location?.coordinate.latitude)")
        print(":=:long==::\(location?.coordinate.longitude)")
        
       
        GLOBAL_VAR.PARKING_POST_DETAILS.updateValue((location?.coordinate.latitude.description)!, forKey: "latitude")
        GLOBAL_VAR.PARKING_POST_DETAILS.updateValue((location?.coordinate.longitude.description)!, forKey: "longitude")
        //location.
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location!, completionHandler:
            {
                placemarks, error in
                
                guard let placemark = placemarks?.first else {
                    let errorString = error?.localizedDescription ?? "Unexpected Error"
                    print("Unable to reverse geocode the given location. Error: \(errorString)")
                    return
                }
                
                let reversedGeoLocation = ReversedGeoLocation(with: placemark)
                print("LOC=:\(reversedGeoLocation.formattedAddressName)")
                
                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(reversedGeoLocation.formattedAddressName, forKey: "address")
                //self.address = reversedGeoLocation.formattedAddress
                // Apple Inc.,
                // 1 Infinite Loop,
                // Cupertino, CA 95014
                // United States
        })
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
}
