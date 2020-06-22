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
    var navigator:UINavigationController!
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
        let vc = PrivateParkingBookingListVC.instantiate(fromPeerParkingStoryboard: .ParkingDetails)
        vc.modalPresentationStyle = .fullScreen
        self.navigator?.pushViewController(vc, animated: true)
        self.dismiss(animated: false, completion: nil)
//        self.present(vc, animated: true,completion: nil)
        
        
    }
    
}
//extension MySpotsDetailBS:MySpotParkingDetailVCDelegate{
//    func didBackButtonPressed() {
//        
//    }
//}
