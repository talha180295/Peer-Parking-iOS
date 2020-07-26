//
//  ChatVC.swift
//  PeerParking
//
//  Created by APPLE on 6/9/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

import Firebase
import FirebaseCore
import CodableFirebase
import CircleProgressView
import Cosmos
import EzPopup
import  IQKeyboardManagerSwift

class ChatVC: UIViewController  , UITextFieldDelegate {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var sendMessageBtn: UIButton!
    @IBOutlet weak var sandOfferButton: UIButton!
    @IBOutlet weak var meesageLabel: UITextField!
    @IBOutlet weak var progressTextParkingDetail: UILabel!
    @IBOutlet weak var circularProgressParkingDetail: CircleProgressView!
    @IBOutlet weak var parkingTotalCostView: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameView: UILabel!
    
    @IBOutlet weak var circularProgressHeader: CircleProgressView!
    
    @IBOutlet weak var parkingRatingView: CosmosView!
    @IBOutlet weak var parkingToView: UILabel!
    @IBOutlet weak var parkingFromView: UILabel!
    @IBOutlet weak var parkingTypeView: UILabel!
    @IBOutlet weak var parkingTitleView: UILabel!
    @IBOutlet weak var parkingImageView: UIImageView!
    @IBOutlet weak var circularTextHeader: UILabel!
    fileprivate struct Constants {
        let SELLER_TO_BUYER  = 10
        let BUYER_TO_SELLER = 20
        let MESSAGETEXT = 20
        let MESSAGEOFFER = 10
        let STATUS_CHAT = 40
        let STATUS_COUNTER_OFFER = 30
        let BARGAINING_MESSAGE_FROM_SELLER = "Seller has a message for you"
        let BARGAINING_MESSAGE_FROM_BUYER = "Buyer has a message for you"
        
    }
    
    @IBOutlet weak var parkingDetailContent: CardView!
    @IBOutlet weak var parkingContentHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var parkingDetailHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bargainCountVoew: UIView!
    @IBOutlet weak var bargainInnerCountVoew: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var parkingDetailView: UIView!
    
    @IBOutlet weak var messageTextFieldLabel: UITextField!
    @IBOutlet weak var parkingDetailTopConstrain: NSLayoutConstraint!
    
    
    
    var offer : String!
    
    var buyerMaxOffer : Double! = 0.0;
    var sellerMinOffer : Double! = 0.0;
    var  amountInWallet = 0.0;
    
    var buyersList : [String] = []
    
    
    
    @IBOutlet weak var headerHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var tv: UITableView!
    
    var chatRef : DatabaseReference!
    var parkingBuyerModelReference : DatabaseReference!
    var parkingReference : DatabaseReference!
    var requestReference : DatabaseReference!
    var sellerRequestIndexReference : DatabaseReference!
    var buyerRequestIndexReference : DatabaseReference!
    
    var isScroll : Bool = true
    
    
    var chatModelArray = [ChatModel]()
    var checkIamSeller : Bool!
    
    
    
    var parking_details:Parking!
    
//    var parkingId : Int = 0
//    var buyerId : Int = 0
//
    var buyerBargainingCount : Int = 0
    var sellerBargainingCount : Int = 0
    
    var parkingStatus : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tv.delegate = self
        tv.dataSource = self
        
        meesageLabel.delegate = self
        messageTextFieldLabel.setLeftPaddingPoints(7)
        
        //        self.tv.estimatedRowHeight = 200.0;
        //        self.tv.rowHeight = UITableView.automaticDimension;
        
        self.tv.separatorStyle = .none
        
        bargainCountVoew.isHidden = true
        
        //        tv.register(UINib(nibName: "chatTextCell", bundle: nil), forCellReuseIdentifier: "chatTextCell")
        tv.register(UINib(nibName: "chatOfferCell", bundle: nil), forCellReuseIdentifier: "chatOfferCell")
        Helper().registerTableCell(tableView: tv, nibName: "BargainingCell", identifier: "BargainingCell")
        
        
        userImageView.layer.masksToBounds = false
        userImageView.layer.borderColor = UIColor.black.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.clipsToBounds = true
        userImageView.layer.borderWidth = 1
        
        
        
        
        checkIamSeller = checkMeAsASeller() ? true : false
        
        
        
        
        // for reverse the scroll view
        //        tv.scrollToRowAtIndexPath(bottomIndexPath, atScrollPosition: .Bottom,
        //        animated: true)
        
        
        makeReferences()
        setUserData()
        
