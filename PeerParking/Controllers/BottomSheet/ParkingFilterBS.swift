//
//  ParkingFilterBS.swift
//  PeerParking
//
//  Created by Apple on 04/02/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class ParkingFilterBS: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func showAllBtn(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: Notification.Name("mode_filter"), object: nil, userInfo:["is_schedule" : 10] )
        
        self.dismiss(animated: false)
    }
    
    @IBAction func showPostedBtn(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: Notification.Name("mode_filter"), object: nil, userInfo:["mode" : 10] )
        
        self.dismiss(animated: false)
    }
    
    
    @IBAction func showBookedBtn(_ sender: UIButton) {
        
       NotificationCenter.default.post(name: Notification.Name("mode_filter"), object: nil, userInfo:["mode" : 20] )
        
        self.dismiss(animated: false)
    
    }
}
