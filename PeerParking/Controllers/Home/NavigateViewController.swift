//
//  NavigateViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 13/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class NavigateViewController: UIViewController {

    var strVC : String!
    var isMax = true
    @IBOutlet weak var routeHeight: NSLayoutConstraint!
    @IBOutlet weak var viewRoute: CardView!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnnavigateHeight: NSLayoutConstraint!
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var btnParked: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController?.navigationBar.isHidden = false
        btnCancel.addShadowView(color: UIColor.lightGray)
        btnParked.addShadowView(color: UIColor.lightGray)
        //routeHeight.constant = 50
        
        
        isMax = false
        routeHeight.constant = 120
        btnHeight.constant = 0
        btnnavigateHeight.constant = 0
        buttonView.isHidden = true
        
//        if(strVC.elementsEqual("navigate"))
//        {
//            buttonView.isHidden = true
//            btnHeight.constant = 0
//            routeHeight.constant = 190
//            
//        }
//        else
//        {
//             buttonView.isHidden = false
//            btnHeight.constant = 87
//            routeHeight.constant = 250
//        }
//        viewRoute.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnParked(_ sender: Any) {
        //open park screen
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "rateVC") as! RateViewController
        //
        self.navigationController?.pushViewController(vc, animated: true)
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "parkedVC") as! ParkedViewController
//        //
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnCancel(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "customVC") as! CustomSideMenuController
        //
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBack(_ sender: Any) {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "customVC") as! CustomSideMenuController
        //
         self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAlternate(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "alternateRouteVC") as! AlternateRouteVC
        //
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnMaximize(_ sender: Any) {
        if(isMax)
        {
            isMax = false
            routeHeight.constant = 120
            btnHeight.constant = 0
            btnnavigateHeight.constant = 0
            buttonView.isHidden = true
        }
        else
        {
            btnnavigateHeight.constant = 50
            btnHeight.constant = 87
            isMax = true
            if(strVC.elementsEqual("navigate"))
            {
                 buttonView.isHidden = true
                btnHeight.constant = 0
                routeHeight.constant = 190
            }
            else
            {
                 buttonView.isHidden = false
                btnHeight.constant = 87
                 routeHeight.constant = 250
            }
        }
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
