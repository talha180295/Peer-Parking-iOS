//
//  StepTwoVC.swift
//  PeerParking
//
//  Created by Apple on 28/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class StepTwoVC: UIViewController {

    
    @IBOutlet weak var mini_btn: UIButton!
    @IBOutlet weak var family_btn: UIButton!
    @IBOutlet weak var suv_btn: UIButton!
    @IBOutlet weak var bus_btn: UIButton!
    
    @IBOutlet weak var lot_btn: UIButton!
    @IBOutlet weak var street_btn: UIButton!
    @IBOutlet weak var private_btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        mini_btn.isSelected = true
        //lot_btn.isSelected = true
    }
    

    @IBAction func car_size_btn_click(_ sender: UIButton) {
        
        if(sender.tag == 1){
            
            
            mini_btn.setImage(UIImage(named: "mini_selected"), for: .normal)
            
            family_btn.setImage(UIImage(named: "family_unselected"), for: .normal)
            
            suv_btn.setImage(UIImage(named: "suv_unselected"), for: .normal)
            
            bus_btn.setImage(UIImage(named: "bus_unselected"), for: .normal)
        }
        else if(sender.tag == 2){
            
            
            mini_btn.setImage(UIImage(named: "mini_unselected"), for: .normal)
            
            family_btn.setImage(UIImage(named: "family_selected"), for: .normal)
            
            suv_btn.setImage(UIImage(named: "suv_unselected"), for: .normal)
            
            bus_btn.setImage(UIImage(named: "bus_unselected"), for: .normal)
        }
        else if(sender.tag == 3){
            
            
            mini_btn.setImage(UIImage(named: "mini_unselected"), for: .normal)
            
            family_btn.setImage(UIImage(named: "family_unselected"), for: .normal)
            
            suv_btn.setImage(UIImage(named: "suv_selected"), for: .normal)
            
            bus_btn.setImage(UIImage(named: "bus_unselected"), for: .normal)
        }
        else if(sender.tag == 4){
            
            
            mini_btn.setImage(UIImage(named: "mini_unselected"), for: .normal)
            
            family_btn.setImage(UIImage(named: "family_unselected"), for: .normal)
            
            suv_btn.setImage(UIImage(named: "suv_unselected"), for: .normal)
            
            bus_btn.setImage(UIImage(named: "bus_selected"), for: .normal)
        }
        
    }
    
    
   
    
  
    

    @IBAction func private_btn_click(_ sender: UIButton) {
        
        button_click(sender: sender)
        
    }
    
    @IBAction func parking_type_btn_click(_ sender: UIButton) {
        
        button_click(sender: sender)
        
    }
    
    func button_click(sender: UIButton){
        
       
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
                
                street_btn.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                street_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                street_btn.isSelected = false
                
                lot_btn.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                lot_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                lot_btn.isSelected = false
                
                
            }
            else{
                
                print("::=selected")
                
                
                
                sender.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
                sender.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
                
                sender.isSelected = false
            }
        }
        
    }

}
