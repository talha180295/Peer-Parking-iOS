//
//  FilterBottomSheetVC.swift
//  PeerParking
//
//  Created by Apple on 17/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

protocol FiltersProtocol {
    func applyFilters(filters:[String:String]);
}

class FilterBottomSheetVC: UIViewController {

    var delegate: FiltersProtocol?
    @IBOutlet weak var mini_btn: UIButton!
    @IBOutlet weak var family_btn: UIButton!
    @IBOutlet weak var suv_btn: UIButton!
    @IBOutlet weak var bus_btn: UIButton!
    
    @IBOutlet weak var lot_btn: UIButton!
    @IBOutlet weak var street_btn: UIButton!
    @IBOutlet weak var private_btn: UIButton!

    @IBOutlet weak var m_10: UIButton!
    @IBOutlet weak var m_20: UIButton!
    @IBOutlet weak var m_30: UIButton!
    
    @IBOutlet weak var price: UIButton!
    @IBOutlet weak var distance: UIButton!
    
    
    @IBOutlet weak var price_switch: DGRunkeeperSwitch!
    
    var filters:[String:String] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad:f")

//        mini_btn.isSelected = true
//        lot_btn.isSelected = true
        
//
//        if let multi_switch = price_switch {
////
//            multi_switch.titles = ["Low First", "High First"]
//            multi_switch.borderWidth = 0.3
//            multi_switch.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
//            multi_switch.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            multi_switch.selectedBackgroundColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)
//            multi_switch.titleColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
//            multi_switch.selectedTitleColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//
//            //multi_switch.titleFont = UIFont(name: "Poppins-Bold", size: 17.0)
//        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear:f")
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = APP_CONSTANT.DATE_TIME_FORMAT
        let result = formatter.string(from: date)
        filters.updateValue(String(result), forKey: "date_time")
        
