//
//  MySpotsDetailBS.swift
//  PeerParking
//
//  Created by Apple on 26/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class MySpotsDetailBS: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func showDetailsBtn(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: Notification.Name("mode_filter"), object: nil, userInfo:["mode" : 10] )
        
        
        
        let vc = MySpotParkingDetailVC.instantiate(fromPeerParkingStoryboard: .ParkingDetails)
        //        self.navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true,completion: nil)
        
        //        self.dismiss(animated: false)
    }
    
    
    @IBAction func showBookingsBtn(_ sender: UIButton) {
        
       NotificationCenter.default.post(name: Notification.Name("mode_filter"), object: nil, userInfo:["mode" : 20] )
        
        self.dismiss(animated: false)
    
    }

}
