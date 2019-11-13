//
//  FinishPopup.swift
//  PeerParking
//
//  Created by Apple on 29/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class FinishPopup: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func finish_btn(_ sender: UIButton) {

        let vehicle_type = GLOBAL_VAR.PARKING_POST_DETAILS["vehicle_type"] as! Int
        let parking_type = GLOBAL_VAR.PARKING_POST_DETAILS["parking_type"] as! Int
        let status = GLOBAL_VAR.PARKING_POST_DETAILS["status"] as! Int
        let initial_price = GLOBAL_VAR.PARKING_POST_DETAILS["initial_price"] as! Double
        let final_price = GLOBAL_VAR.PARKING_POST_DETAILS["final_price"] as! Double
        let start_at = GLOBAL_VAR.PARKING_POST_DETAILS["start_at"] as! String
        let end_at = GLOBAL_VAR.PARKING_POST_DETAILS["end_at"] as! String
        let address = GLOBAL_VAR.PARKING_POST_DETAILS["address"] as! String
        let longitude = GLOBAL_VAR.PARKING_POST_DETAILS["longitude"] as! String
        let latitude = GLOBAL_VAR.PARKING_POST_DETAILS["latitude"] as! String
        let is_negotiable = GLOBAL_VAR.PARKING_POST_DETAILS["is_negotiable"] as! Bool
        let image = GLOBAL_VAR.PARKING_POST_DETAILS["image"] as! String
        let note = GLOBAL_VAR.PARKING_POST_DETAILS["note"] as! String
        let parking_hours_limit = GLOBAL_VAR.PARKING_POST_DETAILS["parking_hours_limit"] as! Double
        let parking_allowed_until = GLOBAL_VAR.PARKING_POST_DETAILS["parking_allowed_until"] as! String
        let parking_extra_fee_unit = GLOBAL_VAR.PARKING_POST_DETAILS["parking_extra_fee_unit"] as! Double
        let is_resident_free = GLOBAL_VAR.PARKING_POST_DETAILS["is_resident_free"] as! Bool
        
        print("abcdef=\(vehicle_type)")
 
        let params:[String:Any] = [
            "vehicle_type": vehicle_type,
            "parking_type": parking_type,
            "status": status,
            "initial_price": initial_price,
            "final_price": final_price,
            "start_at": start_at,
            "end_at": end_at,
            "address": address,
            "longitude": longitude,
            "latitude": latitude,
            "is_negotiable": is_negotiable,
            "image": image,
            "note": note,
            "parking_hours_limit": parking_hours_limit,
            "parking_allowed_until": parking_allowed_until,
            "parking_extra_fee_unit": parking_extra_fee_unit,
            "is_resident_free": is_resident_free
        ]
        
        print("params=\(params)")
        
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customVC")
//        self.present(vc, animated: true, completion: nil)

        
    }
    
   

}
