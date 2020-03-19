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
import Alamofire
import HelperClassPod


class PublicParkingVC: UIViewController, CLLocationManagerDelegate {

    var counter = 0
    
    var locationManager = CLLocationManager()
    
    let story = UIStoryboard(name: "Main", bundle: nil)
    
    @IBOutlet weak var step_progress: StepIndicatorView!
    @IBOutlet var containerView: UIView!
    
    var vc:ParkingNavVC!
    var vc1:ParkedViewController!
    
    
    var controller1:UIViewController!
    var controller2:UIViewController!
    var controller3:UIViewController!
    var controller4:StepFourVC!
    var controller5:UIViewController!
    var controllerLoc:UIViewController!
    
    
//    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingNavVC") as! ParkingNavVC
//    let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "parkedVC") as! ParkedViewController
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        init_controllers()
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
      
    }
   
    
    func init_controllers(){
        
        // Do any additional setup after loading the view.
        controller1 = storyboard!.instantiateViewController(withIdentifier: "one")
        controller2 = storyboard!.instantiateViewController(withIdentifier: "two")
        controller3 = storyboard!.instantiateViewController(withIdentifier: "three")
        controller4 = storyboard!.instantiateViewController(withIdentifier: "four") as! StepFourVC
        controller5 = storyboard!.instantiateViewController(withIdentifier: "five")
        controllerLoc = storyboard!.instantiateViewController(withIdentifier: "LocationStepVC")
        addChild(controller2)
        controller2.view.frame = containerView.bounds  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
        containerView.addSubview(controller2.view)
        controller2.didMove(toParent: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        tab_index = 2
        self.tabBarController!.navigationItem.title = "Sell Parking"
        //show right button
        let rightButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_close"), style: .plain, target: self, action: #selector(menu))

        

        //show the Menu button item
        self.tabBarController!.navigationItem.rightBarButtonItem = rightButton
        //right Bar Button Item tint color
        self.tabBarController!.navigationItem.rightBarButtonItem?.tintColor = .black
        
        self.setUPViews()
        
        
       
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        init_controllers()
//    }
    
    @objc func menu(){
        print("showSlideOutMane fire ")
        self.tabBarController!.navigationItem.rightBarButtonItem = nil
        self.view.removeFromSuperview()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        vc1.remove()
    }
    
    func setUPViews(){

        vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingNavVC") as? ParkingNavVC
        vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "parkedVC") as? ParkedViewController
        
        
        if(Helper().IsUserLogin()){
            
            self.checkStatus()
        }

                
    }
    func setTimer(val:String){
        

        let dateFormatterNow = DateFormatter()
        dateFormatterNow.dateFormat = APP_CONSTANT.DATE_TIME_FORMAT
        //                dateFormatterNow.timeZone = TimeZone(abbreviation: "EST")
        
        let currentDate = Date()
        let currentDateStr = dateFormatterNow.string(from: currentDate)
        let oldDate = dateFormatterNow.date(from: currentDateStr)
        
        let newDateString = val
        let newDate = dateFormatterNow.date(from: newDateString)
        
        if let oldDate = oldDate, let newDate = newDate {
            let diffInMins = Calendar.current.dateComponents([.second], from: oldDate, to: newDate).second
            print("diffInMins=\(diffInMins ?? 0)")
            self.vc1.seconds = diffInMins ?? 0
            self.vc1.MainSeconds = diffInMins ?? 0
        }
        
    }

    
    
    func openTimerScreen(vc:ParkedViewController, dict:Parking){
        
        vc.parking_details = dict
     
        add(vc)
        
    }
    func openNavigationScreen(vc:ParkingNavVC, dict:Parking){
        
        vc.parking_details = nil
        

        
        if let id = dict.id{
            
            vc.p_id = id
            
        }
        
        if let address = dict.address{
            
            vc.p_title = address
            
        }
        
        if let latitude = dict.latitude as? Double{
            
            vc.p_lat = latitude
            
        }
        
        if let longitude = dict.longitude as? Double{
            
            vc.p_longg = longitude
            
        }
        
        vc.vcName = "nav"
        add(vc)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
//        print("::--=viewWillDisappear|SellParking")
    }
    
    
    func checkStatus(){//(withToken:Bool,completion: @escaping (JSON) -> Void){
        
        let params = [
            "is_schedule" : 1,
            "mood" : 10
        ]

        print("param123=\(params)")
        

        let url_r = APIRouter.getParkings(params)
        let decoder = ResponseData<[Parking]>.self
        APIClient.serverRequest(url: url_r, dec: decoder) { (response, error) in
                        
            if(response != nil){
                if let success = response?.success {
                    if let val = response?.data {
                        
                        if(val.count>0){
                            self.setTimer(val: val[0].startAt ?? "")
                            
                            let p_status = val[0].status
                            switch p_status {
                                
                              case 10:
                                  self.openTimerScreen(vc: self.vc1, dict: val[0])
                              case 20:
                                  self.openNavigationScreen(vc: self.vc, dict: val[0])
                              default:
                                  self.vc.remove()
                                  self.vc1.remove()
                            }
                        }
                    }
                }
                else{
                  
                }
            }
            else if(error != nil){
            }
            else{
                
            }
        }
    }
    
    func change_page(){
        
        if(counter == 0){
            
            self.addChild(self.controller2)
            self.controller2.view.frame = self.containerView.bounds  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            self.containerView.addSubview(self.controller2.view)
            self.controller2.didMove(toParent: self)
            
            
        }
        else if(counter == 1){
            
          
            self.addChild(self.controller4)
            self.controller4.view.frame = self.containerView.bounds  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            self.containerView.addSubview(self.controller4.view)
            self.controller4.didMove(toParent: self)
            
            
        }
            
        else if(counter == 2){
            
            if(self.controller4.amount_tf.hasText){
                self.controller4.imgInfo.isHidden = true
                self.addChild(self.controller1)
                self.controller1.view.frame = self.containerView.bounds  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
                self.containerView.addSubview(self.controller1.view)
                self.controller1.didMove(toParent: self)
            }
            else{
                self.controller4.imgInfo.isHidden = false
                counter -= 1
                step_progress.currentStep = counter
//                change_page()
            }
           
           
           
            
        }
        else if(counter == 3){
            
            
            //let controller = storyboard!.instantiateViewController(withIdentifier: "four")
            self.addChild(self.controller3)
            self.controller3.view.frame = self.containerView.bounds  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            self.containerView.addSubview(self.controller3.view)
            self.controller3.didMove(toParent: self)
            
            
        }
        else if(counter == 4){
            
            
            //let controller = storyboard!.instantiateViewController(withIdentifier: "four")
            self.addChild(self.controllerLoc)
            self.controllerLoc.view.frame = self.containerView.bounds  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            self.containerView.addSubview(self.controllerLoc.view)
            self.controllerLoc.didMove(toParent: self)
            
            
        }
        else if(counter == 5){
            
            //let controller = storyboard!.instantiateViewController(withIdentifier: "five")
            self.addChild(self.controller5)
            self.controller5.view.frame = self.containerView.bounds  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            self.containerView.addSubview(self.controller5.view)
            self.controller5.didMove(toParent: self)
            
           
            
        }
    }
    
    @IBAction func pre_btn(_ sender: UIButton) {
        
        if(counter != 0){
            counter-=1
            step_progress.currentStep = counter
            change_page()
//            let data = ["counter":counter]
//            NotificationCenter.default.post(name: Notification.Name("btn_tap"), object: nil,userInfo: data)
        }
       
    }
    
    @IBAction func for_btn(_ sender: UIButton) {
        if(counter != 6){
            counter+=1
            step_progress.currentStep = counter
            change_page()
//            let data = ["counter":counter]
//            NotificationCenter.default.post(name: Notification.Name("btn_tap"), object: nil,userInfo: data)
        }
        if(counter == 6){
            
            counter-=1
            step_progress.currentStep = counter
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
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        let location = locations.last
//
////        print(":=:lat==::\(location?.coordinate.latitude)")
////        print(":=:long==::\(location?.coordinate.longitude)")
//
//
//        GLOBAL_VAR.PARKING_POST_DETAILS.updateValue((location?.coordinate.latitude.description)!, forKey: "latitude")
//        GLOBAL_VAR.PARKING_POST_DETAILS.updateValue((location?.coordinate.longitude.description)!, forKey: "longitude")
//        //location.
//
//        let geoCoder = CLGeocoder()
//
//        geoCoder.reverseGeocodeLocation(location!, completionHandler:
//            {
//                placemarks, error in
//
//                guard let placemark = placemarks?.first else {
//                    let errorString = error?.localizedDescription ?? "Unexpected Error"
//                    print("Unable to reverse geocode the given location. Error: \(errorString)")
//                    return
//                }
//
//                let reversedGeoLocation = ReversedGeoLocation(with: placemark)
////                print("LOC=:\(reversedGeoLocation.formattedAddressName)")
//
//                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(reversedGeoLocation.formattedAddressName, forKey: "address")
//                //self.address = reversedGeoLocation.formattedAddress
//                // Apple Inc.,
//                // 1 Infinite Loop,
//                // Cupertino, CA 95014
//                // United States
//        })
//
//        //Finally stop updating location otherwise it will come again and again in this delegate
//        self.locationManager.stopUpdatingLocation()
//
//    }
}

extension UIViewController {

    /// Adds child view controller to the parent.
    ///
    /// - Parameter child: Child view controller.
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    /// It removes the child view controller from the parent.
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
