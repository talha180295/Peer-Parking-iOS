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
import Firebase
import CodableFirebase




class BottomSheetVC: UIViewController {
    
    @IBOutlet weak var extrachargesView: UIView!
    @IBOutlet weak var timelimitView: UIView!
    @IBOutlet weak var endTimeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var offer_btn: UIButton!
    @IBOutlet weak var counter_btn: UIButton!
    @IBOutlet weak var btnSelectTime: UIButton!
    
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
    
    var offerPrice:Double?
    
    var sTime : String?
    var fTime : String?
    
    var tempParkingId = 0
    var initialPrice = 0.0
    
    
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
        
        
        if(self.parking_details.parkingType == ParkingType.PARKING_TYPE_PRIVATE)
        {
//            self.timeView.isHidden = false
              self.extra_charges.isHidden = true
          
        }
        else
        {
            
//            self.sTime = parking_details.startAt ?? ""
//                 //            self.fTime = pModel.endAt ?? ""
//
//
//                             self.st_time.text = "From : \( Helper().getFormatedDateAndTime(dateStr: self.sTime!))"
                 
            
            if(self.parking_details.parkingHoursLimit == nil || self.parking_details.parkingHoursLimit!.isEmpty ){
                
                
//                self.timeView.isHidden = true
                
            }else{
                
                
                 self.time_limit.isHidden = false
                 self.time_limit.text = "\(self.parking_details.parkingHoursLimit ?? "")"
                self.timelimitView.isHidden = false
//                self.timeView.isHidden = false
                
                
            }
            if(self.parking_details.parkingExtraFee == nil || self.parking_details.parkingExtraFee!.isEmpty ){
                
                
                 self.extra_charges.isHidden = true
                
            }else{
                
                self.extra_charges.isHidden = false
                self.extrachargesView.isHidden = false
                self.extra_charges.text = self.parking_details.parkingExtraFee
                
              
            }
        }
        
        
    
        parking_type.text = parking_details.parkingSubTypeText == "Drive" ? "Driveway" : parking_details.parkingSubTypeText
        
        
        
        
//               parkingsize.setText(parkingModel1.getVehicleTypeText());
              
        self.note.text = parking_details.note
        self.parking_titile.text = parking_details.address
               
        if parking_details.imageURL == nil
                {
                    photo.image = UIImage.init(named: "placeholder")
                }
                else
                {
        
                    let imgUrl = parking_details.imageURL
                    photo.sd_setImage(with: URL(string: imgUrl ?? ""),placeholderImage: UIImage.init(named: "placeholder-img") )
                }
        
        
        if(self.parking_details.parkingType == ParkingType.PARKING_TYPE_PRIVATE){
            
            
            self.price.text = "$ \(parking_details.initialPrice ?? 0.0) / hr"
        }
        else
        {
            self.price.text = "$ \(parking_details.initialPrice ?? 0.0) "
        }
        
        if(self.parking_details.seller != nil && self.parking_details.seller?.details != nil)
        {
            self.trust_score_txt.text = String(format: "%0.1f", self.parking_details.seller?.details?.averageRating ??  0.0 )
            self.trust_score.rating = self.parking_details.seller?.details?.averageRating ??  0.0
            
        }
        
         self.distance.text = String(format: "%.03f miles from destination", parking_details.distance ?? 0.0)
        
                let d_lat = Double(parking_details?.latitude ?? "") ?? 0.0
                let d_long = Double(parking_details?.longitude ?? "") ?? 0.0
        
