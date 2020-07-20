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


class PublicParkingVC: UIViewController  {

    var counter = 0
    
//    var locationManager = CLLocationManager()
    
    let story = UIStoryboard(name: "Main", bundle: nil)
    
    @IBOutlet weak var step_progress: StepIndicatorView!
    @IBOutlet var containerView: UIView!
    
    var vc:ParkingNavVC!
    var vc1:ParkedViewController!
    
    
    var detailStepVC:UIViewController!
    var priceStepVC:PriceStepVC!
    var whenStepVC:UIViewController!
    var limitationStepVC:UIViewController!
    var locationStepVC:UIViewController!
    var imageStepVC:UIViewController!
    
    
//    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingNavVC") as! ParkingNavVC
//    let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "parkedVC") as! ParkedViewController
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        init_controllers()
        //Location Manager code to fetch current location
//        self.locationManager.delegate = self
//        self.locationManager.startUpdatingLocation()
        step_progress.step_text = APP_CONSTANT.public_step_text
        step_progress.numberOfSteps = 6
    }
   
    
    func init_controllers(){
        
        // Do any additional setup after loading the view.
        detailStepVC = storyboard!.instantiateViewController(withIdentifier: "DetailStepVC") as? DetailStepVC
        priceStepVC = PriceStepVC.instantiate(fromPeerParkingStoryboard: .SellParking)
        whenStepVC = storyboard!.instantiateViewController(withIdentifier: "WhenStepVC") as? WhenStepVC
        limitationStepVC = storyboard!.instantiateViewController(withIdentifier: "LimitationStepVC") as? LimitationStepVC
        locationStepVC = storyboard!.instantiateViewController(withIdentifier: "LocationStepVC") as? LocationStepVC
        imageStepVC = storyboard!.instantiateViewController(withIdentifier: "ImageStepVC")
        
        addChild(detailStepVC)
        detailStepVC.view.frame = containerView.bounds  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
        containerView.addSubview(detailStepVC.view)
        detailStepVC.didMove(toParent: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        tab_index = 2
        self.tabBarController!.navigationItem.title = "Sell Public Parking"
        //show right button
        let rightButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_close"), style: .plain, target: self, action: #selector(menu))

        

        //show the Menu button item
        self.tabBarController!.navigationItem.rightBarButtonItem = rightButton
        //right Bar Button Item tint color
        self.tabBarController!.navigationItem.rightBarButtonItem?.tintColor = .black
        
        self.setUPViews()
        
        
       
    }

    @objc func menu(){
        print("showSlideOutMane fire ")
        self.tabBarController!.navigationItem.rightBarButtonItem = nil
        self.tabBarController!.navigationItem.title = "Sell Parking" 
        self.view.removeFromSuperview()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        vc1.remove()
    }
    
    func setUPViews(){

        vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingNavVC") as? ParkingNavVC
        vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "parkedVC") as? ParkedViewController
        
        
        if(Helper().IsUserLogin()){
            
//            self.checkStatus()
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
        
        if let latitude = Double(dict.latitude ?? ""){
            
            vc.p_lat = latitude
            
        }
        
        if let longitude = Double(dict.longitude ?? ""){
            
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
        APIClient.serverRequest(url: url_r, path: url_r.getPath(), dec: decoder) { (response, error) in
                        
            if(response != nil){
                if let _ = response?.success {
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
            
            self.addChild(self.detailStepVC)
            self.detailStepVC.view.frame = self.containerView.bounds  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            self.containerView.addSubview(self.detailStepVC.view)
            self.detailStepVC.didMove(toParent: self)
            
            
        }
        else if(counter == 1){
            
          
            self.addChild(self.priceStepVC)
            self.priceStepVC.view.frame = self.containerView.bounds  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            self.containerView.addSubview(self.priceStepVC.view)
            self.priceStepVC.didMove(toParent: self)
            
            
        }
            
        else if(counter == 2){
            
            if(self.priceStepVC.amount_tf.hasText){
                self.priceStepVC.imgInfo.isHidden = true
                self.addChild(self.whenStepVC)
                self.whenStepVC.view.frame = self.containerView.bounds  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
                self.containerView.addSubview(self.whenStepVC.view)
                self.whenStepVC.didMove(toParent: self)
            }
            else{
                self.priceStepVC.imgInfo.isHidden = false
                counter -= 1
                step_progress.currentStep = counter
//                change_page()
            }
           
           
           
            
        }
        else if(counter == 3){
            
            
            //let controller = storyboard!.instantiateViewController(withIdentifier: "four")
            self.addChild(self.limitationStepVC)
            self.limitationStepVC.view.frame = self.containerView.bounds  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            self.containerView.addSubview(self.limitationStepVC.view)
            self.limitationStepVC.didMove(toParent: self)
            
            
        }
        else if(counter == 4){
            
            
            //let controller = storyboard!.instantiateViewController(withIdentifier: "four")
            self.addChild(self.locationStepVC)
            self.locationStepVC.view.frame = self.containerView.bounds  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            self.containerView.addSubview(self.locationStepVC.view)
            self.locationStepVC.didMove(toParent: self)
            
            
        }
        else if(counter == 5){
            
            //let controller = storyboard!.instantiateViewController(withIdentifier: "five")
            self.addChild(self.imageStepVC)
            self.imageStepVC.view.frame = self.containerView.bounds  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            self.containerView.addSubview(self.imageStepVC.view)
            self.imageStepVC.didMove(toParent: self)
            
           
            
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
