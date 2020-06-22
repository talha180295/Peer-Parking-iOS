//
//  MySpotsDetailBS.swift
//  PeerParking
//
//  Created by Apple on 26/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class MySpotsDetailBS: UIViewController {
    
    //Intent Variables
    var privateParkingModel:PrivateParkingModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showDetailsBtn(_ sender: UIButton) {
        
        let vc = MySpotParkingDetailVC.instantiate(fromPeerParkingStoryboard: .ParkingDetails)
        vc.setPrivateParingModel(privateParkingModel: privateParkingModel)
        vc.isPublicParking = false
//        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true,completion: nil)
        
    }
    
    
    @IBAction func showBookingsBtn(_ sender: UIButton) {
        
        self.dismiss(animated: false)
        
    }
    
}
//extension MySpotsDetailBS:MySpotParkingDetailVCDelegate{
//    func didBackButtonPressed() {
//        
//    }
//}
