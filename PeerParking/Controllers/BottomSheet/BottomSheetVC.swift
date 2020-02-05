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
import Alamofire


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
    
    var parking_details:Parking!
    var distanceInMiles: String!
    
    var parkingId:Int?
    var buyerId:Int?
    var offerPrice:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
      
        
        setData()
    }
    
    
    
    func setData(){
        
        self.parking_titile.text = parking_details.address
        
        let seller = parking_details.seller
        let sellerDetail = seller?.details
        let rating  = sellerDetail?.averageRating
        trust_score.rating = Double(rating ?? 0)
        let priceStr = parking_details.initialPrice ?? 0.0
        if parking_details.imageURL == nil
        {
            photo.image = UIImage.init(named: "placeholder")
        }
        else
        {
        
            let imgUrl = parking_details.imageURL
            photo.sd_setImage(with: URL(string: imgUrl ?? ""),placeholderImage: UIImage.init(named: "placeholder-img") )
        }
        
        
        self.price.text = "$\(priceStr)"
        print("adfsdf=\(distanceInMiles)")
        self.distance.text = distanceInMiles
        
        if parking_details.note == nil
        {
            self.note.text = ""
        }
        else
        {
            self.note.text = parking_details.note
        }
        
      
        self.parking_type.text = parking_details.parkingTypeText
        
        self.viheicle_type.text = parking_details.vehicleTypeText
        
        
        if let time_limit = parking_details.parkingAllowedUntil{
            
            self.time_limit.text = "UNTIL \(time_limit)"
        }
        if let ext_fee = parking_details.parkingExtraFee{
            
            self.extra_charges.text = "\(ext_fee)"
        }
        
        
        
        
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
        
        
        let p_id = Int(self.parking_details.id as! Int)
        let final_price = Double(self.parking_details.initialPrice ?? 0.0)
        let myId = UserDefaults.standard.integer(forKey: "id")
            
        
        if Helper().IsUserLogin(){
            
            let params:[String:Any] = [
                "parking_id": p_id,
                "buyer_id": myId,
                "status": 10,
                "offer": final_price,
                "direction": 20
            ]
            print(params)
            self.postBargainingOffer(params: params)
            
            self.dismiss(animated: true, completion: nil)
            
            
//            assign_buyer(p_id: id, status: 20, final_price: final_price)
//            //SharedHelper().showToast(message: "Login", controller: self)
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingNavVC") as! ParkingNavVC
//            //
//            vc.parking_details = self.parking_details
//            vc.p_id = Int(self.parking_details["id"] as! Int)
//            vc.p_title = self.parking_titile.text ?? ""
//
//            vc.p_lat = Double(self.parking_details["latitude"] as! String)!
//            vc.p_longg = Double(self.parking_details["longitude"] as! String)!
//            vc.vcName = ""
//
//            self.present(vc, animated: false, completion: nil)
            
        }
        else{
            
            let vc = self.story.instantiateViewController(withIdentifier: "FBPopup") as? FBPopup
            
            vc?.parking_details = self.parking_details
            
            
            let popupVC = PopupViewController(contentController: vc!, popupWidth: 320, popupHeight: 365)
            popupVC.canTapOutsideToDismiss = true
            
            
            present(popupVC, animated: true)
            
        }

    }
    
    func postBargainingOffer(params:[String:Any]){
        
        APIClient.serverRequest(url: APIRouter.postBargainingOffer(params), dec: PostResponseData.self) { (response,error) in
                   
           if(response != nil){
               if let success = response?.success {
                   Helper().showToast(message: "Succes=\(success)", controller: self)
//                   if let val = response?.data {
//
//                   }
               }
               else{
                   Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
               }
           }
           else if(error != nil){
               Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
           }
           else{
               Helper().showToast(message: "Nor Response and Error!!", controller: self)
           }
           
        }
        
        
        
//        Alamofire.request(APIRouter.postBargainingOffer(params)).responsePost{ response in
//
//           switch response.result {
//           case .success:
//               if response.result.value?.success ?? false{
//
//                   print("val=\(response.result.value?.message ?? "-")")
//
//               }
//               else{
//                   print("Server Message=\(response.result.value?.message ?? "-" )")
//
//               }
//
//           case .failure(let error):
//               print("ERROR==\(error)")
//           }
//        }
        
    }
    
    
    @IBAction func counter_btn(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OfferBottomSheetVC") as! OfferBottomSheetVC
        vc.parkingDetails = self.parking_details
//        controller?.p_title = self.parking_titile.text!
        bottomSheet(controller: vc, sizes: [.fixed(540)],cornerRadius: 20, handleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
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
    
    
    func assign_buyer(p_id:Int,status:Int,final_price:Double){
        
       // let status:Int = 20
        
        var params:[String:Any] = [
            
            
            "status" : status,
            "final_price" : final_price
            
        ]
        
        //params.updateValue("hello", forKey: "new_val")
        let auth_value =  "Bearer \(UserDefaults.standard.string(forKey: "auth_token")!)"
        let headers: HTTPHeaders = [
            "Authorization" : auth_value
        ]
        print("==0params=\(params)")
        print("==0headers=\(headers)")
        
        //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customVC")
        //        self.present(vc, animated: true, completion: nil)
        
        
        let url = "\(APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.ASSIGN_BUYER)/\(p_id)"
        
        print("url--\(url)")
        
        
        Helper().Request_Api(url: url, methodType: .post, parameters: params, isHeaderIncluded: true, headers: headers){ response in
            
            print("response>>>\(response)")
            
            if response.result.value == nil {
                print("No response")
                
                SharedHelper().showToast(message: "Internal Server Error", controller: self)
                return
            }
            else {
                let responseData = response.result.value as! NSDictionary
                let status = responseData["success"] as! Bool
                if(status)
                {
                    let message = responseData["message"] as! String
                    //let uData = responseData["data"] as! NSDictionary
                    //let userData = uData["user"] as! NSDictionary
                    //self.saveData(userData: userData)
                    //                    SharedHelper().hideSpinner(view: self.view)
                    //                     UserDefaults.standard.set("yes", forKey: "login")
                    //                    UserDefaults.standard.synchronize()
                    SharedHelper().showToast(message: message, controller: self)
                    
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackVC
                    vc.parking_details = self.parking_details
                    vc.p_id = p_id
                    self.present(vc, animated: true, completion: nil)
                    //self.after_signin()
                }
                else
                {
                    let message = responseData["message"] as! String
                    SharedHelper().showToast(message: message, controller: self)
                    //   SharedHelper().hideSpinner(view: self.view)
                }
            }
        }
    }
  
}
