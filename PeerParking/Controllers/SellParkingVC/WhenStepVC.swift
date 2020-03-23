//
//  StepOneVC.swift
//  PeerParking
//
//  Created by Apple on 28/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import DatePickerDialog

class WhenStepVC: UIViewController {
    
    
    
    //@IBOutlet weak var price_switch: DGRunkeeperSwitch!
    
    @IBOutlet weak var date_field: UITextField!
    @IBOutlet weak var time_field: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        time_field.resignFirstResponder()
//        if let multi_switch = price_switch {
//            //
//            multi_switch.titles = ["Now", "At"]
//            multi_switch.borderWidth = 0.3
//            multi_switch.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
//            multi_switch.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            multi_switch.selectedBackgroundColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)
//            multi_switch.titleColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
//            multi_switch.selectedTitleColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//
//            //multi_switch.titleFont = UIFont(name: "Poppins-Bold", size: 17.0)
//        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = APP_CONSTANT.DATE_TIME_FORMAT
        let result = formatter.string(from: date)
        self.time_field.text = result
        
        GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(self.time_field.text!, forKey: "start_at")
        
    }
    

    @IBAction func tap_date_field(_ sender: UITextField) {
        

//        datePickerTapped()
  
        
    }
    
      @IBAction func tap_field(_ sender: UITextField) {
          

          datePickerTapped()
    
          
      }
    
    
    
    func datePickerTapped() {
        DatePickerDialog(buttonColor:#colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)).show("Select Time", doneButtonTitle: "DONE", cancelButtonTitle: "CANCEL", datePickerMode: .dateAndTime) {
            (date) -> Void in
            if let time = date {
                let formatter = DateFormatter()
                formatter.dateFormat = APP_CONSTANT.DATE_TIME_FORMAT
                self.time_field.text = formatter.string(from: time)
                
                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(self.time_field.text!, forKey: "start_at")
                
            }
        }
    }
    
//    @IBAction func switchValueDidChange(sender: DGRunkeeperSwitch!) {
//        print("valueChanged: \(sender.selectedIndex)")
//        
//        if(sender.selectedIndex == 1){
//                time_field.isHidden = false
//        }
//        else{
//            time_field.isHidden = true
//        }
//    }
   
    
}
