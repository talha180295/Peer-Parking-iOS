//
//  QuickPopup.swift
//  PeerParking
//
//  Created by Apple on 30/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class QuickPopup: UIViewController {

    @IBOutlet weak var time:UILabel!
    @IBOutlet weak var price:UILabel!
    @IBOutlet weak var location:UILabel!
    @IBOutlet weak var parkingType:UILabel!
    @IBOutlet weak var size:UILabel!
    
    var isPrivate = false
    var params:[String:Any]!
    override func viewDidLoad() {
        super.viewDidLoad()

        if(self.isPrivate){
           params = GLOBAL_VAR.PRIVATE_PARKING_MODEL
        }
        else{
           params = GLOBAL_VAR.PARKING_POST_DETAILS
        }
        
        self.setupView()
        
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

    @IBAction func post(_ sender:UIButton){
        
        
    }

}
