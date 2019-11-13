//
//  BottomSheetVC.swift
//  PeerParking
//
//  Created by Apple on 16/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import FittedSheets
import EzPopup
import FacebookLogin
import FacebookCore
import HelperClassPod


class BottomSheetVC: UIViewController {

    @IBOutlet weak var offer_btn: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    let story = UIStoryboard(name: "Main", bundle: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.accept_offer_tap(notification:)), name: NSNotification.Name(rawValue: "accept_offer"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func accept_offer_tap(notification: NSNotification) {
        
        self.offer_btn.setTitle("Go", for: .normal)
        
    }
    
    @IBAction func take_btn_click(_ sender: UIButton) {
        
        if(offer_btn.titleLabel?.text == "Go"){
            
            
            if Helper().IsUserLogin(){
                
            //SharedHelper().showToast(message: "Login", controller: self)
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingNavVCNav")
                //
                self.present(vc, animated: false, completion: nil)
               
            }
            else{
                
                let vc = self.story.instantiateViewController(withIdentifier: "FBPopup")
                
                
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
        else{
            
            bottomSheet(storyBoard: "Main", identifier: "OfferBottomSheetVC", sizes: [.fixed(350)], cornerRadius: 10)
        }
    }
    
    func bottomSheet(storyBoard:String,identifier:String,sizes:[SheetSize], cornerRadius:CGFloat){
        
        let controller = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        
        
        
        let sheetController = SheetViewController(controller: controller, sizes: sizes)
        //        // Turn off Handle
        sheetController.handleColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        // Turn off rounded corners
        sheetController.topCornersRadius = cornerRadius
        
        self.present(sheetController, animated: false, completion: nil)
    }
    
    
  
}
