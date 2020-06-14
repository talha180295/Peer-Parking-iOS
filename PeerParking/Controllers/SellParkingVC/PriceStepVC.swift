//
//  StepFourVC.swift
//  PeerParking
//
//  Created by Apple on 04/11/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import EzPopup

class PriceStepVC: UIViewController {

    @IBOutlet weak var amount_tf: UITextField!
    @IBOutlet weak var is_negotiable: UISwitch!
    @IBOutlet weak var imgInfo: UIImageView!
    
    //Intent Variables
    var isPrivate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(0, forKey: "is_negotiable")
        GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(0, forKey: "is_negotiable")
        
    }
    
    @IBAction func amount_tf(_ sender: UITextField) {
        
        amount_tf.resignFirstResponder()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PricePicker") as! PricePicker
        
        vc.completionBlock = {(dataReturned) -> ()in
            //Data is returned **Do anything with it **
            print(dataReturned)
            self.amount_tf.text = dataReturned
            self.imgInfo.isHidden = true
            
            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(Double(dataReturned)!, forKey: "initial_price")
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
            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(1, forKey: "is_negotiable")
            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(1, forKey: "is_negotiable")
        }
        else{
            is_negotiable.isOn = false
            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(0, forKey: "is_negotiable")
            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(0, forKey: "is_negotiable")
        }
       
    }
    
    @IBAction func quickPost(_ sender: UIButton) {
        
         if(self.amount_tf.hasText){
            self.imgInfo.isHidden = true
            

            let vc = QuickPopup.instantiate(fromPeerParkingStoryboard: .SellParking)
            vc.isPrivate = isPrivate
            
            let popupVC = PopupViewController(contentController: vc, popupWidth: 350, popupHeight: 400)
            popupVC.canTapOutsideToDismiss = true
            
            //properties
            //            popupVC.backgroundAlpha = 1
            //            popupVC.backgroundColor = .black
            //            popupVC.canTapOutsideToDismiss = true
                        popupVC.cornerRadius = 10
            //            popupVC.shadowEnabled = true
            
            // show it by call present(_ , animated:) method from a current UIViewController
            present(popupVC, animated: true)
        }
        else{
            self.imgInfo.isHidden = false
            
        }
    }
    

}
