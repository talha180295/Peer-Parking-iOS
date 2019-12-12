//
//  StepThreeVC.swift
//  PeerParking
//
//  Created by Apple on 28/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import DatePickerDialog
import EzPopup

class StepThreeVC: UIViewController {

    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var per_hour_btn: UIButton!
    @IBOutlet weak var entire_btn: UIButton!
    
    @IBOutlet weak var hours_limit: UITextField!
    @IBOutlet weak var allowed_timing_tf: UITextField!
    @IBOutlet weak var extra_fee_tf: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.deleteViewsFromStack(index: 1)
        self.deleteViewsFromStack(index: 3)
        self.deleteViewsFromStack(index: 5)
        
        self.per_hour_btn.isHidden = true
        self.entire_btn.isHidden = true
        
        //GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(10, forKey: "parking_extra_fee_unit")
    }
    

    @IBAction func extra_fees_switch(_ sender: UIButton) {

        if(sender.tag == 1){
            
            sender.setBackgroundImage(UIImage(named: "round_rect_blue"), for: .normal)
            sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            entire_btn.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
            entire_btn.isSelected = false
            entire_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(10, forKey: "parking_extra_fee_unit")
           
        }
        else if(sender.tag == 2){
            
            
            sender.setBackgroundImage(UIImage(named: "round_rect_blue"), for: .normal)
            sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            per_hour_btn.setBackgroundImage(UIImage(named: "round_rect_white"), for: .normal)
            per_hour_btn.isSelected = false
            per_hour_btn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(20, forKey: "parking_extra_fee_unit")
        }
    }
    
    @IBAction func s1(_ sender: UISwitch) {
       
        self.deleteViewsFromStack(index: 1)
        
//        if(sender.isOn){
//            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(hours_limit.text!, forKey: "parking_hours_limit")
//        }
    }
    
    @IBAction func s2(_ sender: UISwitch) {
        
        self.deleteViewsFromStack(index: 3)
        
//        if(sender.isOn){
//            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(allowed_timing_tf.text!, forKey: "parking_allowed_until")
//        }
        
    }
    @IBAction func s3(_ sender: UISwitch) {
        
        self.deleteViewsFromStack(index: 5)
//       
//        if(sender.isOn){
//            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(10, forKey: "parking_extra_fee_unit")
//            
//        }
        
    }
    
    @IBAction func s4(_ sender: UISwitch) {
        
        if(sender.isOn){
            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(true, forKey: "is_resident_free")
        }
    }
    
    func deleteViewsFromStack(index : Int)
    {
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
    
    
    
    @IBAction func parking_time_btn(_ sender: UITextField) {
        sender.resignFirstResponder()
        hours_limit.resignFirstResponder()
        datePickerTapped(sender:sender)
    }
    
    @IBAction func extra_fees_btn(_ sender: UITextField) {
        sender.resignFirstResponder()
        hours_limit.resignFirstResponder()
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PricePicker") as! PricePicker
        
        vc.completionBlock = {(dataReturned) -> ()in
            //Data is returned **Do anything with it **
            print(dataReturned)
            self.extra_fee_tf.text = "$\(dataReturned)"
            
            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(Double(dataReturned)!, forKey: "parking_extra_fee")
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
    func datePickerTapped(sender:UITextField) {
        DatePickerDialog(buttonColor:#colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)).show("Select Time", doneButtonTitle: "DONE", cancelButtonTitle: "CANCEL", datePickerMode: .dateAndTime) {
            (date) -> Void in
            if let time = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                //self.datePickerTapped2(sender: sender,from: formatter.string(from: time))
                sender.text = formatter.string(from: time)
                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(sender.text!, forKey: "parking_allowed_until")
            }
        }
    }
    @IBAction func hour_limit(_ sender: UITextField) {
        
//        let a:String = "1"
//
//        let hours = sender.text
//
//        if(sender.hasText){
//            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(Double(hours!)!, forKey: "parking_hours_limit")
//        }
       
        sender.resignFirstResponder()
       
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Hours_picker") as! Hours_picker
        
        vc.completionBlock = {(dataReturned) -> ()in
            //Data is returned **Do anything with it **
            print(dataReturned)
            self.hours_limit.text = "\(dataReturned)"
            
            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(Double(dataReturned)!, forKey: "parking_hours_limit")
        }
        let popupVC = PopupViewController(contentController: vc, popupWidth: 250, popupHeight: 250)
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
    
//    func datePickerTapped2(sender:UITextField, from:String) {
//        DatePickerDialog().show("To", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
//            (date) -> Void in
//            if let time = date {
//                let formatter = DateFormatter()
//                formatter.dateFormat = "hh:mm a"
//                sender.text = "From: \(from) - \(formatter.string(from: time))"
//            }
//        }
//    }
//    if(self.watchArray.count == 0)
//    {
//    self.deleteViewsFromStack(index: 3)
//    }
   

}
