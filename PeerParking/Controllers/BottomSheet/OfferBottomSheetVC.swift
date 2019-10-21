//
//  OfferBottomSheetVC.swift
//  PeerParking
//
//  Created by Apple on 21/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class OfferBottomSheetVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func accept_btn_click(_ sender: UIButton) {
        
        print("Accpet")
//        // Get the destination view controller and data store
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let destinationVC = storyboard.instantiateViewController(withIdentifier: "BottomSheetVC") as! BottomSheetVC
//        var destinationDS = destinationVC.offer_btn.setTitle("GO", for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
   

}
