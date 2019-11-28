//
//  Sell_parking_popup.swift
//  PeerParking
//
//  Created by Apple on 12/11/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import EzPopup
import DatePickerDialog

class Sell_parking_popup: UIViewController {

    
    @IBOutlet weak var priceView: UIView!
    
    
    
    @IBOutlet weak var price_tf: UITextField!
    @IBOutlet weak var time_tf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        priceView.isHidden = true
        
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func want_to_sell(_ sender: UIButton) {
       
        if(sender.tag == 1){
            
            self.priceView.isHidden = false
            
            
//            self.show(vc, sender: sender)
            
        }
        else if (sender.tag == 2){
            
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func price_change(_ sender: UITextField) {
        
        sender.resignFirstResponder()
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PricePicker") as! PricePicker
        
        vc.completionBlock = {(dataReturned) -> ()in
            //Data is returned **Do anything with it **
            print(dataReturned)
            sender.text = "$\(dataReturned)"
            
            //GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(Double(dataReturned)!, forKey: "parking_extra_fee")
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
    @IBAction func time_change(_ sender: UITextField) {
        
        sender.resignFirstResponder()
        datePickerTapped(sender:sender)
    }
    
    @IBAction func submit_btn(_ sender: UIButton) {
        
        
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "parkedVC")
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func datePickerTapped(sender:UITextField) {
        DatePickerDialog().show(sender.placeholder!, doneButtonTitle: "DONE", cancelButtonTitle: "Cancel", datePickerMode: .time) {
            (date) -> Void in
            if let time = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                //self.datePickerTapped2(sender: sender,from: formatter.string(from: time))
                sender.text = formatter.string(from: time)
                //GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(sender.text!, forKey: "parking_allowed_until")
            }
        }
    }
    
}
