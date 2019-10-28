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
        lot_btn.isSelected = true
    }
    

    @IBAction func mini_btn_click(_ sender: UIButton) {
        
        if(!sender.isSelected){
            
            print("::=unselected")
            
            sender.setImage(UIImage(named: "mini_selected"), for: .normal)
            sender.isSelected = true
        }
        else{
            
            print("::=selected")
            
            
            sender.setImage(UIImage(named: "mini_unselected"), for: .normal)
            sender.isSelected = false
        }
    }
    
    
    @IBAction func family_btn_click(_ sender: UIButton) {
        
        
        if(!sender.isSelected){
            
            print("::=unselected")
            
            sender.setImage(UIImage(named: "family_selected"), for: .normal)
            sender.isSelected = true
        }
        else{
            
            print("::=selected")
            
            
            sender.setImage(UIImage(named: "family_unselected"), for: .normal)
            sender.isSelected = false
        }
    }
    
    @IBAction func suv_bnt_click(_ sender: UIButton) {
        
        if(!sender.isSelected){
            
            print("::=unselected")
            
            sender.setImage(UIImage(named: "suv_selected"), for: .normal)
            sender.isSelected = true
        }
        else{
            
            print("::=selected")
            
            
            sender.setImage(UIImage(named: "suv_unselected"), for: .normal)
            sender.isSelected = false
        }
    }
    
    
    @IBAction func bus_btn_click(_ sender: UIButton) {
        
        
        
        if(!sender.isSelected){
            
            print("::=unselected")
            
            sender.setImage(UIImage(named: "bus_selected"), for: .normal)
            sender.isSelected = true
        }
        else{
            
            print("::=selected")
            
            
            sender.setImage(UIImage(named: "bus_unselected"), for: .normal)
            sender.isSelected = false
        }
        //        else{
        //            sender.imageView?.tintColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)
        //        }
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
        
        if(!sender.isSelected){
            
            print("::=unselected")
            
            sender.setBackgroundImage(UIImage(named: "round_rect_blue"), for: .normal)
            sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            sender.isSelected = true
        }
        else{
            
            print("::=selected")
            
            
            
            sender.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
            sender.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
            
            sender.isSelected = false
        }
        
    }

}