        setParkingData()
        initial()
        
        
      

        
        
        
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        IQKeyboardManager.shared.enable = false
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: ChatVC.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: ChatVC.keyboardWillHideNotification, object: nil)
//    }
//
//    @objc func keyboardWillShow(notification: NSNotification) {
//
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//                if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//
//                }
//            }
//        }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//                if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += keyboardSize.height
//                }
//            }
//        }
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
       {

           textField.resignFirstResponder()
           return true
       }
    
    func scrollToBottom()  {
        let point = CGPoint(x: 0, y: self.tv.contentSize.height + self.tv.contentInset.bottom - self.tv.frame.height)
        if point.y >= 0{
            self.tv.setContentOffset(point, animated: true)
        }
        
        var bottomRow : Int = self.chatModelArray.count-1;
        
        if (bottomRow >= 0) {
            
            
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.chatModelArray.count-1, section: 0)
                self.tv.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    
    func initial(){
        
        
        loadChats()
        loadParking()
        getUpdatedWalletAmount()
       
        
        
        
        
        
    }
    
    
   
    
    
    private func getUpdatedWalletAmount() {
        
        let url = APIRouter.me
        let decoder = ResponseData<Me>.self
        
        Helper().showSpinner(view: self.view)
        APIClient.serverRequest(url: url,path:url.getPath(), dec: decoder) { (response, error) in
            
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if (response?.success) != nil {
                    //                    Helper().showToast(message: response?.message ?? "-", controller: self)
                    if let val = response?.data {
                        
                        
                        self.amountInWallet = val.details?.wallet ?? -1.0 //userModel.getUserDetails().getWallet();
                        
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
        
        //        getBaseWebServices(true).postAPIAnyObject(WebServiceConstants.PATH_ME, "", new WebServices.IRequestWebResponseAnyObjectCallBack() {
        //            @Override
        //            public void requestDataResponse(WebResponse<Object> webResponse) {
        //
        //                UserModel userModel = new Gson().fromJson(new Gson().toJson(webResponse.result), UserModel.class);
        //                amountInWallet = userModel.getUserDetails().getWallet();
        //            }
        //
        //            @Override
        //            public void onError(Object object) {
        //
        //            }
        //        });
    }
    func setUserData(){
        
        
       
        
        parkingBuyerModelReference!.observeSingleEvent(of: .value) { (snapshot) in
            if(snapshot.exists())
            {
                
                do {
                
                 var buyer : Buyer  = try FirebaseDecoder().decode(Buyer.self, from: snapshot.value ?? 0)
                self.populateView(buyer: buyer)
                
                } catch let error {
                                       print(error)
                                   }
                
                
            }
            else
            {
                
                
                do {
                    let model = try! FirebaseEncoder().encode(self.parking_details.buyer)
                   
                    self.parkingBuyerModelReference.setValue(model)
                    
                   
                } catch let error {
                    print(error)
                }
                self.populateView(buyer: self.parking_details.buyer!)
                
                
                
                
               
                //
            }
            
        }
        
        
        
        
    }
    
    func populateView(buyer : Buyer){
        
//        parkingId = parking_details.id ?? 0
//        buyerId = parking_details.buyerID ?? 0
        
        
        //        amountInWallet = Helper().getUserWallet()
        
        if(checkIamSeller)
        {
            if buyer.details?.imageURL == nil
            {
                userImageView.image = UIImage.init(named: "placeholder")
            }
            else
            {
                
                let imgUrl = buyer.details?.imageURL
                userImageView.sd_setImage(with: URL(string: imgUrl ?? ""),placeholderImage: UIImage.init(named: "placeholder-img") )
           
            }
            
//             userNameView.text = buyer.details?.firstName
            
            
            if(buyer.name != nil)
            {
                userNameView.text = buyer.name ?? ""
            }
        }
        else
        {
            if parking_details.seller?.details?.imageURL == nil
            {
                userImageView.image = UIImage.init(named: "placeholder")
            }
            else
            {
                
                let imgUrl = parking_details.seller?.details?.imageURL
                userImageView.sd_setImage(with: URL(string: imgUrl ?? ""),placeholderImage: UIImage.init(named: "placeholder-img") )
            }
            
            
            if(parking_details.seller?.details?.firstName != nil)
            {
                userNameView.text = parking_details.seller?.details?.firstName
            }
        }
        
        
        
    }
    
    func setParkingData(){
        
        //        self.sTime = pModel.startAt ?? ""
        //        self.fTime = pModel.endAt ?? ""
        //        self.st_time.text = "From : \( Helper().getFormatedDateAndTime(dateStr: self.sTime!))"
        //                       self.end_time.text = "To : \(Helper().getFormatedDateAndTime(dateStr: self.fTime!))"
        //
        
        
        if(parking_details.isNegotiable == false){
            self.sandOfferButton.isHidden = true
            self.bargainInnerCountVoew.isHidden = true
            self.bargainCountVoew.isHidden = true
        }
        
        if( parking_details.startAt != nil)
        {
            
            
            if(parking_details.parkingType==ParkingType.PARKING_TYPE_PUBLIC){
                self.parkingFromView.text = "Time : \(Helper().getFormatedDateAndTime(dateStr: self.parking_details.startAt!))"
            }
            else
            {
                self.parkingFromView.text = "From : \(Helper().getFormatedDateAndTime(dateStr: self.parking_details.startAt!))"
            }
            
            
            
            
            
        }
        
        if( parking_details.endAt != nil)
        {
            
            self.parkingToView.text = "To : \(Helper().getFormatedDateAndTime(dateStr: self.parking_details.endAt!))"
            
            
        }
        
        
        if(parking_details.parkingType == ParkingType.PARKING_TYPE_PRIVATE)
        {
            if(parking_details.finalPrice != nil)
            {
                self.parking_details.initialPrice = self.parking_details.finalPrice
                self.parkingTotalCostView.text = "$ \(String(format: "%0.2f" ,self.parking_details.finalPrice ?? 0.0))"
                
               
            }
            else
            {
              self.parkingTotalCostView.text = "$ \(String(format: "%0.2f" ,self.parking_details.initialPrice ?? 0.0))"
            }
        }
        else
        {
             self.parkingTotalCostView.text = "$ \(String(format: "%0.2f" ,self.parking_details.initialPrice ?? 0.0))"
        }
        
        
        
        if (parking_details.imageURL == nil)
        {
            parkingImageView.image = UIImage.init(named: "placeholder")
        }
        else
        {
            
            let imgUrl = parking_details.imageURL
            parkingImageView.sd_setImage(with: URL(string: imgUrl ?? ""),placeholderImage: UIImage.init(named: "placeholder-img") )
            
        }
        
        if parking_details.address != nil{
            
            parkingTitleView.text = parking_details.address
        }
        
        let size = parking_details.vehicleType
        if(size == 10){
            parkingTypeView.text  =  "\(VehicleTypeText.SUPER_MINI)"
        }
        else if(size == 20){
            parkingTypeView.text =  "\(VehicleTypeText.FAMILY)"
        }
        else if(size == 30){
            parkingTypeView.text =  "\(VehicleTypeText.SUV)"
        }
        else if(size == 40){
            parkingTypeView.text =  "\(VehicleTypeText.BUS)"
        }
        
        
        
        parkingRatingView.rating = (parking_details.seller?.details?.averageRating)!
        
        
        
        
    }
    
    func makeReferences(){
        
        
        print("parking id \(String(parking_details.id!))")
        
        chatRef = Database.database().reference(withPath: "chat/").child(String(parking_details.id!)).child(String(parking_details.buyerID!))
        parkingBuyerModelReference = Database.database().reference(withPath: "buyerModel/").child(String(parking_details.buyerID!))
        parkingReference = Database.database().reference(withPath: "chat/").child(String(parking_details.id!))
        requestReference = Database.database().reference(withPath: "requests/").child(String(parking_details.id!) + "-" + String(parking_details.buyerID!))
        sellerRequestIndexReference = Database.database().reference(withPath: "sellerRequestsIndex/")
        buyerRequestIndexReference = Database.database().reference(withPath: "buyerRequestsIndex/")
        
        
        
        
        
        
    }
    
    func loadParking(){
        
        
        self.parkingReference.observe(.value) { (snapshot) in
            
            if(snapshot.exists())
            {
                
                
                
                if let snapDict = snapshot.value as? [String:AnyObject] {

                    //here you can get data as string , int or anyway you want
                     print("parking status \(snapDict["status"] )")
                                   
                    self.parkingStatus = snapDict["status"] as? Int ?? 0


                }
                
                self.buyersList.removeAll()
                
                let enumerator = snapshot.children
                                           
                                           
                                           
                                           while let childSnapShot = enumerator.nextObject() as? DataSnapshot {
                                               
                                               guard let value = childSnapShot.value else { return }
                                               do {
                                                   
                                                 if (value is Dictionary<AnyHashable,Any>)  {
                                                     
                                                    self.buyersList.append(childSnapShot.key)
                                                     // obj is a string array. Do something with stringArray
                                                 }
                                                 else {
                                                     // obj is not a string array
                                                 }
                                                 
                                                   
                                                   
                                               } catch let error {
                                                   print(error)
                                               }
                                           }
               
                
                
            }
        }
        
    }
    
    func loadChats(){
        
        
        
        chatRef.observe(.value) { (snapshot) in
            
            self.chatModelArray.removeAll()
            self.buyerBargainingCount = 0
            self.sellerBargainingCount = 0
            //            self.sandOfferButton.isHidden = false
            
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                
                
                
                let enumerator = snapshot.children
                
                
                
                while let childSnapShot = enumerator.nextObject() as? DataSnapshot {
                    
                    guard let value = childSnapShot.value else { return }
                    do {
                        let model = try FirebaseDecoder().decode(ChatModel.self, from: value)
                        
                        
                        self.updateLimitsCount(chatModel: model);
                        self.updateOfferInputVisibility()
                        self.updateBargainCountDisplay()
                        
                        self.chatModelArray.append(model)
                        self.tv.reloadData()
                        self.scrollToBottom()
                        
                        
                    } catch let error {
                        print(error)
                    }
                }
                
                
                
            }
            
            
            
            
        }
        
        
        
        
    }
    
    func updateLimitsCount(chatModel : ChatModel){
        
        
        if(chatModel.messageType == Constants.init().MESSAGEOFFER)
        {
            if (chatModel.direction == Constants.init().BUYER_TO_SELLER) {
                
                buyerBargainingCount = buyerBargainingCount + 1
                
                if(chatModel.offer! > self.buyerMaxOffer)
                {
                    self.buyerMaxOffer = chatModel.offer
                }
                
                
            }
                
            else
            {
                sellerBargainingCount = sellerBargainingCount + 1
                if (chatModel.offer! < sellerMinOffer || sellerMinOffer == 0) {
                    
                    sellerMinOffer = chatModel.offer;
                    
                }
                
            }
        }
        
        
        
    }
    
    func checkMeAsASeller() -> Bool{
        
        
        let UID :Int = UserDefaults.standard.integer(forKey: "id")
        
        
                  let id = self.parking_details.sellerID
//        let id = 60
        return UID == id ? true :  false
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        resignFirstResponder()
        
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        
        
        
        
        self.presentingViewController?.dismiss(animated: false, completion: nil)
        
        
        
    }
    @IBAction func sendAnOfferAction(_ sender: Any) {
        
        
        meesageLabel.resignFirstResponder()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PricePicker") as! PricePicker
        
        vc.completionBlock = {(dataReturned) -> ()in
            //Data is returned **Do anything with it **
            print(dataReturned)
            self.offer = dataReturned
            
            vc.dismiss(animated: true, completion: nil)
            
            let offerVal:Double = Double(self.offer)!
            if(self.isOfferValid(offer: offerVal))
            {
                
                if (self.amountInWallet <= 0) {
                    
                    Helper().showToast(message: "Insufficient amount in wallet", controller: self)
                    return
                }
                
                let alert = UIAlertController(title: "Are you sure you want to offer $ \(self.offer!) ?", message: "Message", preferredStyle: .alert)
                
                
                
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                        
                        
                        if(self.newOfferIsValid(offer: offerVal))
                        {
                            self.sendMessage()
                        }
                        
                        
                        
                        
                        
                        
                    case .cancel:
                        
                       
                        print("cancel")
                        
                    case .destructive:
                        
                        print("destructive")
                        
                        
                    }}))
                
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        
                         self.offer = nil
                        
                    case .cancel:
                        
                        print("cancel")
                        
                    case .destructive:
                        
                        print("destructive")
                        
                        
                    }}))
                
                
                
                self.present(alert, animated: true, completion: nil)
            }
            
            
            
            
            
            
        }
        let popupVC = PopupViewController(contentController: vc, popupWidth: 300, popupHeight: 300)
        popupVC.canTapOutsideToDismiss = true
        
        
        present(popupVC, animated: true)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSLog("Table view scroll detected at offset: %f", scrollView.contentOffset.y)
        
        
        isScroll = false
        
        if(scrollView.contentOffset.y > 30 ){
            
            self.headerHeightConstrain.constant = 75
            self.parkingDetailTopConstrain.constant = 0
            self.parkingContentHeightConstrain.constant = 0
            
            if(parking_details.isNegotiable == true){
                        bargainCountVoew.isHidden = false
                   }
            
           
            //                self.parkingDetailContent.alpha = 0.0
            
            
            //                self.parkingDetailView.isHidden = true
            
            customAnimation()
            
        }
        
        if(scrollView.contentOffset.y < -30 ){
            
            self.headerHeightConstrain.constant = 180
            self.parkingDetailTopConstrain.constant = 100
            self.parkingContentHeightConstrain.constant = 88
            bargainCountVoew.isHidden = true
            //                self.parkingDetailContent.alpha = 1.0
            customAnimation()
            
        }
        
    }
    
    func customAnimation(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func sendMessage() {
        
        //
        
        let chat : ChatModel? = createMessage()
        
        if(chat != nil)
        {
            
            
            postMessage(chatModel : chat!)
            
            
        }
        
        
        //        chat.message = message
        //        chat.direction = checkIamSeller ? Constants().SELLER_TO_BUYER : Constants().BUYER_TO_SELLER
        //
        //        chat.createdAt = Date()
        //
    }
    
    func createMessage() -> ChatModel? {
        
        
        let chat = ChatModel()
        
        
        // this offer is when the edit text is not empty and user wants to send offer
        // but when user select the price after clickg thie offer and press no in alert than should
        // empty the offer on that action
        
        if(self.offer != nil && !meesageLabel.text!.isEmpty ){
            
            chat.message = ""
            chat.createdAt = makingCurrentDateModel()
            chat.direction = checkIamSeller ? Constants().SELLER_TO_BUYER : Constants().BUYER_TO_SELLER
            chat.messageType = Constants().MESSAGEOFFER
            chat.offerStatus =  Constants().STATUS_COUNTER_OFFER
            chat.offer =  Double(self.offer!)
            
            self.meesageLabel.text = ""
            
            return chat
            
        }
        
       else if( !meesageLabel.text!.isEmpty )
        {
            let  message : String =   meesageLabel.text ?? ""
           
            chat.message = message
            chat.createdAt = makingCurrentDateModel()
            chat.direction = checkIamSeller ? Constants().SELLER_TO_BUYER : Constants().BUYER_TO_SELLER
            chat.messageType = message.isEmpty ? Constants().MESSAGEOFFER : Constants().MESSAGETEXT
            chat.offerStatus = message.isEmpty ? Constants().STATUS_COUNTER_OFFER : Constants().STATUS_CHAT
            chat.offer = message.isEmpty ?  Double(self.offer!) : 0.0
            
            
            self.meesageLabel.text = ""
            
            return chat
            
        }
        else if(self.offer != nil){
            
            chat.message = ""
            chat.createdAt = makingCurrentDateModel()
            chat.direction = checkIamSeller ? Constants().SELLER_TO_BUYER : Constants().BUYER_TO_SELLER
            chat.messageType = Constants().MESSAGEOFFER 
            chat.offerStatus =  Constants().STATUS_COUNTER_OFFER
            chat.offer =  Double(self.offer!)
            
            self.meesageLabel.text = ""
            
            return chat
            
        }
        
        return nil
        
       
        
    }
    
    fileprivate func extractedFunc() -> DateComponents {
        return DateComponents()
    }
    
    func makingCurrentDateModel() -> CreatedAt {
        
        
        
        let userCalendar = Calendar.current
        let date = Date()
        let components = userCalendar.dateComponents([.day, .month, .year, .calendar], from: Date())
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
    
    func postMessage(chatModel : ChatModel){
        
        
        var  messageKey : String = self.chatRef.childByAutoId().key!
        
        chatModel.id = messageKey
        //        chatModel.setId(id: messageKey)
        
        do {
            
            
            
            let dict = try! FirebaseEncoder().encode(chatModel)
            //          let object =  try DictionaryDecoder().decode(ChatModel.self, from: chatModel)
            self.chatRef.child(messageKey).setValue(dict,withCompletionBlock:{ (error, ref) -> Void in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                    
                else
                {
                    
                    var actionType = ""
                    
//                    if (chatModel.getMessageType() == ChatModel.MESSAGE_TYPE_OFFER) {
//                        actionType = isCurrentUserSeller() ? AppConstants.BARGAINING_COUNTER_OFFER_BY_SELLER : AppConstants.BARGAINING_COUNTER_OFFER_BY_BUYER;
//                    } else {
//                        actionType = isCurrentUserSeller() ? AppConstants.BARGAINING_MESSAGE_FROM_SELLER : AppConstants.BARGAINING_MESSAGE_FROM_BUYER;
//                    }
//
                    if(chatModel.messageType == Constants.init().MESSAGEOFFER)
                    {
                        
                        actionType = self.checkIamSeller ?  APP_CONSTANT.BARGAINING_COUNTER_OFFER_BY_SELLER : APP_CONSTANT.BARGAINING_COUNTER_OFFER_BY_BUYER
                        
                        
                    }
                    else
                    {
                        actionType = self.checkIamSeller ?  APP_CONSTANT.BARGAINING_MESSAGE_FROM_SELLER : APP_CONSTANT.BARGAINING_MESSAGE_FROM_BUYER
                    }
                    
                    
                    var refId = String(self.parking_details.id!) + "-" + String(self.parking_details.buyerID!)
                   
                    self.sendNotification(actionType: actionType, message: "new message", refId: refId)
                    
                    var firebaseRequestModel : FirebaseRequestModel = FirebaseRequestModel()
                    
                    firebaseRequestModel.parkingID = self.parking_details.id!
                    firebaseRequestModel.sellerID = self.parking_details.sellerID
                    firebaseRequestModel.buyerID = self.parking_details.buyerID!
                    firebaseRequestModel.lastMessage = chatModel
                    firebaseRequestModel.parkingTitle = self.parking_details.title ?? ""
                    firebaseRequestModel.parkingLocation = self.parking_details.address
                    firebaseRequestModel.parkingStatus = self.parking_details.status
                    
                    
                    let request_dict = try! FirebaseEncoder().encode(firebaseRequestModel)
                    
                     self.offer = nil
                    
                    self.requestReference.setValue(request_dict)
                    
                    self.buyerRequestIndexReference.child(String(self.parking_details.buyerID!)).child(refId).setValue(chatModel.createdAt?.time)
                    self.sellerRequestIndexReference.child(String(self.parking_details.sellerID!)).child(refId).setValue(chatModel.createdAt?.time)
           
                }
                
                
                
            })
        } catch let error {
            print(error)
        }
        
        
    }
    
   
    
    
    
    @IBAction func sendMessageAction(_ sender: Any) {
        
        meesageLabel.resignFirstResponder()
        sendMessage()
        
        
    }
    
    func newOfferIsValid(offer : Double) -> Bool{
        
        
        
        
        if(checkIamSeller)
        {
            if (offer > sellerMinOffer && sellerMinOffer > 0) {
                Helper().showToast(message: "Your new offer cannot be greater than previous.", controller: self)
                return false;
            }
            
            
        }
        else
        {
            
            if (offer < buyerMaxOffer) {
                Helper().showToast(message: "Your new offer cannot be less than previous.", controller: self)
                
                return false;
            }
            
        }
        
        
        return true
        
    }
    
    
}


extension ChatVC  : UITableViewDelegate,UITableViewDataSource  {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatModelArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        
        let chat  = chatModelArray[indexPath.row]
        
        
        if(chat.messageType == Constants.init().MESSAGETEXT)
        {
            
            let  cell = tv.dequeueReusableCell(withIdentifier: "BargainingCell") as! BargainingCell
            
            
            
            //                    cell.dateLabel.text = convertTimestamp(timeStamp: TimeInterval(chatModelArray[indexPath.row].createdAt?.time ?? 0))
            
            //                    cell.chatText.text = chatModelArray[indexPath.row].message
            
            print("check seller \(checkIamSeller!)")
            
            
            if(checkIamSeller!)
            {
                
                
                print("chat direction \(chatModelArray[indexPath.row].direction)")
                
                
                if(  chatModelArray[indexPath.row].direction == Constants.init().SELLER_TO_BUYER ) {
                    
                    cell.rightOffer.text = chatModelArray[indexPath.row].message
                    cell.rightOfferDate.text = convertTimestamp(timeStamp: TimeInterval(chatModelArray[indexPath.row].createdAt?.time ?? 0))
                    
                    cell.rightOffer.superview?.isHidden = false
                    cell.rightOfferDate.isHidden = false
                    
                    cell.leftOffer.superview?.isHidden = true
                    cell.leftOfferDate.isHidden = true
                    
                }
                else
                {
                    
                    
                    cell.leftOffer.text = chatModelArray[indexPath.row].message
                    cell.leftOfferDate.text = convertTimestamp(timeStamp: TimeInterval(chatModelArray[indexPath.row].createdAt?.time ?? 0))
                    
                    cell.rightOffer.superview?.isHidden = true
                    cell.rightOfferDate.isHidden = true
                    
                    cell.leftOffer.superview?.isHidden = false
                    cell.leftOfferDate.isHidden = false
                }
                
                
                
                
                
                
                
                
            }
            else
            {
                
                
                
                if(  chatModelArray[indexPath.row].direction == Constants.init().SELLER_TO_BUYER ) {
                    
                    
                    
                    
                    cell.leftOffer.text = chatModelArray[indexPath.row].message
                    cell.leftOfferDate.text = convertTimestamp(timeStamp: TimeInterval(chatModelArray[indexPath.row].createdAt?.time ?? 0))
                    
                    cell.rightOffer.superview?.isHidden = true
                    cell.rightOfferDate.isHidden = true
                    
                    cell.leftOffer.superview?.isHidden = false
                    cell.leftOfferDate.isHidden = false
                }
                else
                {
                    cell.rightOffer.text = chatModelArray[indexPath.row].message
                    cell.rightOfferDate.text = convertTimestamp(timeStamp: TimeInterval(chatModelArray[indexPath.row].createdAt?.time ?? 0))
                    
                    cell.rightOffer.superview?.isHidden = false
                    cell.rightOfferDate.isHidden = false
                    
                    cell.leftOffer.superview?.isHidden = true
                    cell.leftOfferDate.isHidden = true
                    
                }
                
                
            }
            ////
            
            
            return cell
        }
        else
        {
            let  cell = tv.dequeueReusableCell(withIdentifier: "chatOfferCell") as! chatOfferCell
            
            cell.index = indexPath.row
            
            
            cell.delegate = self
            
            
           
            
            
            if(chatModelArray[indexPath.row].offerStatus == 10){
                
                self.sandOfferButton.isHidden = true
            }
            if(self.parkingStatus == 20){

                
               cell.leftacceptButton.isEnabled = false
                cell.leftacceptButton.isUserInteractionEnabled = false
            }
            
            
            if(checkIamSeller!)
            {
                
                if(  chatModelArray[indexPath.row].direction == Constants.init().SELLER_TO_BUYER ) {
                    
                    cell.setOfferText(offer: Double(chatModelArray[indexPath.row].offer ?? 0.0) , date: convertTimestamp(timeStamp: TimeInterval(chatModelArray[indexPath.row].createdAt?.time ?? 0)) , isRight: true,offerStatus: chatModelArray[indexPath.row].offerStatus!)
                    
                    
                }
                else
                {
                    
                    cell.setOfferText(offer: Double(chatModelArray[indexPath.row].offer ?? 0.0) , date: convertTimestamp(timeStamp: TimeInterval(chatModelArray[indexPath.row].createdAt?.time ?? 0)), isRight: false,offerStatus: chatModelArray[indexPath.row].offerStatus!)
                    
                }
                
                
                
            }
            else
            {
                if(  chatModelArray[indexPath.row].direction == Constants.init().SELLER_TO_BUYER ) {
                    
                    
                    
                    cell.setOfferText(offer: Double(chatModelArray[indexPath.row].offer ?? 0.0) ,date: convertTimestamp(timeStamp: TimeInterval(chatModelArray[indexPath.row].createdAt?.time ?? 0)), isRight: false,offerStatus: chatModelArray[indexPath.row].offerStatus!)
                    
                }
                else
                {
                    
                    cell.setOfferText(offer: Double(chatModelArray[indexPath.row].offer ?? 0.0) , date: convertTimestamp(timeStamp: TimeInterval(chatModelArray[indexPath.row].createdAt?.time ?? 0)) , isRight: true,offerStatus: chatModelArray[indexPath.row].offerStatus!)
                    
                }
            }
            
            
            
            return cell
            
        }
        
        
        
        return UITableViewCell()
        
        
    }
    
    func convertTimestamp(timeStamp: Double) -> String {
        let x = timeStamp / 1000
        
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yyyy HH:mm a"
        //        formatter.dateStyle = .long
        //        formatter.timeStyle = .medium
        
        return formatter.string(from: date as Date)
    }
    
    func updateOfferInputVisibility(){
        
        
        if(checkIamSeller)
        {
            if(self.sellerBargainingCount >= 3){
                self.sandOfferButton.isHidden = true
            }
        }
        else
        {
            if (buyerBargainingCount >= 3) {
                self.sandOfferButton.isHidden = true
            }
        }
        
        
    }
    
    func updateBargainCountDisplay(){
        
        
        var bargainCountDisplayString : String  = ""
        var progress : Int = 0;
        
        if(checkIamSeller)
        {
            bargainCountDisplayString = String( self.sellerBargainingCount ) + "/3";
            progress = self.sellerBargainingCount
        }
        else
        {
            bargainCountDisplayString = String( self.buyerBargainingCount ) + "/3";
            progress = self.buyerBargainingCount
        }
        
        
        self.circularTextHeader.text = bargainCountDisplayString
        self.progressTextParkingDetail.text = bargainCountDisplayString
        
        self.circularProgressHeader.progress = Double(progress)/3.0
        self.circularProgressParkingDetail.progress = Double(progress)/3.0
        
        //        txtViewParkingOffers.setText(bargainCountDisplayString);
        //        txtViewParkingOffers2.setText(bargainCountDisplayString);
        //        bargainCountProgressBar.setProgress(progress, true);
        //        bargainCountProgressBarHeader.setProgress(progress, true);
        
        
    }
    
    func isOfferValid (offer : Double ) -> Bool {
        
        let val = Double(self.offer)!
        if(checkIamSeller){
            
            if(val < self.buyerMaxOffer)
            {
                
                Helper().showToast(message: "Your amount is less than the one offered to you.", controller: self)
                
                return false
            }
            
            
        }
            
        else
        {
            
            if(self.sellerMinOffer == 0)
            {
                if(val > self.parking_details.initialPrice!){
                    
                    Helper().showToast(message: "You are offering more than the parking price", controller: self)
                    
                    return false
                    
                }
            }
                
            else if (val > self.sellerMinOffer){
                
                Helper().showToast(message: " You are offering more than the sellers last offer", controller: self)
                
                return false
                
            }
            
            
        }
        
        return true
    }
    
    
    
}