                Helper().getTimeDurationBetweenCordinate(s_lat: self.lat, s_longg: self.longg, d_lat: d_lat, d_longg: d_long)
                { (duration) in
        
                    self.duration.text = "\(duration)"
                }
        
        
         self.viheicle_type.text = parking_details.vehicleTypeText
        
 
//               if (parkingModel1.getSellerMdoel() != null && parkingModel1.getSellerMdoel().getDetails()!=null) {
//                   scoretext.setText(String.valueOf(String.valueOf(parkingModel1.getSellerMdoel().getDetails().getAvgRating())));
//                   ratingbar.setRating((float) parkingModel1.getSellerMdoel().getDetails().getAvgRating());
//               }

        
        
//        //        self.note.sizeToFit()
//        if(parking_details.parkingType == 10){
//
//            timeView.isHidden = true
//        }
//        else{
//            self.st_time.text = "From: "
//            self.end_time.text = "To: "
//            timeView.isHidden = false
//        }
//
//        if(parking_details.isNegotiable ?? false){
//
//            counter_btn.isHidden = false
//        }
//        else{
//            counter_btn.isHidden = false
//        }
//        self.parking_titile.text = parking_details.address
//
//        let seller = parking_details.seller
//        let sellerDetail = seller?.details
//        let rating  = sellerDetail?.averageRating
//        trust_score.rating = rating ?? 0
//        trust_score_txt.text = String(rating ?? 0)
//        let priceStr = parking_details.initialPrice ?? 0.0
//        if parking_details.imageURL == nil
//        {
//            photo.image = UIImage.init(named: "placeholder")
//        }
//        else
//        {
//
//            let imgUrl = parking_details.imageURL
//            photo.sd_setImage(with: URL(string: imgUrl ?? ""),placeholderImage: UIImage.init(named: "placeholder-img") )
//        }
//
//
//        self.price.text = "$\(priceStr)"
//
//        self.distance.text = String(format: "%.03f miles from destination", parking_details.distance ?? 0.0)
//
//        let d_lat = Double(parking_details?.latitude ?? "") ?? 0.0
//        let d_long = Double(parking_details?.longitude ?? "") ?? 0.0
//
//        Helper().getTimeDurationBetweenCordinate(s_lat: self.lat, s_longg: self.longg, d_lat: d_lat, d_longg: d_long)
//        { (duration) in
//
//            self.duration.text = "\(duration)"
//        }
//
//        if parking_details.note == nil
//        {
//            self.note.text = ""
//        }
//        else
//        {
//            self.note.text = parking_details.note
//        }
//
//
//        self.parking_type.text = parking_details.parkingSubTypeText == "Drive" ? "Driveway" : parking_details.parkingSubTypeText
//
//        self.viheicle_type.text = parking_details.vehicleTypeText
//
//
//        if let time_limit = parking_details.parkingAllowedUntil{
//
//            self.time_limit.text = "UNTIL \(time_limit)"
//        }
//        if let ext_fee = parking_details.parkingExtraFee{
//
//            self.extra_charges.text = "\(ext_fee)"
//        }
//
//
//        // checking either already a temp parking or not if parking is private parking
//
//        print("already temp parking ? \(checkIsAlreadyTempParking())")
//
//
//
//        if(checkIsAlreadyTempParking()){
//
//            getTempParking(isChatOpen: false,id: self.parking_details.tempParkingID ?? -1)
//
//        }
        
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
            self.tempParkingId = parking_details.tempParkingID ?? 0
                
                if (self.initialPrice == 0) {
                    self.initialPrice  = parking_details.initialPrice ?? 0.0
                }
                
        //        if (Helper().getCurrentUserId() == nil) {
        //            HomeActivity homeActivity = (HomeActivity) activity;
        //            if (homeActivity.parkingSearchedBeforeLogin == null) {
        //                homeActivity.parkingSearchedBeforeLogin = new ParkingSearchedBeforeLogin();
        //            }
        //            ((HomeActivity) activity).parkingSearchedBeforeLogin.parkingModel1 = parkingModel1;
        //        }
                
                
                
