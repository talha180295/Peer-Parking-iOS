//
//  MySpotsDetailBS.swift
//  PeerParking
//
//  Created by Apple on 26/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class MySpotsDetailBS: UIViewController {

    var privateSpot:PrivateParkingModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func showDetailsBtn(_ sender: UIButton) {
        
        let vc = Helper().getViewController(storyBoard: "Main", withIdentifier: "PrivateParkingDetailsVC") as! PrivateParkingDetailsVC
        vc.privateSpot = self.privateSpot
        self.present(vc, animated: true)
//        NotificationCenter.default.post(name: Notification.Name("mode_filter"), object: nil, userInfo:["mode" : 10] )
//
//        self.dismiss(animated: false)
    }
    
    
    @IBAction func showBookingsBtn(_ sender: UIButton) {
        
       NotificationCenter.default.post(name: Notification.Name("mode_filter"), object: nil, userInfo:["mode" : 20] )
        
        self.dismiss(animated: false)
    
    }

}