        let vehicle_type_f = UserDefaults.standard.string(forKey: "vehicle_type_f")
        print(vehicle_type_f)
        if(vehicle_type_f == "10")&&(vehicle_type_f != ""){
            mini_btn.setImage(UIImage(named: "mini_selected"), for: .normal)
            mini_btn.isSelected = true
        }
        else if(vehicle_type_f == "20")&&(vehicle_type_f != ""){
            family_btn.setImage(UIImage(named: "family_selected"), for: .normal)
            family_btn.isSelected = true
        }
        else if(vehicle_type_f == "30")&&(vehicle_type_f != ""){
            suv_btn.setImage(UIImage(named: "suv_selected"), for: .normal)
            suv_btn.isSelected = true
        }
        else if(vehicle_type_f == "40")&&(vehicle_type_f != ""){
            bus_btn.setImage(UIImage(named: "bus_selected"), for: .normal)
            bus_btn.isSelected = true
        }
        
        
//        if let vehicle_type_f = UserDefaults.standard.string(forKey: "vehicle_type_f"){
//
//            if(vehicle_type_f == "20"){
//                family_btn.setImage(UIImage(named: "family_selected"), for: .normal)
//                family_btn.isSelected = true
//            }
//
//        }
        
    }
    
    
    @IBAction func apply_btn_click(_ sender: UIButton) {
        
//        let transition: CATransition = CATransition()
//        transition.duration = 3.4
//        transition.type = CATransitionType.moveIn
//        transition.subtype = CATransitionSubtype.fromBottom
//        self.view.window?.layer.add(transition, forKey: nil)
        
        
//        filters.
//
        
        if filters.keys.contains("vehicle_type") {
            // now val is not nil and the Optional has been unwrapped, so use it
//            print("filters=\(filters["parking_type"])")
        }
        //print("filters=\(filters)")
        
        delegate?.applyFilters(filters: filters)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func car_size_btn_click(_ sender: UIButton) {
        
        if filters.keys.contains("vehicle_type") {
            filters.removeValue(forKey: "vehicle_type")
        }
        
        vehicle_type_select(sender: sender)
        if(sender.isSelected){
            
            let val = sender.tag * 10
//            filters.updateValue("hey", forKey: "parking_type")
            filters.updateValue(String(val), forKey: "vehicle_type")
            UserDefaults.standard.set(String(val), forKey: "vehicle_type_f")
            UserDefaults.standard.synchronize()
            print("user_def=\(UserDefaults.standard.string(forKey: "vehicle_type_f"))")
        }
        else{
            
            UserDefaults.standard.set("", forKey: "vehicle_type_f")
            UserDefaults.standard.synchronize()
        }
//
//        if(sender.tag == 1){
//
//
//            mini_btn.setImage(UIImage(named: "mini_selected"), for: .normal)
//
//            family_btn.setImage(UIImage(named: "family_unselected"), for: .normal)
//
//            suv_btn.setImage(UIImage(named: "suv_unselected"), for: .normal)
//
//            bus_btn.setImage(UIImage(named: "bus_unselected"), for: .normal)
//        }
//        else if(sender.tag == 2){
//
//
//            mini_btn.setImage(UIImage(named: "mini_unselected"), for: .normal)
//
//            family_btn.setImage(UIImage(named: "family_selected"), for: .normal)
//
//            suv_btn.setImage(UIImage(named: "suv_unselected"), for: .normal)
//
//            bus_btn.setImage(UIImage(named: "bus_unselected"), for: .normal)
//        }
//        else if(sender.tag == 3){
//
//
//            mini_btn.setImage(UIImage(named: "mini_unselected"), for: .normal)
//
//            family_btn.setImage(UIImage(named: "family_unselected"), for: .normal)
//
//            suv_btn.setImage(UIImage(named: "suv_selected"), for: .normal)
//
//            bus_btn.setImage(UIImage(named: "bus_unselected"), for: .normal)
//        }
//        else if(sender.tag == 4){
//
//
//            mini_btn.setImage(UIImage(named: "mini_unselected"), for: .normal)
//
//            family_btn.setImage(UIImage(named: "family_unselected"), for: .normal)
//
//            suv_btn.setImage(UIImage(named: "suv_unselected"), for: .normal)
//
//            bus_btn.setImage(UIImage(named: "bus_selected"), for: .normal)
//        }
        
    }
  
    func vehicle_type_select(sender: UIButton){
    
        if(sender.tag == 1){
            
            if(!sender.isSelected){
                
                print("::=unselected")
                
                 //mini_btn.setImage(UIImage(named: "mini_selected"), for: .normal)
                sender.setImage(UIImage(named: "mini_selected"), for: .normal)
//                sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                sender.isSelected = true
                
                family_btn.setImage(UIImage(named: "family_unselected"), for: .normal)
                family_btn.isSelected = false
//                family_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                
                suv_btn.setImage(UIImage(named: "suv_unselected"), for: .normal)
//                suv_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                suv_btn.isSelected = false
                
                bus_btn.setImage(UIImage(named: "bus_unselected"), for: .normal)
//                bus_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                bus_btn.isSelected = false
                
                
            }
            else{
                
                print("::=selected")
                
                
                
                sender.setImage(UIImage(named: "mini_unselected"), for: .normal)
                
                
                sender.isSelected = false
            }
            
        }
        else if(sender.tag == 2){
            
            
            if(!sender.isSelected){
                
                print("::=unselected")
                
                sender.setImage(UIImage(named: "family_selected"), for: .normal)
                //                sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                sender.isSelected = true
                
                mini_btn.setImage(UIImage(named: "mini_unselected"), for: .normal)
                mini_btn.isSelected = false
                //                family_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                
                suv_btn.setImage(UIImage(named: "suv_unselected"), for: .normal)
                //                suv_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                suv_btn.isSelected = false
                
                bus_btn.setImage(UIImage(named: "bus_unselected"), for: .normal)
                //                bus_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                bus_btn.isSelected = false
                
                
            }
            else{
                
                print("::=selected")
                
                
                
                sender.setImage(UIImage(named: "family_unselected"), for: .normal)
                
                
                sender.isSelected = false
            }
        }
        else if(sender.tag == 3){
            
            
            if(!sender.isSelected){
                
                print("::=unselected")
                
                sender.setImage(UIImage(named: "suv_selected"), for: .normal)
                //                sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                sender.isSelected = true
                
                family_btn.setImage(UIImage(named: "family_unselected"), for: .normal)
                family_btn.isSelected = false
                //                family_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                
                mini_btn.setImage(UIImage(named: "mini_unselected"), for: .normal)
                //                suv_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                mini_btn.isSelected = false
                
                bus_btn.setImage(UIImage(named: "bus_unselected"), for: .normal)
                //                bus_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                bus_btn.isSelected = false
                
                
            }
            else{
                
                print("::=selected")
                
                
                
                sender.setImage(UIImage(named: "suv_unselected"), for: .normal)
                
                
                sender.isSelected = false
            }
        }
        else if(sender.tag == 4){
            
            
            if(!sender.isSelected){
                
                print("::=unselected")
                
                sender.setImage(UIImage(named: "bus_selected"), for: .normal)
                //                sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                sender.isSelected = true
                
                family_btn.setImage(UIImage(named: "family_unselected"), for: .normal)
                family_btn.isSelected = false
                //                family_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                
                suv_btn.setImage(UIImage(named: "suv_unselected"), for: .normal)
                //                suv_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                suv_btn.isSelected = false
                
                mini_btn.setImage(UIImage(named: "mini_unselected"), for: .normal)
                //                bus_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                mini_btn.isSelected = false
                
                
            }
            else{
                
                print("::=selected")
                
                
                
                sender.setImage(UIImage(named: "bus_unselected"), for: .normal)
                
                
                sender.isSelected = false
            }
        }
        //
       
    }
    

    @IBAction func lot_click(_ sender: UIButton) {
        
        button_click(sender: sender)
        
    }
    
    @IBAction func street_bbtn_click(_ sender: UIButton) {
        
        button_click(sender: sender)
        
    }
    
    
    @IBAction func private_btn_click(_ sender: UIButton) {
        
        button_click(sender: sender)
        
    }
    
    
    func button_click(sender: UIButton){
        
//        if(!sender.isSelected){
//
//            print("::=unselected")
//
//            sender.setBackgroundImage(UIImage(named: "round_rect_blue"), for: .normal)
//            sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
//
//            sender.isSelected = true
//        }
//        else{
//
//            print("::=selected")
//
//
//
//            sender.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
//            sender.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
//
//            sender.isSelected = false
        
        if filters.keys.contains("parking_type") {
            filters.removeValue(forKey: "parking_type")
        }
       
            if(sender.tag == 1){
                
                
                if(!sender.isSelected){
                    
                    print("::=unselected")
                    
                    sender.setBackgroundImage(UIImage(named: "round_rect_blue"), for: .normal)
                    sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                    
                    sender.isSelected = true
                    
                    street_btn.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                    street_btn.isSelected = false
                    street_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                    
                    private_btn.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                    private_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                    private_btn.isSelected = false
                    
                    
                }
                else{
                    
                    print("::=selected")
                    
                    
                    
                    sender.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                    sender.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                    
                    sender.isSelected = false
                }
            }
            else if(sender.tag == 2){
                
                if(!sender.isSelected){
                    
                    print("::=unselected")
                    
                    sender.setBackgroundImage(UIImage(named: "round_rect_blue"), for: .normal)
                    sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                    
                    sender.isSelected = true
                    
                    lot_btn.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                    lot_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                    lot_btn.isSelected = false
                    
                    private_btn.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                    private_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                    private_btn.isSelected = false
                    
                    
                }
                else{
                    
                    print("::=selected")
                    
                    
                    
                    sender.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                    sender.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                    
                    sender.isSelected = false
                }
            }
            else if(sender.tag == 3){
                
                
                if(!sender.isSelected){
                    
                    print("::=unselected")
                    
                    sender.setBackgroundImage(UIImage(named: "round_rect_blue"), for: .normal)
                    sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                    
                    sender.isSelected = true
                    
                    lot_btn.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                    lot_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                    lot_btn.isSelected = false
                    
                    street_btn.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                    street_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                    street_btn.isSelected = false
                    
                    
                }
                else{
                    
                    print("::=selected")
                    
                    
                    
                    sender.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                    sender.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                    
                    sender.isSelected = false
                }
            }
        
        
        
        
        
        
        if(sender.isSelected){
            
            let val = sender.tag * 10
            //            filters.updateValue("hey", forKey: "parking_type")
            filters.updateValue(String(val), forKey: "parking_type")
        }
        
        
    }
    
    @IBAction func available_in_btn_click(_ sender: UIButton) {
        
        avail_button_click(sender: sender)
        
    }
    func avail_button_click(sender: UIButton){
        
        
        
        if filters.keys.contains("time_margin") {
            filters.removeValue(forKey: "time_margin")
        }
        
        if(sender.tag == 1){
            
            
            if(!sender.isSelected){
                
                print("::=unselected")
                
                sender.setBackgroundImage(UIImage(named: "round_rect_blue"), for: .normal)
                sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                
                sender.isSelected = true
                
                m_20.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                m_20.isSelected = false
                m_20.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                
                m_30.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                m_30.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                m_30.isSelected = false
                
                
            }
            else{
                
                print("::=selected")
                
                
                
                sender.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                sender.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                
                sender.isSelected = false
            }
        }
        else if(sender.tag == 2){
            
            if(!sender.isSelected){
                
                print("::=unselected")
                
                sender.setBackgroundImage(UIImage(named: "round_rect_blue"), for: .normal)
                sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                
                sender.isSelected = true
                
                m_10.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                m_10.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                m_10.isSelected = false
                
                m_30.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                m_30.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                m_30.isSelected = false
                
                
            }
            else{
                
                print("::=selected")
                
                
                
                sender.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                sender.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                
                sender.isSelected = false
            }
        }
        else if(sender.tag == 3){
            
            
            if(!sender.isSelected){
                
                print("::=unselected")
                
                sender.setBackgroundImage(UIImage(named: "round_rect_blue"), for: .normal)
                sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                
                sender.isSelected = true
                
                m_10.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                m_10.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                m_10.isSelected = false
                
                m_20.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                m_20.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                m_20.isSelected = false
                
                
            }
            else{
                
                print("::=selected")
                
                
                
                sender.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                sender.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                
                sender.isSelected = false
            }
        }
        
        if(sender.isSelected){
            
            let val = sender.tag * 10
            //            filters.updateValue("hey", forKey: "parking_type")
            filters.updateValue(String(val), forKey: "time_margin")
        }
        
    }
    
    @IBAction func sort_buy(_ sender: UIButton) {
        
        sort_by(sender: sender)
    }
    
    func sort_by(sender: UIButton){
        
    
        
        if(sender.tag == 1){
            
            
            if(!sender.isSelected){
                
                print("::=unselected")
                
                sender.setBackgroundImage(UIImage(named: "round_rect_blue"), for: .normal)
                sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                
                sender.isSelected = true
                
                distance.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                distance.isSelected = false
                distance.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                
               
                
                
            }
            else{
                
                print("::=selected")
                
                
                
                sender.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                sender.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                
                sender.isSelected = false
            }
        }
        else if(sender.tag == 2){
            
            if(!sender.isSelected){
                
                print("::=unselected")
                
                sender.setBackgroundImage(UIImage(named: "round_rect_blue"), for: .normal)
                sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                
                sender.isSelected = true
                
                
                price.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                price.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                price.isSelected = false
                
                
            }
            else{
                
                print("::=selected")
                
                
                
                sender.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                sender.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                
                sender.isSelected = false
            }
        }
        
        
        
        
        
        
        if(sender.isSelected){
            
            let val = sender.tag * 10
            //            filters.updateValue("hey", forKey: "parking_type")
            filters.updateValue(String(val), forKey: "orderBy_column")
        }
        
        
    }
    
}


//if filters.keys.contains("vehicle_type") {
//    filters.removeValue(forKey: "vehicle_type")
//}
//
//vehicle_type_select(sender: sender)
//if(sender.isSelected){
//
//    let val = sender.tag * 10
//    //            filters.updateValue("hey", forKey: "parking_type")
//    filters.updateValue(String(val), forKey: "vehicle_type")
//}
