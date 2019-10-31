//
//  StepThreeVC.swift
//  PeerParking
//
//  Created by Apple on 28/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class StepThreeVC: UIViewController {

    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var per_hour_btn: UIButton!
    @IBOutlet weak var entire_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.deleteViewsFromStack(index: 1)
        self.deleteViewsFromStack(index: 3)
        self.deleteViewsFromStack(index: 5)
        
        self.per_hour_btn.isHidden = true
        self.entire_btn.isHidden = true
    }
    

    @IBAction func extra_fees_switch(_ sender: UIButton) {

        if(sender.tag == 1){
            
            sender.setBackgroundImage(UIImage(named: "round_rect_blue"), for: .normal)
            sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            entire_btn.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
            entire_btn.isSelected = false
            entire_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
            
           
        }
        else if(sender.tag == 2){
            
            
            sender.setBackgroundImage(UIImage(named: "round_rect_blue"), for: .normal)
            sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            per_hour_btn.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
            per_hour_btn.isSelected = false
            per_hour_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
        }
    }
    
    @IBAction func s1(_ sender: UISwitch) {
       
        self.deleteViewsFromStack(index: 1)
        
    }
    
    @IBAction func s2(_ sender: UISwitch) {
        
        self.deleteViewsFromStack(index: 3)
        
    }
    @IBAction func s3(_ sender: UISwitch) {
        
        self.deleteViewsFromStack(index: 5)
        
    }
    
    
    func deleteViewsFromStack(index : Int)
    {
//        UIView.animate(withDuration: 0.25) { () -> Void in
//            let firstView = self.stackview.arrangedSubviews[index]
//            firstView.isHidden = !firstView.isHidden
//
//            if(index == 5){
//                self.per_hour_btn.isHidden = !self.per_hour_btn.isHidden
//                self.entire_btn.isHidden = !self.entire_btn.isHidden
//
//            }
//        }
        let firstView = self.stackview.arrangedSubviews[index]
        
        UIView.animate(withDuration: 0.25, animations: {
            () -> Void in
            
            firstView.isHidden = !firstView.isHidden
            
            if(index == 5)&&(firstView.isHidden){
                print("--ifcompletion__")
                self.per_hour_btn.isHidden = true
                self.entire_btn.isHidden = true
                
            }
        }) { (true) in
            
            
            if(index == 5)&&(!firstView.isHidden){
                print("--completion__")
                self.per_hour_btn.isHidden = false
                self.entire_btn.isHidden = false
                
            }
        }
    }
//    if(self.watchArray.count == 0)
//    {
//    self.deleteViewsFromStack(index: 3)
//    }
   

}
