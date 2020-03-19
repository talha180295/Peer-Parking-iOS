//
//  StepFourVC.swift
//  PeerParking
//
//  Created by Apple on 04/11/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import EzPopup

class StepFourVC: UIViewController {

    @IBOutlet weak var amount_tf: UITextField!
    @IBOutlet weak var is_negotiable: UISwitch!
    @IBOutlet weak var imgInfo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(5.0, forKey: "initial_price")
    }
    
    @IBAction func amount_tf(_ sender: UITextField) {
        
        amount_tf.resignFirstResponder()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PricePicker") as! PricePicker
        
        vc.completionBlock = {(dataReturned) -> ()in
            //Data is returned **Do anything with it **
            print(dataReturned)
            self.amount_tf.text = dataReturned
            self.imgInfo.isHidden = true
            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(Double(dataReturned)!, forKey: "initial_price")
            
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
    
    @IBAction func is_neg_switch(_ sender: UISwitch) {
        
        if(sender.isOn){
            is_negotiable.isOn = true
            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(true, forKey: "is_negotiable")
        }
        else{
            is_negotiable.isOn = false
            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(false, forKey: "is_negotiable")
        }
       
    }
    

}