                if (parking_details.parkingType == ParkingType.PARKING_TYPE_PRIVATE) {
                    btnSelectTime.isHidden = false
                } else {
                   btnSelectTime.isHidden = true
                }
                if(parking_details.parkingType==ParkingType.PARKING_TYPE_PUBLIC){
                    
                    
                    self.endTimeHeightConstraint.constant = 0.0
                    
                    self.sTime = parking_details.startAt ?? ""
        //            self.fTime = pModel.endAt ?? ""
                    
                    
                    self.st_time.text = "\( Helper().getFormatedDateAndTime(dateStr: self.sTime!))"
        //            self.end_time.text = "To : \(Helper().getFormatedDateAndTime(dateStr: self.fTime!))"
                    
                   
                
                    
                }
                else if(self.tempParkingId != 0 ){
                
                    self.getTempParking(showBargainingDialog: false);
                
                }
                
        
        
        self.note.sizeToFit()
        NotificationCenter.default.addObserver(self, selector: #selector(self.accept_offer_tap(notification:)), name: NSNotification.Name(rawValue: "accept_offer"), object: nil)
        
        
    }
    
    
    func checkIsAlreadyTempParking()->Bool{
        
        return self.parking_details.tempParkingID == 0 ? false : true
        
        
    }
    
    public func takeOffer() {

        if Helper().IsUserLogin() {
            
            Helper().showSpinner(view: self.view)
            
            let url = APIRouter.me
            let decoder = ResponseData<Me>.self
            
            APIClient.serverRequest(url: url, path: url.getPath(), dec: decoder) { (response,error) in
                
                Helper().hideSpinner(view: self.view)
                if(response != nil){
                    if let _  = response?.success {
                        
                        //                    Helper().showToast(message: "Success=\(success)", controller: self)
                        if let val = response?.data {
                            
                            if(val.details?.wallet ?? 0.0 <= 0.0){
                                
                            Helper().showToast(message: "Insufficient Amount in wallet", controller: self)
                                
                            self.offer_btn.isUserInteractionEnabled = true
                                
                            }
                            else{
                                self.postTakeOfferApi();
                            }
                            
                        }
                    }
                    else{
                        Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                    }
                }
                else if(error != nil){
                    Helper().showToast(message: "\(error?.localizedDescription ?? "" )", controller: self)
                }
                else{
                    Helper().showToast(message: "Nor Response and Error!!", controller: self)
                }
                
            }
//            getBaseWebServices(true).postAPIAnyObject(WebServiceConstants.PATH_ME, "", new WebServices.IRequestWebResponseAnyObjectCallBack() {
//                @Override
//                public void requestDataResponse(WebResponse<Object> webResponse) {
//
//                    UserModel userModel = new Gson().fromJson(new Gson().toJson(webResponse.result), UserModel.class);
//
//                    if(userModel.getUserDetails().getWallet()<=0){
//                        Toast.makeText(activity, "Insufficient Amount in wallet", Toast.LENGTH_LONG).show();
//                        buttontakeoffer1.setClickable(true);
//                    }else{
//                        postTakeOfferApi();
//                    }
//                }
//
//                @Override
//                public void onError(Object object) {
//                    buttontakeoffer1.setClickable(true);
//                }
//            });

        } else {
            showLoginDialog();
        }

    }
    
    private func postTakeOfferApi() {
        if (parking_details.parkingType == ParkingType.PARKING_TYPE_PUBLIC) {
            takeOffer(parkingId: parking_details.id ?? 0, initialPrice: parking_details.initialPrice ?? 0.0);
        }
        else {
            if (parking_details.tempParkingID == 0) {
                createTempParking(isTakeOffer: true);
            } else {
                takeOffer(parkingId: parking_details.tempParkingID ?? 0, initialPrice: parking_details.initialPrice ?? 0.0);
            }

        }
    }
    