extension ChatVC : chatOfferCellDelegate{
    func acceptButton(index: Int) {
        
        
        
        
        
        if (!checkIamSeller && amountInWallet <= 0) {
            
            Helper().showToast(message: "Insufficient amount in wallet", controller: self)
            
            return;
        }
        
        
        var model : ChatModel = ChatModel()
        
        
        model.offerStatus = APP_CONSTANT.STATUS_ACCEPTED
        
        let alert = UIAlertController(title: "Alert!", message: "Are you sure you want to accept offer of $ \(chatModelArray[index].offer!)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
            
            self.assignBuyerApi(model : self.chatModelArray[index]);
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    public func assignBuyerApi( model : ChatModel ) {
        
        
        let buyerParkingSendingModel = BuyerTakeOfferModel.init(status: APP_CONSTANT.STATUS_PARKING_BOOKED, buyer_id: self.parking_details?.buyerID ?? -1, final_price: model.offer)
        do{
            let data = try JSONEncoder().encode(buyerParkingSendingModel)
            
            let request = APIRouter.assignBuyer(id: self.parking_details.id!, data)
            APIClient.serverRequest(url: request, path: request.getPath(),body: buyerParkingSendingModel.dictionary ?? [:], dec: PostResponseData.self) { (response, error) in
                
                if(response != nil){
                    if (response?.success) != nil {
                        
                        
                        Helper().showToast(message: response?.message ?? "-", controller: self)
                        
                        
                        var firebaseRequestModel : FirebaseRequestModel = FirebaseRequestModel()
                        
                        model.offerStatus =  APP_CONSTANT.STATUS_ACCEPTED
                        firebaseRequestModel.parkingID = self.parking_details.id!
                        firebaseRequestModel.parkingTitle = self.parking_details.title ?? ""
                        firebaseRequestModel.sellerID = self.parking_details.sellerID
                        firebaseRequestModel.buyerID = self.parking_details.buyerID!
                        firebaseRequestModel.lastMessage = model
                        firebaseRequestModel.parkingLocation = self.parking_details.address
                        firebaseRequestModel.parkingStatus = APP_CONSTANT.STATUS_PARKING_BOOKED
                        
                        
                        let request_dict = try! FirebaseEncoder().encode(firebaseRequestModel)
                        
                        self.requestReference.setValue(request_dict)
                        
//                        var  messageKey : String = self.chatRef.childByAutoId().key!
                        
                        model.offerStatus = APP_CONSTANT.STATUS_ACCEPTED
                        
                        let dict = try! FirebaseEncoder().encode(model)
                        //          let object =  try DictionaryDecoder().decode(ChatModel.self, from: chatModel)
                        
                        
                        self.chatRef.child(model.id!).setValue(dict)
                        
                        self.parkingReference.child("buyer_id").setValue(self.parking_details.buyerID)
                        self.parkingReference.child("status").setValue(APP_CONSTANT.STATUS_PARKING_BOOKED
                            ,withCompletionBlock:{ (error, ref) -> Void in
                                
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                                else
                                {
                                    
                                    
                                    Helper.removeRequestsOfAllOtherBuyers(parkingModel1: self.parking_details, buyersList: self.buyersList)
//                                    removeRequestsOfAllOtherBuyers(parkingModel1: model, buyersList: [String])
                                    
                                }
                                
                                
                        })
                        
                        
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
    
    
    private func sendNotification(actionType : String , message : String , refId : String) {
        
        var model:NotificationSendingModel = NotificationSendingModel()
        model.refId = refId
        model.recieverId = checkIamSeller ? self.parking_details.buyerID ?? -1 : self.parking_details.sellerID ?? -1
        model.actionType = actionType
        model.message = message
        
        do{
            let data = try JSONEncoder().encode(model)
            Helper.customSendNotification(data: data, controller: self,isDismiss: false)
        }
        catch let parsingError {
            
            print("Parsing Error", parsingError)
            
        }
    }
    
    
    
    
    public func removeRequestsOfAllOtherBuyers( parkingModel1 : Parking , buyersList: [String] ) {
        //        \(parkingModel1.id) - \(parkingModel1.buyerID)
        
        
        
        buyersList.forEach { (buyerId) in
            if(String(parkingModel1.buyerID ?? -1) == buyerId){
                
            }else{
                Database.database().reference(withPath: "requests/").child("\(parkingModel1.id) - \(parkingModel1.buyerID)").removeValue()
                
                
            }
        }
        
        
        
    }
    
}





extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}





