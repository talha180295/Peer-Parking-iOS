//
//  Sell_parking_popup.swift
//  PeerParking
//
//  Created by Apple on 12/11/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import EzPopup
import DatePickerDialog
import Alamofire
import HelperClassPod

class Sell_parking_popup: UIViewController {

    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var price_tf: UITextField!
    @IBOutlet weak var time_tf: UITextField!
    
    @IBOutlet weak var submit_btn: UIButton!
    var parking_details:Parking!
    
    var params:[String:Any] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submit_btn.isHidden = true
        
        priceView.isHidden = true
        
        print("abcdparkings=\(self.parking_details)")
        // Do any additional setup after loading the view.
    }
    

    @IBAction func want_to_sell(_ sender: UIButton) {
       
        if(sender.tag == 1){
            
            self.priceView.isHidden = false
            
            
        }
        else if (sender.tag == 2){
            
            //index 1 for Navigate Screen
            Helper().presentOnMainScreens(controller: self, index: 1)
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FindParkingVC")
//            self.navigationController?.pushViewController(vc, animated: true)
//            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func price_change(_ sender: UITextField) {
        sender.resignFirstResponder()
        
        
        
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PricePicker") as! PricePicker
        
        vc.completionBlock = {(dataReturned) -> ()in
            //Data is returned **Do anything with it **
            print(dataReturned)
            sender.text = "$\(dataReturned)"
            
            
            if(self.price_tf.hasText)&&(self.time_tf.hasText){
                
                self.submit_btn.isHidden = false
            }
            else{
                
                self.submit_btn.isHidden = true
            }
            //GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(Double(dataReturned)!, forKey: "parking_extra_fee")
            self.params.updateValue(Double(dataReturned)!, forKey: "initial_price")
        }
        let popupVC = PopupViewController(contentController: vc, popupWidth: 300, popupHeight: 300)
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
    @IBAction func time_change(_ sender: UITextField) {
        
        sender.resignFirstResponder()
        datePickerTapped(sender:sender)
    }
    
    @IBAction func submit_btn(_ sender: UIButton) {
        
        
        
        //        var params:[String:Any] = [
        //            "vehicle_type": vehicle_type,     C
        //            "parking_type": parking_type,     C
        //            "status": status,                 N
        //            "initial_price": initial_price,   C
        //            "final_price": final_price,       N
        //            "start_at": start_at,             C
        //            "end_at": end_at,                 N
        //            "address": address,               C
        //            "longitude": longitude,           C
        //            "latitude": latitude,             C
        //            "is_negotiable": is_negotiable,   OP
        //            "note": note,                     OP
        //            "parking_hours_limit": parking_hours_limit,   OP
        //            "parking_extra_fee": parking_extra_fee,       OP
        //            "parking_allowed_until": parking_allowed_until,   OP
        //            "parking_extra_fee_unit": parking_extra_fee_unit,   OP
        //            "is_resident_free": is_resident_free                  OP
        //        ]
        
        if let vehicle_type = self.parking_details.vehicleType{
            params.updateValue(vehicle_type, forKey: "vehicle_type")
        }
        
        if let parking_type = self.parking_details.parkingType{
            params.updateValue(parking_type, forKey: "parking_type")
        }
        
//        if let initial_price = self.parking_details["initial_price"] as? String{
//            params.updateValue(initial_price, forKey: "initial_price")
//        }
        
//        if let start_at = self.parking_details["start_at"] as? String{
//            params.updateValue(start_at, forKey: "start_at")
//        }
        
        if let longitude = self.parking_details.longitude{
            params.updateValue(longitude, forKey: "longitude")
        }
        
        if let latitude = self.parking_details.latitude{
            params.updateValue(latitude, forKey: "latitude")
        }
        
        if let is_negotiable = self.parking_details.isNegotiable{
            params.updateValue(is_negotiable, forKey: "is_negotiable")
        }
        
        if let note = self.parking_details.note{
            params.updateValue(note, forKey: "note")
        }
        
        if let parking_hours_limit = self.parking_details.parkingHoursLimit{
            params.updateValue(parking_hours_limit, forKey: "parking_hours_limit")
        }
        
        if let parking_extra_fee = self.parking_details.parkingExtraFee{
            params.updateValue(parking_extra_fee, forKey: "parking_extra_fee")
        }
        
        if let parking_allowed_until = self.parking_details.parkingAllowedUntil{
            params.updateValue(parking_allowed_until, forKey: "parking_allowed_until")
        }
        
        if let parking_extra_fee_unit = self.parking_details.parkingExtraFeeUnit{
            params.updateValue(parking_extra_fee_unit, forKey: "parking_extra_fee_unit")
        }
        
        if let is_resident_free = self.parking_details.isResidentFree{
            params.updateValue(is_resident_free, forKey: "is_resident_free")
        }
        
        
        print("params---=\(params)")
        
        resell_parking(){
            //tab_index = 0
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "parkedVC")
            //
            //        self.present(vc, animated: true, completion: nil)
        }
        
        
        
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "parkedVC")
//
//        self.present(vc, animated: true, completion: nil)
    }
    
    func datePickerTapped(sender:UITextField) {
        DatePickerDialog(buttonColor:#colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)).show("Select Time", doneButtonTitle: "DONE", cancelButtonTitle: "CANCEL", datePickerMode: .dateAndTime) {
            (date) -> Void in
            if let time = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                //self.datePickerTapped2(sender: sender,from: formatter.string(from: time))
                sender.text = formatter.string(from: time)
                
                if(self.price_tf.hasText)&&(self.time_tf.hasText){
                    
                    self.submit_btn.isHidden = false
                }
                else{
                    
                    self.submit_btn.isHidden = true
                }
                self.params.updateValue(sender.text!, forKey: "start_at")
                //GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(sender.text!, forKey: "parking_allowed_until")
            }
        }
    }
    
    
    
    func resell_parking(completion: @escaping () -> Void){
        
        //modelParam
        self.params = self.parking_details.dictionary ?? [:]
        
        
        //params.updateValue("hello", forKey: "new_val")
        let auth_value =  "Bearer \(UserDefaults.standard.string(forKey: APP_CONSTANT.ACCESSTOKEN)!)"
        let headers: HTTPHeaders = [
            "Authorization" : auth_value
        ]
        print("==0params=\(params)")
        print("==0headers=\(headers)")
        
        //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customVC")
        //        self.present(vc, animated: true, completion: nil)
        
        
        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.POST_PARKING
        
        print("url--\(url)")
        
        
        Helper().Request_Api(url: url, methodType: .post, parameters: params, isHeaderIncluded: true, headers: headers){ response in
            
            print("response>>>\(response)")
            
            if response.result.value == nil {
                print("No response")
                
                SharedHelper().showToast(message: "Internal Server Error", controller: self)
                return
            }
            else {
                let responseData = response.result.value as! NSDictionary
                let status = responseData["success"] as! Bool
                if(status)
                {
                    let message = responseData["message"] as! String
                    //let uData = responseData["data"] as! NSDictionary
                    //let userData = uData["user"] as! NSDictionary
                    //self.saveData(userData: userData)
                    //                    SharedHelper().hideSpinner(view: self.view)
                    //                     UserDefaults.standard.set("yes", forKey: "login")
                    //                    UserDefaults.standard.synchronize()
                    SharedHelper().showToast(message: message, controller: self)
                    
                    completion()
                    //self.after_signin()
                }
                else
                {
                    let message = responseData["message"] as! String
                    SharedHelper().showToast(message: message, controller: self)
                    //   SharedHelper().hideSpinner(view: self.view)
                }
            }
        }
    }
}


extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