    func takeOffer(parkingId :Int , initialPrice : Double)
    {
        
       
        let buyerId = Helper().getCurrentUserId()
        let refId = String(parkingId) + "-" + String(buyerId)
        
       
        
        let firebaseChatReference =  Database.database().reference(withPath: "chat/").child(String(parkingId)).child(String(buyerId))
        
        // this is from because we need currenst user model and because of this me api is calling
        
        let url = APIRouter.me
               let decoder = ResponseData<Me>.self
               
               APIClient.serverRequest(url: url, path: url.getPath(), dec: decoder) { (response,error) in
                   
                   Helper().hideSpinner(view: self.view)
                   if(response != nil){
                       if let _  = response?.success {
                           
                           //                    Helper().showToast(message: "Success=\(success)", controller: self)
                           if let val = response?.data {
                               
                            var parkingModel = Parking.init(dictionary: self.parking_details.dictionary ?? [:])
                               
                               parkingModel?.buyerID = val.id
                               let  buyerMdoel = Buyer(id: val.id, name: val.name, email: val.email, createdAt: val.createdAt, details: val.details, card: [nil])
                               
                               parkingModel?.buyer = buyerMdoel
                               
                                let buyer_dict = try! FirebaseEncoder().encode(parkingModel?.buyer)
                               Database.database().reference(withPath:"buyerModel/").child(String(buyerId)).setValue(buyer_dict)
                               
                              
                               firebaseChatReference.observeSingleEvent(of: .value) { (snapshot) in
                                       
                                       var isOfferTakenAlready : Bool = false
                                       
                                       let enumerator = snapshot.children
                                       
                                       
                                       
                                       while let childSnapShot = enumerator.nextObject() as? DataSnapshot {
                                           
                                           guard let value = childSnapShot.value else { return }
                                           do {
                                               let model = try FirebaseDecoder().decode(ChatModel.self, from: value)
                                               
                                               if(model.messageType == APP_CONSTANT.MESSAGE_TYPE_OFFER) && (model.direction == APP_CONSTANT.DIRECTION.BUYER_TO_SELLER){
                                                   isOfferTakenAlready = true;
                                               }
                                              
                                               
                                               
                                           } catch let error {
                                               print(error)
                                           }
                                       }
                                       
                                       if(!isOfferTakenAlready){
                                           
                                           let  messageKey : String = firebaseChatReference.childByAutoId().key!
                                           
                                           let chat = ChatModel()
                                           chat.id = messageKey
                                           chat.direction = APP_CONSTANT.DIRECTION.BUYER_TO_SELLER
                                           chat.createdAt = self.makingCurrentDateModel()
                                           chat.offer = initialPrice
                                           chat.offerStatus = APP_CONSTANT.STATUS_COUNTER_OFFER
                                           chat.messageType = APP_CONSTANT.MESSAGE_TYPE_OFFER
                                           
                                           
                                           let chat_dict = try! FirebaseEncoder().encode(chat)
                                           
                                           firebaseChatReference.child(messageKey).setValue(chat_dict , withCompletionBlock: { (error, ref) -> Void in
                                                                           
                                               if let error = error {
                                                   print(error.localizedDescription)
                                               }
                                               else
                                               {
                                                   
                                                   
                                                   let actionType = APP_CONSTANT.ACTION_PARKING_REQUEST
                                                   self.sendNotification(actionType: actionType,message: "You have a parking request.",refId: refId);
                                                   
                                                   let parkingRequestsModel : FirebaseRequestModel = FirebaseRequestModel()
                                                   
                                                   parkingRequestsModel.parkingID = parkingId
                                                   parkingRequestsModel.sellerID = self.parking_details.sellerID
                                                   parkingRequestsModel.buyerID = buyerId
                                                   parkingRequestsModel.lastMessage = chat
                                                   parkingRequestsModel.parkingLocation = self.parking_details.address
                                                   
                                                   parkingRequestsModel.parkingTitle = self.parking_details.title
                                                   parkingRequestsModel.parkingStatus = APP_CONSTANT.STATUS_PARKING_AVAILABLE
                                                   
                                                   
                                                    let request_dict = try! FirebaseEncoder().encode(parkingRequestsModel)
                                                   
                                                   _ =  Database.database().reference(withPath: "requests/").child(refId).setValue(request_dict)
                                                   
                                                   Database.database().reference(withPath: "sellerRequestsIndex/").child(String(self.parking_details.sellerID!)).child(refId).setValue(chat.createdAt?.time)
                                                   
                                                   Database.database().reference(withPath: "buyerRequestsIndex/").child(String(buyerId)).child(refId).setValue(chat.createdAt?.time)
                                                   
                                                   Helper().showToast(message: "Offer Sent to Seller", controller: self)
                                                   
                                                   self.dismiss(animated: true, completion: nil)
                                            
                                               }
                                               
                                               
                                           })
                               
                                           
                                           
                                           
                                           
                                       }
                                       else
                                       {
                                           Helper().showToast(message: "Offer Sent already", controller: self)
                                           self.offer_btn.isUserInteractionEnabled = true
                                               
                                          
                                       }
                                       
                                       
                                   }
                              
                                  
                               
                              
                               
                              
                               
                               
                               
                           }
                       }
                       else{
                           Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                       }
                   }
                   else if(error != nil){
                       Helper().showToast(message: "\(error?.localizedDescription ?? "" )", controller: self)
                   }
                   else{
                       Helper().showToast(message: "Nor Response and Error!!", controller: self)
                   }
                   
               }
               
        
        
        
        
    }
    
