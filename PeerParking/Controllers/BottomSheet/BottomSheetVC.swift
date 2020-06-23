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
    @IBOutlet weak var trust_score_txt: UILabel!
    @IBOutlet weak var trust_score: CosmosView!
    @IBOutlet weak var viheicle_type: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var time_limit: UILabel!
    @IBOutlet weak var parking_type: UILabel!
    @IBOutlet weak var extra_charges: UILabel!
    
    @IBOutlet weak var note: UILabel!
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var st_time: UILabel!
    @IBOutlet weak var end_time: UILabel!
    
    
    let story = UIStoryboard(name: "Main", bundle: nil)
    
    //Intent Variables
    var parking_details:Parking!
    var lat:Double!
    var longg:Double!
    //    var distanceInMiles: String!
    
    var parkingId:Int?
    var buyerId:Int?
    var offerPrice:Double?
    
    var sTime : String?
    var fTime : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
    }
    override func viewWillLayoutSubviews() {
        self.note.sizeToFit()
    }
    
    
    
    func setData(){
        
        
        //        self.note.numberOfLines = 0
        //        [self.note sizeToFit]
        
        
        //        self.note.sizeToFit()
        if(parking_details.parkingType == 10){
            
            timeView.isHidden = true
        }
        else{
            self.st_time.text = "From: "
            self.end_time.text = "To: "
            timeView.isHidden = false
        }
        
        if(parking_details.isNegotiable ?? false){
            
            counter_btn.isHidden = false
        }
        else{
            counter_btn.isHidden = false
        }
        self.parking_titile.text = parking_details.address
        
        let seller = parking_details.seller
        let sellerDetail = seller?.details
        let rating  = sellerDetail?.averageRating
        trust_score.rating = rating ?? 0
        trust_score_txt.text = String(rating ?? 0)
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
        
        self.distance.text = String(format: "%.03f miles from destination", parking_details.distance ?? 0.0)
        
        let d_lat = Double(parking_details?.latitude ?? "") ?? 0.0
        let d_long = Double(parking_details?.longitude ?? "") ?? 0.0
        
        Helper().getTimeDurationBetweenCordinate(s_lat: self.lat, s_longg: self.longg, d_lat: d_lat, d_longg: d_long)
        { (duration) in
            
            self.duration.text = "\(duration)"
        }
        
        if parking_details.note == nil
        {
            self.note.text = ""
        }
        else
        {
            self.note.text = parking_details.note
        }
        
        
        self.parking_type.text = parking_details.parkingSubTypeText == "Drive" ? "Driveway" : parking_details.parkingSubTypeText
        
        self.viheicle_type.text = parking_details.vehicleTypeText
        
        
        if let time_limit = parking_details.parkingAllowedUntil{
            
            self.time_limit.text = "UNTIL \(time_limit)"
        }
        if let ext_fee = parking_details.parkingExtraFee{
            
            self.extra_charges.text = "\(ext_fee)"
        }
        
        
        // checking either already a temp parking or not if parking is private parking
        
        print("already temp parking ? \(checkIsAlreadyTempParking())")
        
        
        
        if(checkIsAlreadyTempParking()){
            
            getTempParking(isChatOpen: false,id: self.parking_details.tempParkingID ?? -1)
            
        }
        
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.note.sizeToFit()
        NotificationCenter.default.addObserver(self, selector: #selector(self.accept_offer_tap(notification:)), name: NSNotification.Name(rawValue: "accept_offer"), object: nil)
        
        
    }
    
    
    func checkIsAlreadyTempParking()->Bool{
        
        return self.parking_details.tempParkingID == 0 ? false : true
        
        
    }
    
    func getTempParking(isChatOpen : Bool , id : Int){
        
        
        
        
        getTempParkingServer(id: id) { (pModel) in
            
           
            
            if (pModel != nil)
            {
                
                self.sTime = pModel.startAt ?? ""
                self.fTime = pModel.endAt ?? ""
                
                
                self.st_time.text = "From : \( Helper().getFormatedDateAndTime(dateStr: self.sTime!))"
                self.end_time.text = "To : \(Helper().getFormatedDateAndTime(dateStr: self.fTime!))"
                
                if(isChatOpen)
                {
                    
                    
                    
                    
                    self.openChatScreen(model: pModel)
                    
                }
                    
                else
                {
                   
                    self.parking_details.initialPrice = pModel.initialPrice ?? 0.0
                }
                
            }
           
        }
        
        
        
    }
    
    
    
    func createTempParking(isTakeOffer : Bool)
    {
        
        var model1 : Parking = cloneParking(parkingModel: self.parking_details)
        
        var seller : Seller = model1.seller!
        
        
        model1.seller = nil
        
    }
    
    func cloneParking(parkingModel : Parking) -> Parking
    {
        
        
        let parking : Parking = parkingModel
        
        return parking
        
    }
    
    func openChatScreen(model : Parking){
        
        
        let vc = ChatVC.instantiate(fromPeerParkingStoryboard: .Chat)
               
               vc.modalPresentationStyle = .fullScreen
               
               vc.parking_details = model
               
               self.present(vc, animated: true, completion: nil)
    }
    
    func getTempParkingServer(id : Int   , completion: @escaping (Parking) -> Void){
        
        
         Helper().showSpinner(view: self.view)
        APIClient.serverRequest(url: APIRouter.getParkingsById(id: id), path: APIRouter.getParkingsById(id: id).getPath(), dec:
            ResponseData<Parking>.self) { (response,error) in
                
            if(response != nil){
                if (response?.success) != nil {
                    //Helper().showToast(message: "Succes=\(success)", controller: self)
                    if let val = response?.data {
                        
                        
                        //                        print(val)
                        
                        Helper().hideSpinner(view: self.view)
                        completion((response?.data ?? nil)! )
                    }
                     Helper().hideSpinner(view: self.view)
                }
              
                    
                else{
                    Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                    
                      Helper().hideSpinner(view: self.view)
                    completion((response?.data ?? nil)! )
                }
            }
            else if(error != nil){
                Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
                  Helper().hideSpinner(view: self.view)
                completion((response?.data ?? nil)! )
            }
            else{
                Helper().showToast(message: "Nor Response and Error!!", controller: self)
                  Helper().hideSpinner(view: self.view)
//                completion((response?.data ?? nil) ?? )
            }
            
        }
        
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func accept_offer_tap(notification: NSNotification) {
        
        // self.offer_btn.setTitle("Go", for: .normal)
        
    }
    
    @IBAction func take_btn_click(_ sender: UIButton) {
        
        
        
        if(self.sTime == nil || self.fTime == nil)
        {
            
            
            Helper().showToast(message: "Please select time", controller: self)
            return
            
            
        }
        
        let p_id = self.parking_details.id ?? 0
        let final_price = Double(self.parking_details.initialPrice ?? 0.0)
        let myId = UserDefaults.standard.integer(forKey: "id")
        
        
        if Helper().IsUserLogin(){
            
            let params:[String:Any] = [
                "parking_id": p_id,
                "buyer_id": myId,
                "status": ParkingConst.STATUS_ACCEPTED,
                "offer": final_price,
                "direction": ParkingConst.BUYER_TO_SELLER
            ]
            print(params)
            self.postBargainingOffer(params: params)
            
            //            self.dismiss(animated: true, completion: nil)
            
            
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
        
        APIClient.serverRequest(url: APIRouter.postBargainingOffer(params), path: APIRouter.postBargainingOffer(params).getPath(), dec: PostResponseData.self) { (response,error) in
            
            if(response != nil){
                if let success = response?.success {
                    
                    //                let status = responseData["success"] as! Bool
                    
                    
                    let message = response?.message
                    Helper().showToast(message: message!, controller: self)
                    
                    Helper().popScreen(controller:self)
                    
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
        
        
        
    }
    
    @IBAction func selectTimeBtn(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SliderTimerVC") as! SliderTimerVC
        
        //        self.navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .fullScreen
        vc.parking_details = parking_details
        vc.delegate = self
        self.present(vc, animated: true,completion: nil)
        
    }
    
    @IBAction func counter_btn(_ sender: UIButton) {
        
        
        

        
        if(self.parking_details.parkingType == 10){
            
            openChatScreen(model: self.parking_details)
            
        }
        else
        {
            if(checkIsAlreadyTempParking()){
                getTempParking(isChatOpen: true , id: self.parking_details.tempParkingID ?? -1)
            }
            else
            {
                createTempParking(isTakeOffer: false)
            }
        }
        
        
        
        
        
        
        
        self.getTempParking(isChatOpen: true,id: self.parking_details.tempParkingID ?? -1)
        
        //        self.navigationController!.pushViewController(vc, animated: true)
        
        
        //        controller?.p_title = self.parking_titile.text!
        
        
        
        //        bottomSheet(controller: vc, sizes: [.fixed(540)],cornerRadius: 20, handleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
        
        
    }
    
    @IBAction func mapViewBtn(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewVC") as! MapViewVC
        var arr = [Parking]()
        arr.append(self.parking_details)
        vc.parkingDetails = arr
        //        controller?.p_title = self.parking_titile.text!
        self.present(vc, animated: true, completion: nil)
        
        
        
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
        
        let params:[String:Any] = [
            
            
            "status" : status,
            "final_price" : final_price
            
        ]
        
        //params.updateValue("hello", forKey: "new_val")
        let auth_value =  "Bearer \(UserDefaults.standard.string(forKey: APP_CONSTANT.ACCESSTOKEN)!)"
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

extension BottomSheetVC:OnTimeSelectDelegate{
    
    func timeSelect(startigTime: String, endingTime: String){
        //
        //        var times : [String] = []
        //        times[0] = startigTime
        //        times[1] = endingTime
        //
        //        return times
        
        sTime = startigTime
        fTime = endingTime
        
        
        st_time.text = "From : \(startigTime)"
        end_time.text = "To : \(endingTime)"
        
    }
    
    
    
}
