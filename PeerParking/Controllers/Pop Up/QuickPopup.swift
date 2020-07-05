//
//  QuickPopup.swift
//  PeerParking
//
//  Created by Apple on 30/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import EzPopup

class QuickPopup: UIViewController {

    @IBOutlet weak var time:UILabel!
    @IBOutlet weak var price:UILabel!
    @IBOutlet weak var location:UILabel!
    @IBOutlet weak var parkingType:UILabel!
    @IBOutlet weak var size:UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var isPrivate = false
    var params:[String:Any]!
    let placeHolderImage = UIImage(named: "placeholder-img")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(self.isPrivate){
           params = GLOBAL_VAR.PRIVATE_PARKING_MODEL
        }
        else{
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = APP_CONSTANT.DATE_TIME_FORMAT
            let result = formatter.string(from: date)
            
            
            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(result, forKey: "start_at")
            params = GLOBAL_VAR.PARKING_POST_DETAILS
        }
        
        self.setupView()
        self.setCoordinates()
        self.setImage()
        self.setIsAlways()
    }
    
    func setupView(){
        
        let price = params["initial_price"] as? Double ?? 0.0
        let type = params[APP_CONSTANT.PARKING_SUB_TYPES.parking_sub_type] as? Int ?? 0
        let size = params[APP_CONSTANT.VEHICLE_TYPES.vehicle_type] as? Int ?? 0
        
        
        self.price.text =  "$ \(price)"
        
        if(type == 10){
            self.parkingType.text =  "Garage"
        }
        else if(type == 20){
            self.parkingType.text =  "Driveway"
        }
        
        
        if(size == 10){
            self.size.text =  "\(VehicleTypeText.SUPER_MINI)"
        }
        else if(size == 20){
            self.size.text =  "\(VehicleTypeText.FAMILY)"
        }
        else if(size == 30){
            self.size.text =  "\(VehicleTypeText.SUV)"
        }
        else if(size == 40){
            self.size.text =  "\(VehicleTypeText.BUS)"
        }
        
    
        
        
    }

    func setCoordinates(){
        let lat = self.appDelegate.currentLocation?.coordinate.latitude ?? 0.0
        let longg = self.appDelegate.currentLocation?.coordinate.longitude ?? 0.0
        let address = self.appDelegate.currentLocationAddress ?? ""
        
        self.location.text = address
        
        GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(lat, forKey: "latitude")
        GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(longg, forKey: "longitude")
        
        GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(lat, forKey: "latitude")
        GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(longg, forKey: "longitude")
        
        GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(address, forKey: "address")
        GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(address, forKey: "address")
    }
    func setImage(){
        guard let imageData = placeHolderImage?.jpegData(compressionQuality: 1.0) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        
        GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(imageData, forKey: "image")
        
        GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(imageData, forKey: "image")
    }
    
    func setIsAlways(){
        GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(1, forKey: "is_always")
    }
    
    @IBAction func post(_ sender:UIButton){
        let vc = FinishPopup.instantiate(fromPeerParkingStoryboard: .Main)
        vc.isPrivate = self.isPrivate
        
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
