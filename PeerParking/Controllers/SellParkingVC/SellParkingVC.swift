//
//  SellParkingVC.swift
//  PeerParking
//
//  Created by Apple on 11/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class SellParkingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
      
      tab_index = 2
      self.tabBarController!.navigationItem.title = "Sell Parking"
      
//      self.setUPViews()
     
    }

}
