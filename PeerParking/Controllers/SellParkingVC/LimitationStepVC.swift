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

class LimitationStepVC: UIViewController,UITextViewDelegate {

 
    @IBOutlet weak var parking_extra_feeTF: UITextView!
    @IBOutlet weak var parking_hours_limitTF: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        parking_extra_feeTF.delegate = self
        parking_hours_limitTF.delegate = self
    }
    

    func textViewDidBeginEditing(_ textView: UITextView) {
      if textView.textColor == UIColor.lightGray {
          textView.text = nil
          textView.textColor = UIColor.black
      }
    }
      
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if(textView == parking_extra_feeTF){
            
            if(textView.text.isEmpty){
              textView.text = "Add some usefull information"
              textView.textColor = UIColor.lightGray
              GLOBAL_VAR.PARKING_POST_DETAILS.updateValue("", forKey: "parking_extra_fee")
            }
            else{
              
                let fee = parking_extra_feeTF.text ?? ""
                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(fee, forKey: "parking_extra_fee")
            }
            
        }
        else if(textView == parking_hours_limitTF){
            
            
            if(textView.text.isEmpty){
                textView.text = "Add some usefull information"
                textView.textColor = UIColor.lightGray
                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue("", forKey: "parking_hours_limit")
            }
            else{
              
                let hour = parking_hours_limitTF.text ?? ""
                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(hour, forKey: "parking_hours_limit")
            }
            
        }
    
     
    }
    
    
    


}
