//
//  StepTwoVC.swift
//  PeerParking
//
//  Created by Apple on 28/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class DetailStepVC: UIViewController {

    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var mini_btn: UIButton!
    @IBOutlet weak var family_btn: UIButton!
    @IBOutlet weak var suv_btn: UIButton!
    @IBOutlet weak var bus_btn: UIButton!
    
    @IBOutlet weak var parkingType1: UIButton!
    @IBOutlet weak var parkingType2: UIButton!
    
    var isPrivate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(isPrivate){
          
            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(APP_CONSTANT.VEHICLE_TYPES.MINI, forKey: APP_CONSTANT.VEHICLE_TYPES.vehicle_type)
                   
            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(APP_CONSTANT.PARKING_TYPES.PRIVATE_CONST, forKey: APP_CONSTANT.PARKING_TYPES.parking_type)

            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(APP_CONSTANT.PARKING_SUB_TYPES.LOT_CONST, forKey: APP_CONSTANT.PARKING_SUB_TYPES.parking_sub_type)
        }
        else{
            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(APP_CONSTANT.VEHICLE_TYPES.MINI, forKey: APP_CONSTANT.VEHICLE_TYPES.vehicle_type)

            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(APP_CONSTANT.PARKING_TYPES.PUBLIC_CONST, forKey: APP_CONSTANT.PARKING_TYPES.parking_type)

            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(APP_CONSTANT.PARKING_SUB_TYPES.LOT_CONST, forKey: APP_CONSTANT.PARKING_SUB_TYPES.parking_sub_type)
        }
        
       
        
        print(isPrivate)
        
        if(isPrivate){
            parkingType1.setTitle("Garage", for: .normal)
            parkingType2.setTitle("Driveway", for: .normal)
        }
        
        
    }
    
    @IBAction func titleTF_didchange(_ sender: UITextField) {
        
        if(titleTF.hasText){
          
            let title = titleTF.text ?? ""
            if(isPrivate){
                GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(title , forKey: "title")
            }
            else{
                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(title , forKey: "title")
            }
            
        }
        
    
    }
    @IBAction func car_size_btn_click(_ sender: UIButton) {
        
        if(sender.tag == 1){
            
            
            mini_btn.setImage(UIImage(named: "mini_selected"), for: .normal)
            
            family_btn.setImage(UIImage(named: "family_unselected"), for: .normal)
            
            suv_btn.setImage(UIImage(named: "suv_unselected"), for: .normal)
            
            bus_btn.setImage(UIImage(named: "bus_unselected"), for: .normal)
            
            if(isPrivate){
                GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(APP_CONSTANT.VEHICLE_TYPES.MINI, forKey: APP_CONSTANT.VEHICLE_TYPES.vehicle_type)
            }
            else{
                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(APP_CONSTANT.VEHICLE_TYPES.MINI, forKey: APP_CONSTANT.VEHICLE_TYPES.vehicle_type)
            }
            
            
            
            
        }
        else if(sender.tag == 2){
            
            
            mini_btn.setImage(UIImage(named: "mini_unselected"), for: .normal)
            
            family_btn.setImage(UIImage(named: "family_selected"), for: .normal)
            
            suv_btn.setImage(UIImage(named: "suv_unselected"), for: .normal)
            
            bus_btn.setImage(UIImage(named: "bus_unselected"), for: .normal)
            
            if(isPrivate){
                GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(APP_CONSTANT.VEHICLE_TYPES.FAMILY, forKey: APP_CONSTANT.VEHICLE_TYPES.vehicle_type)
            }
            else{
                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(APP_CONSTANT.VEHICLE_TYPES.FAMILY, forKey: APP_CONSTANT.VEHICLE_TYPES.vehicle_type)
            }
            
            
        }
        else if(sender.tag == 3){
            
            
            mini_btn.setImage(UIImage(named: "mini_unselected"), for: .normal)
            
            family_btn.setImage(UIImage(named: "family_unselected"), for: .normal)
            
            suv_btn.setImage(UIImage(named: "suv_selected"), for: .normal)
            
            bus_btn.setImage(UIImage(named: "bus_unselected"), for: .normal)
            
            if(isPrivate){
                GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(APP_CONSTANT.VEHICLE_TYPES.SUV, forKey: APP_CONSTANT.VEHICLE_TYPES.vehicle_type)
            }
            else{
                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(APP_CONSTANT.VEHICLE_TYPES.SUV, forKey: APP_CONSTANT.VEHICLE_TYPES.vehicle_type)
            }
            
            
        }
        else if(sender.tag == 4){
            
            
            mini_btn.setImage(UIImage(named: "mini_unselected"), for: .normal)
            
            family_btn.setImage(UIImage(named: "family_unselected"), for: .normal)
            
            suv_btn.setImage(UIImage(named: "suv_unselected"), for: .normal)
            
            bus_btn.setImage(UIImage(named: "bus_selected"), for: .normal)
            
            if(isPrivate){
                GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(APP_CONSTANT.VEHICLE_TYPES.BUS, forKey: APP_CONSTANT.VEHICLE_TYPES.vehicle_type)
            }
            else{
                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(APP_CONSTANT.VEHICLE_TYPES.BUS, forKey: APP_CONSTANT.VEHICLE_TYPES.vehicle_type)
            }
            
            
        }
        
    }
    
    
   
    
  

    
    @IBAction func parking_type_btn_click(_ sender: UIButton) {
        
        button_click(sender: sender)
        
    }
    
    func button_click(sender: UIButton){
        
       
        if(sender.tag == 1){
            
            
            sender.setBackgroundImage(UIImage(named: "round_rect_blue"), for: .normal)
            sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            parkingType2.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
            parkingType2.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
          
            if(isPrivate){
                GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(APP_CONSTANT.PARKING_SUB_TYPES.LOT_CONST, forKey: APP_CONSTANT.PARKING_SUB_TYPES.parking_sub_type)
            }
            else{
                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(APP_CONSTANT.PARKING_SUB_TYPES.LOT_CONST, forKey: APP_CONSTANT.PARKING_SUB_TYPES.parking_sub_type)
            }
            
            
        }
        else if(sender.tag == 2){
            
            sender.setBackgroundImage(UIImage(named: "round_rect_blue"), for: .normal)
            sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            
            parkingType1.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
            parkingType1.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
         
            if(isPrivate){
                GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(APP_CONSTANT.PARKING_SUB_TYPES.STREET_CONST, forKey: APP_CONSTANT.PARKING_SUB_TYPES.parking_sub_type)
            }
            else{
                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(APP_CONSTANT.PARKING_SUB_TYPES.STREET_CONST, forKey: APP_CONSTANT.PARKING_SUB_TYPES.parking_sub_type)
            }
            
            
            
        }

        
        
    }

}
