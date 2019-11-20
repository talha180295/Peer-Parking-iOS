//
//  Sell_parking_popup.swift
//  PeerParking
//
//  Created by Apple on 12/11/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class Sell_parking_popup: UIViewController {

    
    @IBOutlet weak var priceView: UIView!
    
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
    
    
    @IBAction func submit_btn(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "parkedVC")
        
        self.present(vc, animated: true, completion: nil)
    }
    
}
