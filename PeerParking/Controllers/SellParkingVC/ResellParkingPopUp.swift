//
//  ResellParkingPopUp.swift
//  PeerParking
//
//  Created by talha on 23/07/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//


import UIKit
import EzPopup
import DatePickerDialog
import Alamofire
import HelperClassPod

class ResellParkingPopUp: UIViewController {

    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var price_tf: UITextField!
    @IBOutlet weak var time_tf: UITextField!
    @IBOutlet weak var date_tf: UITextField!
    @IBOutlet weak var submit_btn: UIButton!
    @IBOutlet weak var nego_switch: UISwitch!
    
    var parking_details:Parking!
    
    var params:[String:Any] = [:]
    
    var date = ""
    var time = ""
//    var dateAndTime = ""
    var price = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submit_btn.isHidden = true
        
        priceView.isHidden = true
        
        self.date = DateHelper.getFormatedDate(dateStr: self.parking_details.startAt ?? "", outFormat: dateFormat.MMddyyy.rawValue)
        
        self.time = DateHelper.getFormatedDate(dateStr: self.parking_details.startAt ?? "", outFormat: dateFormat.hmma.rawValue)
        
        self.price = self.parking_details.finalPrice ?? 0.0
        
        self.nego_switch.isOn = self.parking_details.isNegotiable ?? false
        
        self.setupView()
        print("abcdparkings=\(self.parking_details)")
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        
        self.time_tf.text = self.time
        self.date_tf.text = self.date
        self.price_tf.text = String(self.price)
        
        if(self.price_tf.hasText)&&(self.time_tf.hasText)&&(self.date_tf.hasText){
            
            self.submit_btn.isHidden = false
        }
        else{
            
            self.submit_btn.isHidden = true
        }
        
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
            
            
            if(self.price_tf.hasText)&&(self.time_tf.hasText)&&(self.date_tf.hasText){
                
                self.submit_btn.isHidden = false
            }
            else{
                
                self.submit_btn.isHidden = true
            }
            //GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(Double(dataReturned)!, forKey: "parking_extra_fee")
            self.params.updateValue(Double(dataReturned)!, forKey: "initial_price")
            
