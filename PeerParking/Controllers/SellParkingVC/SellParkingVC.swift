//
//  SellParkingVC.swift
//  PeerParking
//
//  Created by Apple on 25/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import StepIndicator

class SellParkingVC: UIViewController {

    var counter = 0
    
    @IBOutlet weak var step_progress: StepIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func pre_btn(_ sender: UIButton) {
        if(counter != 0){
            counter-=1
            step_progress.currentStep = counter
            let data = ["counter":counter]
            NotificationCenter.default.post(name: Notification.Name("btn_tap"), object: nil,userInfo: data)
        }
        
       
    }
    
    @IBAction func for_btn(_ sender: UIButton) {
        if(counter != 5){
            counter+=1
            step_progress.currentStep = counter
            let data = ["counter":counter]
            NotificationCenter.default.post(name: Notification.Name("btn_tap"), object: nil,userInfo: data)
        }
        
    }
    
}
