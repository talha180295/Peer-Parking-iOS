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


class SellParkingVC: UIViewController, CLLocationManagerDelegate {

    var counter = 0
    
    var locationManager = CLLocationManager()
    
    let story = UIStoryboard(name: "Main", bundle: nil)
    
    @IBOutlet weak var step_progress: StepIndicatorView!
    @IBOutlet var mainView: UIView!
    
    var vc:ParkingNavVC!
    var vc1:ParkedViewController!
//    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingNavVC") as! ParkingNavVC
//    let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "parkedVC") as! ParkedViewController
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        self.mainView.isHidden = true
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
      
    }
   
    override func viewWillAppear(_ animated: Bool) {
        
        tab_index = 2
        self.tabBarController!.navigationItem.title = "Sell Parking"
        
        self.setUPViews()
       
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

    
    
    func openTimerScreen(vc:ParkedViewController){
        
        
        //        configureChildViewController(childController: vc, onView: self.mainView)
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
//        configureChildViewController(childController: vc, onView: self.mainView)
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
        
        var auth_value = ""
        
        if let value : String = UserDefaults.standard.string(forKey: "auth_token"){
            
            auth_value = "bearer " + value
        }
        
        
        print("auth_value==\(auth_value)")
        
        
        
        let headers: HTTPHeaders = [
            "Authorization" : auth_value
        ]
        
        
        var url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.GET_PARKING_WITH_TOKEN
        
        print("checkStatusurl=\(url)")
        
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
                                  self.openTimerScreen(vc: self.vc1)
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
//        Helper().Request_Api(url: url, methodType: .get, parameters: params, isHeaderIncluded: true, headers: headers){
//            response in
//            print(response.response?.statusCode)
//            //print("response=\(response)")
//            if response.result.value == nil {
////                print("No response status")
//                
//                let responseData = response.result.value as! NSDictionary
//                let uData = responseData["data"] as! [Any]
//                
//                SharedHelper().showToast(message: "Internal Server Error", controller: self)
//                completion([:])
//                return
//            }
//            else {
//                let responseData = response.result.value as! NSDictionary
//                let status = responseData["success"] as! Bool
//                if(status)
//                {
//                    
//                    let message = responseData["message"] as! String
//                    let uData = responseData["data"] as! [Any]
//                    
//                    if(uData.count>0){
//                        
//                    
//                    let dict = uData[0] as! NSDictionary
//                    let p_status = dict["status"] as! Int
//                    
//                    completion(dict)
//                    }
//                    
//                    
//                    
//                }
//                else
//                {
//                    let message = responseData["message"] as! String
//                    SharedHelper().showToast(message: message, controller: self)
//                    //   SharedHelper().hideSpinner(view: self.view)
//                }
//            }
//        }
        
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
//        print(":=:lat==::\(location?.coordinate.latitude)")
//        print(":=:long==::\(location?.coordinate.longitude)")
        
       
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
//                print("LOC=:\(reversedGeoLocation.formattedAddressName)")
                
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

extension UIViewController {
//    func configureChildViewController(childController: UIViewController, onView: UIView?) {
//        var holderView = self.view
//        if let onView = onView {
//            holderView = onView
//        }
//        addChild(childController)
//        holderView?.addSubview(childController.view)
//        constrainViewEqual(holderView: holderView!, view: childController.view)
//        childController.didMove(toParent: self)
//    }
//
//
//    func constrainViewEqual(holderView: UIView, view: UIView) {
//        view.translatesAutoresizingMaskIntoConstraints = false
//        //pin 100 points from the top of the super
//        let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
//                                        toItem: holderView, attribute: .top, multiplier: 1.0, constant: 0)
//        let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
//                                           toItem: holderView, attribute: .bottom, multiplier: 1.0, constant: 0)
//        let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
//                                         toItem: holderView, attribute: .left, multiplier: 1.0, constant: 0)
//        let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
//                                          toItem: holderView, attribute: .right, multiplier: 1.0, constant: 0)
//
//        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
//    }
    
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
