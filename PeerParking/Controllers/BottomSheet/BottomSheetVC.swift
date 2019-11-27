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
import Cosmos
import SDWebImage


class BottomSheetVC: UIViewController {

    @IBOutlet weak var offer_btn: UIButton!
    @IBOutlet weak var counter_btn: UIButton!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var parking_titile: UILabel!
    @IBOutlet weak var trust_score: CosmosView!
    
    @IBOutlet weak var viheicle_type: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var time_limit: UILabel!
    @IBOutlet weak var parking_type: UILabel!
    @IBOutlet weak var extra_charges: UILabel!
    
    @IBOutlet weak var note: UILabel!
    
    
    
    
    let story = UIStoryboard(name: "Main", bundle: nil)
    
    var parking_details:NSDictionary!
    var distanceInMiles: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print("parking_details=\(parking_details!)")
      
      
        setData()
    }
    
    
    
    func setData(){
        
        self.parking_titile.text = parking_details["address"] as? String
        
        let dicInner = parking_details["seller"] as! NSDictionary
        let dicInnerDetail = dicInner["details"] as! NSDictionary
        let rating  = dicInnerDetail["average_rating"] as? Double
        trust_score.rating = Double(rating ?? 0)
        let priceStr = parking_details["initial_price"] as! Double
        if parking_details["image_url"] is NSNull
        {
            photo.image = UIImage.init(named: "placeholder")
        }
        else
        {
        
            let imgUrl = parking_details["image_url"] as! String
            photo.sd_setImage(with: URL(string: imgUrl),placeholderImage: UIImage.init(named: "placeholder-img") )
        }
        
        
        self.price.text = "$" + String(priceStr)
        self.distance.text = String(format: "%.02f miles away", self.distanceInMiles)
        
        if parking_details["note"] is NSNull
        {
            self.note.text = ""
        }
        else
        {
            
            self.note.text = parking_details["note"] as? String
        }
        
      
        self.parking_type.text = parking_details["parking_type_text"] as? String
        self.time_limit.text = parking_details["parking_allowed_until"] as? String
        
        
//        {
//            "id": 16,
//            "seller_id": 4,
//            "buyer_id": null,
//            "vehicle_type": 10,
//            "parking_type": 10,
//            "status": 10,
//            "initial_price": 1,
//            "final_price": 0,
//            "is_negotiable": false,
//            "start_at": "2019-11-14 18:11:17",
//            "end_at": null,
//            "address": "A-486 Allama Shabbir Ahmed Usmani Rd, Block 3 Gulshan-e-Iqbal, Karachi, Karachi City, Sindh, Pakistan",
//            "latitude": "24.9280107",
//            "longitude": "67.0957389",
//            "image": "parking/7t6snDg40LBMjVTwitnynWt65lp1PPlyRqUbpNJV.jpeg",
//            "note": null,
//            "parking_hours_limit": 0,
//            "parking_allowed_until": null,
//            "parking_extra_fee": 0,
//            "parking_extra_fee_unit": 0,
//            "is_resident_free": false,
//            "created_at": "2019-11-14 13:14:27",
//            "updated_at": "2019-11-14 13:14:27",
//            "deleted_at": null,
//            "action": 20,
//            "extra_fee_unit_text": null,
//            "vehicle_type_text": "Super Mini",
//            "image_url": "http://peer-parking.servstaging.com/api/resize/parking/7t6snDg40LBMjVTwitnynWt65lp1PPlyRqUbpNJV.jpeg",
//            "seller": {
//                "id": 4,
//                "name": "Mc Fly",
//                "email": "idfordeveloper@gmail.com",
//                "created_at": "2019-11-14 13:14:21",
//                "details": {
//                    "id": 4,
//                    "first_name": "Mc Fly",
//                    "last_name": null,
//                    "average_rating": 0,
//                    "phone": null,
//                    "address": null,
//                    "image": "https://graph.facebook.com/203966683952886/picture?width=200&height=200",
//                    "balance": 0,
//                    "is_verified": 1,
//                    "email_updates": 1,
//                    "is_social_login": 1,
//                    "image_url": "http://peer-parking.servstaging.com/api/resize/https://graph.facebook.com/203966683952886/picture?width=200&height=200",
//                    "full_name": "Mc Fly "
//                }
//            },
//            "buyer": null
//        }
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.accept_offer_tap(notification:)), name: NSNotification.Name(rawValue: "accept_offer"), object: nil)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func accept_offer_tap(notification: NSNotification) {
        
       // self.offer_btn.setTitle("Go", for: .normal)
        
    }
    
    @IBAction func take_btn_click(_ sender: UIButton) {
        
        
        
        if Helper().IsUserLogin(){
            
            //SharedHelper().showToast(message: "Login", controller: self)
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingNavVC") as! ParkingNavVC
            //
            vc.p_id = Int(self.parking_details["id"] as! Int)
            vc.p_title = self.parking_titile.text ?? ""
            
            vc.p_lat = Double(self.parking_details["latitude"] as! String)!
            vc.p_longg = Double(self.parking_details["longitude"] as! String)!
            vc.vcName = ""
            
            
//            self.navigationController?.pushViewController(vc, animated: true)
//            self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: false, completion: nil)
            
        }
        else{
            
            let vc = self.story.instantiateViewController(withIdentifier: "FBPopup")
            
            
            let popupVC = PopupViewController(contentController: vc, popupWidth: 320, popupHeight: 365)
            popupVC.canTapOutsideToDismiss = true
            
            
            present(popupVC, animated: true)
            
        }
//
//        if(offer_btn.titleLabel?.text == "Go"){
//
//
//
//
//        }
//        else{
//
//            bottomSheet(storyBoard: "Main", identifier: "OfferBottomSheetVC", sizes: [.fixed(350)], cornerRadius: 10)
//        }
    }
    
    
    @IBAction func counter_btn(_ sender: UIButton) {
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OfferBottomSheetVC") as? OfferBottomSheetVC
        controller?.p_title = self.parking_titile.text!
        bottomSheet(controller: controller!, sizes: [.fixed(360)],cornerRadius: 20, handleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
    }
    
    func bottomSheet(controller : UIViewController,sizes:[SheetSize], cornerRadius:CGFloat, handleColor:UIColor){
        
        
        //  let controller = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier: identifier) as!  UIViewController
        
        
        
        let sheetController = SheetViewController(controller: controller, sizes: sizes)
        //        // Turn off Handle
        sheetController.handleColor = handleColor
        // Turn off rounded corners
        sheetController.topCornersRadius = cornerRadius
        
        self.present(sheetController, animated: false, completion: nil)
    }
    
  
}
