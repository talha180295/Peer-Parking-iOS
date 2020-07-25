//
//  SellParkingInitaialVC.swift
//  PeerParking
//
//  Created by Apple on 16/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import EzPopup

//protocol SellParkingProtocol{
//
//    func navigate(withIdentifier:String)
//
//}
class SellParkingInitaialVC: UIViewController {
    
    //    var delegate:SellParkingProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        tab_index = 2
    }
    override func viewWillDisappear(_ animated: Bool) {
        Helper().hideSpinner(view: self.view)
    }
    
    @IBAction func publicParkingBtn(_ sender:UIButton){
        
        if Helper().IsUserLogin(){
            self.parkingExist { (pakingAvailable) in
                switch pakingAvailable {
                case true:
                    Helper().showToast(message: "Parking Already Exist!", controller: self)
                case false:
                    
                    let date = Date()
                           let formatter = DateFormatter()
                           formatter.dateFormat = APP_CONSTANT.DATE_TIME_FORMAT
                           let result = formatter.string(from: date)
//                           self.time_field.text = result
                           
                           GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(result, forKey: "start_at")
                    self.setUpView(withIdentifier: "PublicParkingVC")
                }
            }
        }
        else{
            
            let vc = FBPopup.instantiate(fromPeerParkingStoryboard: .Main)
            vc.source = Source.SELL_PARKING.rawValue
            
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
    @IBAction func privateParkingBtn(_ sender:UIButton){
        
        
        if Helper().IsUserLogin(){
            setUpView(withIdentifier: "PrivateParkingVC")
        }
        else{
            
            let vc = FBPopup.instantiate(fromPeerParkingStoryboard: .Main)
            vc.source = Source.SELL_PARKING.rawValue
            
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
    
    func setUpView(withIdentifier:String){
        
        var vc:UIViewController!
        vc = storyboard!.instantiateViewController(withIdentifier: withIdentifier)
        
        addChild(vc)
        vc.view.frame = view.frame  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }
    

    func parkingExist(completion:@escaping (Bool)->Void){
        
//        let params = [
//            "is_schedule" : 1,
//            "mood" : 10
//        ]
//        
        let params =  ["my_public_spots":1]
        
        print("param123=\(params)")
        
        
        let url_r = APIRouter.getParkings(params)
        let decoder = ResponseData<[Parking]>.self
        Helper().showSpinner(view: self.view)
        APIClient.serverRequest(url: url_r, path: url_r.getPath(), dec: decoder) { (response, error) in
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if let _ = response?.success {
                    if let val = response?.data {
                        
                        if(val.count>0){
                            completion(true)
                        }
                        else{
                            completion(false)
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


    
}