    private func sendNotification(actionType : String , message : String , refId : String) {
        
        var model:NotificationSendingModel = NotificationSendingModel()
        model.refId = refId
        model.recieverId = Int(self.parking_details.sellerID ?? -1)
        model.actionType = actionType
        model.message = message
        
        do{
            let data = try JSONEncoder().encode(model)
            Helper.customSendNotification(data: data, controller: self)
        }
        catch let parsingError {
            
            print("Parsing Error", parsingError)
            
        }
    }
    
    func makingCurrentDateModel() -> CreatedAt {
           
           
           
           let userCalendar = Calendar.current
           let date = Date()
        _ = userCalendar.dateComponents([.day, .month, .year, .calendar], from: Date())
           let createdAt : CreatedAt = CreatedAt()
           createdAt.date = userCalendar.component(.day, from: date)
           createdAt.day = userCalendar.component(.weekday, from: date)
           createdAt.hours = userCalendar.component(.hour, from: date)
           createdAt.minutes = userCalendar.component(.minute, from: date)
           createdAt.month = userCalendar.component(.month, from: date)
           createdAt.seconds = userCalendar.component(.second, from: date)
           createdAt.timezoneOffset = -300
           createdAt.time =  Int(truncatingIfNeeded: date.millisecondsSince1970)
           createdAt.year = userCalendar.component(.year, from: date)
           //        date : userCalendar.component(.day, from: date),
           //                   day : userCalendar.component(.weekday, from: date),
           //                   hours : userCalendar.component(.hour, from: date),
           //                   minutes: userCalendar.component(.minute, from: date),
           //                   month : userCalendar.component(.month, from: date),
           //                   seconds : userCalendar.component(.second, from: date),
           //                   time: NSDate().timeIntervalSince1970.hashValue,
           //                   //            timezoneOffset: userCalendar.component(.timeZone, from: date),
           //                   timezoneOffset: -300,
           //                   year: userCalendar.component(.year, from: date)
           
           
           return createdAt
       }
    
    
    func getTempParking(showBargainingDialog : Bool){
        
//        Map<String, Object> queryMap = new HashMap<>();
//               queryMap.put("id", parkingModel1.getTemp_parking_id());
        
        _ = ["id":parking_details.tempParkingID]
        Helper().showSpinner(view: self.view)
 
        let request = APIRouter.getParkingsById(id: parking_details.tempParkingID ?? 0)
        APIClient.serverRequest(url:request,path:request.getPath(), dec: ResponseData<Parking>.self) { (response, error) in
            
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if (response?.success) != nil {
//                    Helper().showToast(message: response?.message ?? "-", controller: self)
                    if let val = response?.data {
                        
                        self.sTime = val.startAt ?? ""
                        self.fTime = val.endAt ?? ""
                        
                        
                        self.st_time.text = "From : \( Helper().getFormatedDateAndTime(dateStr: self.sTime!))"
                        self.end_time.text = "To : \(Helper().getFormatedDateAndTime(dateStr: self.fTime!))"
                        
                        if(showBargainingDialog){

                            self.openChatScreen(model: val)

                        }
                        else{
                            
                            
                            self.parking_details.initialPrice = val.initialPrice
                           

                        }
                    }
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
    
//    func getTempParking(isChatOpen : Bool , id : Int){
//
//
//
//
//        getTempParkingServer(id: id) { (pModel) in
//
//
//
//            if (pModel != nil)
//            {
//
//                self.sTime = pModel.startAt ?? ""
//                self.fTime = pModel.endAt ?? ""
//
//
//                self.st_time.text = "From : \( Helper().getFormatedDateAndTime(dateStr: self.sTime!))"
//                self.end_time.text = "To : \(Helper().getFormatedDateAndTime(dateStr: self.fTime!))"
//
//                if(isChatOpen)
//                {
//
//
//
//
//                    self.openChatScreen(model: pModel)
//
//                }
//
//                else
//                {
//
//                    self.parking_details.initialPrice = pModel.initialPrice ?? 0.0
//                }
//
//            }
//
//        }
//
//
//
//    }
    
    
    
    func createTempParking(isTakeOffer : Bool)
    {
        
        if (self.parking_details.startAt == nil || self.parking_details.startAt?.isEmpty ?? false || self.parking_details.endAt == nil || self.parking_details.endAt?.isEmpty ?? false) {
            Helper().showToast(message: "Please Select Date Range", controller: self)
            
            self.offer_btn.isUserInteractionEnabled = true
            
            return;
        
        }

        var model = Parking(dictionary: self.parking_details.dictionary ?? [:])
        
        let sellerModel = model?.seller
        model?.seller = nil
        

        do{
            let data = try JSONEncoder().encode(model)
            //            Helper().showSpinner(view: self.view)
            let request = APIRouter.createTempParking(data)
            APIClient.serverRequest(url: request, path: request.getPath(),body: model.dictionary ?? [:], dec: ResponseData<Parking>.self) { (response, error) in
                Helper().hideSpinner(view: self.view)
                if(response != nil){
                    if (response?.success) != nil {
//                        Helper().showToast(message: response?.message ?? "-", controller: self)
                        if let val = response?.data {
                            
                            self.tempParkingId = val.id ?? 0
                            if (isTakeOffer) {
                                self.parking_details.tempParkingID = val.id
//                                if (onItemFieldUpdateListener != null) {
//                                    onItemFieldUpdateListener.onItemFieldUpdate(parkingModel1.getId(), "", parkingModel1.getTemp_parking_id());
//                                }
                                self.takeOffer(parkingId: val.id ?? 0, initialPrice: self.parking_details.initialPrice ?? 0.0);
                            }
                            else {
                                var model = Parking(dictionary: val.dictionary ?? [:])
                                model?.seller = sellerModel
                                self.openChatScreen(model: model ?? Parking());
                            }
                        }
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
        catch let parsingError {
            
            print("Error", parsingError)
            
        }
        

        
    }
    
    func cloneParking(parkingModel : Parking) -> Parking
    {
        
        
        let parking : Parking = parkingModel
        
        return parking
        
    }
    
    func openChatScreen(model : Parking){
        
       
        Helper().showSpinner(view: self.view)
        
        let url = APIRouter.me
        let decoder = ResponseData<Me>.self
        
        APIClient.serverRequest(url: url, path: url.getPath(), dec: decoder) { (response,error) in
            
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if let _  = response?.success {
                    
                    //                    Helper().showToast(message: "Success=\(success)", controller: self)
                    if let val = response?.data {
                        
                        var parkingModel = Parking.init(dictionary: model.dictionary ?? [:])
                        
                        parkingModel?.buyerID = val.id
                        let  buyerMdoel = Buyer(id: val.id, name: val.name, email: val.email, createdAt: val.createdAt, details: val.details, card: [nil])
                        
                        parkingModel?.buyer = buyerMdoel
                        
                        
                        
                       
                        
                       
                            let vc = ChatVC.instantiate(fromPeerParkingStoryboard: .Chat)
                                                   
                                                   vc.modalPresentationStyle = .fullScreen
                                                   
                                                   vc.parking_details = parkingModel
                            self.present(vc, animated: true, completion: nil)
                        
                       
                        
                       
                        
                        
                        
                    }
                }
                else{
                    Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                }
            }
            else if(error != nil){
                Helper().showToast(message: "\(error?.localizedDescription ?? "" )", controller: self)
            }
            else{
                Helper().showToast(message: "Nor Response and Error!!", controller: self)
            }
            
        }
        
        
        
    }
    
    
       
    
    
    
    func getTempParkingServer(id : Int   , completion: @escaping (Parking) -> Void){
        
        
        Helper().showSpinner(view: self.view)
        APIClient.serverRequest(url: APIRouter.getParkingsById(id: id), path: APIRouter.getParkingsById(id: id).getPath(), dec:
        ResponseData<Parking>.self) { (response,error) in
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if (response?.success) != nil {
                    //Helper().showToast(message: "Succes=\(success)", controller: self)
                    if (response?.data) != nil {
                        
                        completion((response?.data ?? nil)! )
                    }
                }
                    
                    
                else{
                    Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                    
                    completion((response?.data ?? nil)! )
                }
            }
            else if(error != nil){
                Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
                completion((response?.data ?? nil)! )
            }
            else{
                Helper().showToast(message: "Nor Response and Error!!", controller: self)

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
        
        
        self.takeOffer();
        
//
//        if(self.sTime == nil || self.fTime == nil)
//        {
//
//
//            Helper().showToast(message: "Please select time", controller: self)
//            return
//
//
//        }
//
//        let p_id = self.parking_details.id ?? 0
//        let final_price = Double(self.parking_details.initialPrice ?? 0.0)
//        let myId = UserDefaults.standard.integer(forKey: "id")
//
//
//        if Helper().IsUserLogin(){
//
//            let params:[String:Any] = [
//                "parking_id": p_id,
//                "buyer_id": myId,
//                "status": ParkingConst.STATUS_ACCEPTED,
//                "offer": final_price,
//                "direction": ParkingConst.BUYER_TO_SELLER
//            ]
//            print(params)
//            self.postBargainingOffer(params: params)
//
//            //            self.dismiss(animated: true, completion: nil)
//
//
//        }
//        else{
//
//            let vc = self.story.instantiateViewController(withIdentifier: "FBPopup") as? FBPopup
//
//            vc?.parking_details = self.parking_details
//
//
//            let popupVC = PopupViewController(contentController: vc!, popupWidth: 320, popupHeight: 365)
//            popupVC.canTapOutsideToDismiss = true
//
//
//            present(popupVC, animated: true)
//
//        }
        
    }
    
    func postBargainingOffer(params:[String:Any]){
        
        APIClient.serverRequest(url: APIRouter.postBargainingOffer(params), path: APIRouter.postBargainingOffer(params).getPath(), dec: PostResponseData.self) { (response,error) in
            
            if(response != nil){
                if (response?.success) != nil {
                    
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
        
        let vc = UIStoryboard(name: "TimeWidget", bundle: nil).instantiateViewController(withIdentifier: "SliderTimerVC") as! SliderTimerVC
        
        //        self.navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .fullScreen
        vc.parking_details = parking_details
        vc.delegate = self
        self.present(vc, animated: true,completion: nil)
        
    }
    
    @IBAction func counter_btn(_ sender: UIButton) {
        
        
        
        if Helper().IsUserLogin(){
            onBtnChatClicked();
        } else {
            showLoginDialog();
        }
        
      
       
        
        
    }
    
    private func onBtnChatClicked() {
        if (self.parking_details.parkingType == ParkingType.PARKING_TYPE_PUBLIC) {
            openChatScreen(model: self.parking_details)
        } else {
            if (self.parking_details.tempParkingID == 0) {
                createTempParking(isTakeOffer: false);
            } else {

                getTempParking(showBargainingDialog: true);

            }
        }
    }
    
    private func showLoginDialog() {
        

        let vc = FBPopup.instantiate(fromPeerParkingStoryboard: .Main)
        vc.source = Source.SELL_PARKING.rawValue
        
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
        
        
//        final SocialLoginGenricDialougeFramgnet genericDialogFragment = SocialLoginGenricDialougeFramgnet.newInstance();
//
//
//        genericDialogFragment.setLoginSuccessListener(new GenericClickableInterface() {
//            @Override
//            public void click() {
//                ((HomeActivity) activity).parkingSearchedBeforeLogin = null;
//
//                if (genericDialogFragment.isVisible()) {
//                    genericDialogFragment.dismiss();
//                }
//            }
//        });
//
//        genericDialogFragment.setButtonClickListener(new GenericClickableInterface() {
//            @Override
//            public void click() {
//
//                ParkingItemBottomFragment.this.dismiss();
//
//            }
//        });
//
//
//        genericDialogFragment.show(getFragmentManager(), null);
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
    func timeSelect(startigTime: String, endingTime: String, finalPrice: Double) {
         //
               //        var times : [String] = []
               //        times[0] = startigTime
               //        times[1] = endingTime
               //
               //        return times
               
               self.parking_details.initialPrice = initialPrice
               sTime = startigTime
               fTime = endingTime
               
               st_time.text = "From : \(startigTime)"
               end_time.text = "To : \(endingTime)"
               
                self.parking_details.startAt = startigTime
               self.parking_details.endAt = endingTime
               self.parking_details.privateParkingId = self.parking_details.id
               
               self.parking_details.status = APP_CONSTANT.STATUS_PARKING_TEMP
               
               if(self.tempParkingId != 0 || self.tempParkingId != nil)
               {
//                self.parking_details.startAt = Helper().getFormatedServerDateTimeForDetail(dateStr: self.parking_details.startAt ?? "")
//                self.parking_details.endAt = Helper().getFormatedServerDateTimeForDetail(dateStr: self.parking_details.endAt )
                self.parking_details.finalPrice = finalPrice
                   updateTempParking(parkingModel1 : self.parking_details);
               }
    }
    
    
    
    public func updateTempParking( parkingModel1 : Parking ) {
        
        
        
        
        let park_model = UpdateTempParkingSendingModel(startAt: parkingModel1.startAt, endAt: parkingModel1.endAt, initialPrice: parkingModel1.initialPrice, finalPrice: parkingModel1.finalPrice)
        
        
        do{
            let data = try JSONEncoder().encode(parkingModel1)
//            Helper().showSpinner(view: self.view)
            let request = APIRouter.updateParking(id: self.parking_details.privateParkingId, data)
            
            var dict : Dictionary = park_model.dictionary ?? [:]
            
            
            APIClient.serverRequest(url: request, path: request.getPath(),body: dict, dec: PostResponseData.self) { (response, error) in
//                Helper().hideSpinner(view: self.view)
                if(response != nil){
                    if (response?.success) != nil {
                        
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
        catch let parsingError {
            
            print("Error", parsingError)
            
        }
//           getBaseWebServices(true).postAPIAnyObject(WebServiceConstants.UPDATE_PARKING + tempParkingId, park_model.toString(), new WebServices.IRequestWebResponseAnyObjectCallBack() {
//               @Override
//               public void requestDataResponse(WebResponse<Object> webResponse) {
//                   if (webResponse.isSuccess()) {
//
//                   }
//               }
//
//               @Override
//               public void onError(Object object) {
//
//               }
//           });
    }
   
}