            self.parking_details.initialPrice = Double(dataReturned)!
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
        timePickerTapped(sender:sender)
    }
    
    @IBAction func date_change(_ sender: UITextField) {
        
        sender.resignFirstResponder()
        datePickerTapped(sender:sender)
    }

    
    @IBAction func submit_btn(_ sender: UIButton) {
        
        let sendingTime = DateHelper.getFormatedDate(dateStr: self.time, inFormat: dateFormat.hmma.rawValue, outFormat: dateFormat.HHmmss.rawValue)
        let sendingDate = DateHelper.getFormatedDate(dateStr: self.date, inFormat: dateFormat.MMddyyy.rawValue, outFormat: dateFormat.yyyyMMdd.rawValue)
        let dateTime = "\(sendingDate) \(sendingTime)"
        
        self.params.updateValue(dateTime, forKey: "start_at")
        self.parking_details.startAt = dateTime
        
        self.parking_details.isNegotiable = self.nego_switch.isOn
        
        
        var seller : Seller = Seller(id: self.parking_details.buyer?.id, name: self.parking_details.buyer?.name, email: self.parking_details.buyer?.email, createdAt: self.parking_details.buyer?.createdAt, details: self.parking_details.buyer?.details)
        
        self.parking_details.seller = seller
        self.parking_details.buyer = nil
//        self.parking_details.seller = self.parking_details.buyer
//        self.parking_details.buyer = Buyer()

        //                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(sender.text!, forKey: "parking_allowed_until")
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
            Helper().presentOnMainScreens(controller: self, index: 0)
            //tab_index = 0
//            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "parkedVC")
            //
            //        self.present(vc, animated: true, completion: nil)
        }
        
        
        
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "parkedVC")
//
//        self.present(vc, animated: true, completion: nil)
    }
    
    func timePickerTapped(sender:UITextField) {
        DatePickerDialog(buttonColor:#colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)).show("Select Time", doneButtonTitle: "DONE", cancelButtonTitle: "CANCEL", datePickerMode: .time) {
            (date) -> Void in
            
            if let time = date {
                
                let timeStr = DateHelper.getDateString(date: time)
                
//                let timetoDisplay = DateHelper.getFormatedDate(dateStr: timeStr, outFormat: dateFormat.hmma.rawValue)
//                let timeForSend = DateHelper.getFormatedDate(dateStr: timeStr, outFormat: dateFormat.hmma.rawValue)
                
                self.time = DateHelper.getFormatedDate(dateStr: timeStr, outFormat: dateFormat.hmma.rawValue)

                self.setupView()
                
//                self.params.updateValue(self.time, forKey: "start_at")
//                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(sender.text!, forKey: "parking_allowed_until")
            }
        }
    }
    
    func datePickerTapped(sender:UITextField) {
        DatePickerDialog(buttonColor:#colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)).show("Select Time", doneButtonTitle: "DONE", cancelButtonTitle: "CANCEL", datePickerMode: .date) {
            (date) -> Void in
            
            if let date = date {
                
                let dateStr = DateHelper.getDateString(date: date)
                
//                let timetoDisplay = DateHelper.getFormatedDate(dateStr: timeStr, outFormat: dateFormat.hmma.rawValue)
//                let timeForSend = DateHelper.getFormatedDate(dateStr: timeStr, outFormat: dateFormat.hmma.rawValue)
                
                self.date = DateHelper.getFormatedDate(dateStr: dateStr, outFormat: dateFormat.MMddyyy.rawValue)

                self.setupView()
                
//                self.params.updateValue(self.time, forKey: "start_at")
//                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(sender.text!, forKey: "parking_allowed_until")
            }
        }
    }

    
    func resell_parking(completion: @escaping () -> Void){
        
        
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
        
        do{
            let data = try JSONEncoder().encode(self.parking_details)
            Helper().showSpinner(view: self.view)
            let request = APIRouter.postPublicParking(data)
            APIClient.serverRequest(url: request, path: request.getPath(),body: self.parking_details.dictionary ?? [:], dec: PostResponseData.self) { (response, error) in
                Helper().hideSpinner(view: self.view)
                if(response != nil){
                    if (response?.success) != nil {
                        Helper().showToast(message: response?.message ?? "-", controller: self)
                        
                        
                    }
                    else{
                        Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                    }
                }
                else if(error != nil){
                    Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
                }
                else{
                    Helper().showToast(message: "Nor Response and Error!!", controller: self)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    completion()
                }
                                
            }
        }
        catch let parsingError {
            
            print("Error", parsingError)
            
        }
        
        
//        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.POST_PARKING
//
//        print("url--\(url)")
//
//
//        Helper().Request_Api(url: url, methodType: .post, parameters: params, isHeaderIncluded: true, headers: headers){ response in
//
//            print("response>>>\(response)")
//
//            if response.result.value == nil {
//                print("No response")
//
//                SharedHelper().showToast(message: "Internal Server Error", controller: self)
//                return
//            }
//            else {
//                let responseData = response.result.value as! NSDictionary
//                let status = responseData["success"] as! Bool
//                if(status)
//                {
//                    let message = responseData["message"] as! String
//                    //let uData = responseData["data"] as! NSDictionary
//                    //let userData = uData["user"] as! NSDictionary
//                    //self.saveData(userData: userData)
//                    //                    SharedHelper().hideSpinner(view: self.view)
//                    //                     UserDefaults.standard.set("yes", forKey: "login")
//                    //                    UserDefaults.standard.synchronize()
//                    SharedHelper().showToast(message: message, controller: self)
//
//                    completion()
//                    //self.after_signin()
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
}
