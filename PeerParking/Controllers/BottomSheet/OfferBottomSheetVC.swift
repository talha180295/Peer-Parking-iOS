//
//  OfferBottomSheetVC.swift
//  PeerParking
//
//  Created by Apple on 21/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class OfferBottomSheetVC: UIViewController {

    @IBOutlet weak var parking_title: UILabel!
    
    var p_title = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        parking_title.text = p_title
    }
    
    @IBAction func accept_btn_click(_ sender: UIButton) {
        
        print("Accpet")
//        // Get the destination view controller and data store
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let destinationVC = storyboard.instantiateViewController(withIdentifier: "BottomSheetVC") as! BottomSheetVC
//        var destinationDS = destinationVC.offer_btn.setTitle("GO", for: .normal)
        
        NotificationCenter.default.post(name: Notification.Name("accept_offer"), object: nil)
            
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func send_offer(_ sender: UIButton) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
   

}
