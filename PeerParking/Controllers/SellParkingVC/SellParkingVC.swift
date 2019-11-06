//
//  SellParkingVC.swift
//  PeerParking
//
//  Created by Apple on 25/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import StepIndicator
import EzPopup

class SellParkingVC: UIViewController {

    var counter = 0
    
    @IBOutlet weak var step_progress: StepIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
   
    override func viewWillAppear(_ animated: Bool) {
        
        
        print("::--=viewWillAppear|SellParking")
        self.tabBarController!.navigationItem.title = "Sell Parking"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        print("::--=viewWillDisappear|SellParking")
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
        if(counter == 5){
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FinishPopup")
            
            
            let popupVC = PopupViewController(contentController: vc, popupWidth: 320, popupHeight: 365)
            popupVC.canTapOutsideToDismiss = true
            
            //properties
            //            popupVC.backgroundAlpha = 1
            //            popupVC.backgroundColor = .black
            //            popupVC.canTapOutsideToDismiss = true
            //            popupVC.cornerRadius = 10
            //            popupVC.shadowEnabled = true
            
            // show it by call present(_ , animated:) method from a current UIViewController
            present(popupVC, animated: true)
            
            
            
        }
        
    }
    
}
