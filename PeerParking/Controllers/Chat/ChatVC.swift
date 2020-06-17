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

class ChatVC: UIViewController  {
    
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
        
    }
    
    @IBOutlet weak var parkingDetailContent: CardView!
    @IBOutlet weak var parkingContentHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var parkingDetailHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bargainCountVoew: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var parkingDetailView: UIView!
    
    @IBOutlet weak var messageTextFieldLabel: UITextField!
    @IBOutlet weak var parkingDetailTopConstrain: NSLayoutConstraint!
    
    
    
    var offer : String!
    
    var buyerMaxOffer : Double! = 0.0;
    var sellerMinOffer : Double! = 0.0;
    
    
    
    
    
    @IBOutlet weak var headerHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var tv: UITableView!
    
    var chatRef : DatabaseReference!
    
    var isScroll : Bool = true
    
    
    var chatModelArray = [ChatModel]()
    var checkIamSeller : Bool!
    
    
    
    var parking_details:Parking!
    
    var buyerBargainingCount : Int = 0
    var sellerBargainingCount : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tv.delegate = self
        tv.dataSource = self
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
        
        
        
        checkIamSeller = checkMeAsASeller() ? true : false
        
        
        
        
        // for reverse the scroll view
        //        tv.scrollToRowAtIndexPath(bottomIndexPath, atScrollPosition: .Bottom,
        //        animated: true)
        
        setUserData()
        setParkingData()
        initial()
        
        
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
        
        makeReferences()
        loadChats()
        
        
        
    }
    func setUserData(){
        
        
        if(checkIamSeller)
        {
            if parking_details.buyer?.details?.imageURL == nil
            {
                userImageView.image = UIImage.init(named: "placeholder")
            }
            else
            {
                
                let imgUrl = parking_details.buyer?.details?.imageURL
                userImageView.sd_setImage(with: URL(string: imgUrl ?? ""),placeholderImage: UIImage.init(named: "placeholder-img") )
            }
            
            
            if(parking_details.buyer?.details?.firstName != nil)
            {
                userNameView.text = parking_details.buyer?.details?.firstName
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
        
        if parking_details.imageURL == nil
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
        //        print(String(parking_details.buyer.id!))
        
        //        chatRef = Database.database().reference(withPath: "chat/").child(String(self.parking_details.id!)).child(String(self.parking_details.buyer!.id!))
        
        
        if(checkIamSeller)
        {
            //            chatRef = Database.database().reference(withPath: "chat/").child(String(self.parking_details.id!)).child(String(self.parking_details.buyer!.id!))
            chatRef = Database.database().reference(withPath: "chat/").child(String(536)).child(String(8))
            
        }
            
        else
        {
            //             chatRef = Database.database().reference(withPath: "chat/").child(String(self.parking_details.id!)).child(String(UserDefaults.standard.integer(forKey: "id")))
            
            chatRef = Database.database().reference(withPath: "chat/").child(String(536)).child(String(8))
        }
        
        
        
        
        
        
    }
    
    func loadChats(){
        
        
        
        chatRef.observe(.value) { (snapshot) in
            
            self.chatModelArray.removeAll()
            self.buyerBargainingCount = 0
            self.sellerBargainingCount = 0
            self.sandOfferButton.isHidden = false
            
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
                
            else if (chatModel.direction == Constants.init().SELLER_TO_BUYER)
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
        
        
        //        let id = self.parking_details.sellerID
        let id = 44
        return UID == id ? true :  false
        
        
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
                        
                        print("default")
                        
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
            bargainCountVoew.isHidden = false
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
        
        let chat : ChatModel = createMessage()
        
        if(chat != nil)
        {
            
            
            postMessage(chatModel : chat)
            
            
        }
        
        
        //        chat.message = message
        //        chat.direction = checkIamSeller ? Constants().SELLER_TO_BUYER : Constants().BUYER_TO_SELLER
        //
        //        chat.createdAt = Date()
        //
    }
    
    func createMessage() -> ChatModel {
        
        
        
        let  message : String =   meesageLabel.text ?? ""
        
        
        let chat = ChatModel()
        chat.message = message
        chat.createdAt = makingCurrentDateModel()
        chat.direction = checkIamSeller ? Constants().SELLER_TO_BUYER : Constants().BUYER_TO_SELLER
        chat.messageType = message.isEmpty ? Constants().MESSAGEOFFER : Constants().MESSAGETEXT
        chat.offerStatus = message.isEmpty ? Constants().STATUS_COUNTER_OFFER : Constants().STATUS_CHAT
        chat.offer = message.isEmpty ?  Double(self.offer!) : 0.0
        
        
        self.meesageLabel.text = ""
        
        return chat
        
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
            self.chatRef.child(messageKey).setValue(dict)
        } catch let error {
            print(error)
        }
        
        
    }
    
    
    
    @IBAction func sendMessageAction(_ sender: Any) {
        
        sendMessage()
        
        
    }
    
    func newOfferIsValid(offer : Double) -> Bool{
        
        
        
        
        if(checkIamSeller)
        {
            if (offer > sellerMinOffer && sellerMinOffer > 0) {
                Helper().showToast(message: "Your new offer cannot be greater than previous.", controller: self)
                return false;
            }
            else
            {
                
                if (offer < buyerMaxOffer) {
                    Helper().showToast(message: "Your new offer cannot be less than previous.", controller: self)
                    
                    return false;
                }
                
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
            
            if(checkIamSeller!)
            {
                
                if(  chatModelArray[indexPath.row].direction == Constants.init().SELLER_TO_BUYER ) {
                  
                    cell.setOfferText(offer: Int(chatModelArray[indexPath.row].offer ?? 0.0) , isRight: true)
                    
                }
                else
                {
                   
                    cell.setOfferText(offer: Int(chatModelArray[indexPath.row].offer ?? 0.0) , isRight: false)
                    
                }
                
                
                
            }
            else
            {
                if(  chatModelArray[indexPath.row].direction == Constants.init().SELLER_TO_BUYER ) {
                    
                    
                  
                    cell.setOfferText(offer: Int(chatModelArray[indexPath.row].offer ?? 0.0) , isRight: false)
                    
                }
                else
                {
                   
                    cell.setOfferText(offer: Int(chatModelArray[indexPath.row].offer ?? 0.0) , isRight: true)
                    
                }
            }
            
            
            
            return cell
            
        }
        
        
        
        return UITableViewCell()
        
        
    }
    //    {
    //        //           let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath)
    //        //           cell.textLabel?.text = "row \(indexPath.row)"
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //        if(chatModelArray[indexPath.row].messageType == Constants.init().MESSAGETEXT)
    //        {
    //
    //            let  cell = tv.dequeueReusableCell(withIdentifier: "chatTextCell") as! chatTextCell
    //
    //
    //
    //            cell.dateLabel.text = convertTimestamp(timeStamp: TimeInterval(chatModelArray[indexPath.row].createdAt?.time ?? 0))
    //
    //            cell.chatText.text = chatModelArray[indexPath.row].message
    //
    //            print("check seller \(checkIamSeller!)")
    //
    //
    //            if(checkIamSeller!)
    //            {
    //
    //
    //                print("chat direction \(chatModelArray[indexPath.row].direction)")
    //
    //
    //                cell.setLayout(
    //
    //                    chatModelArray[indexPath.row].direction == Constants.init().SELLER_TO_BUYER ? true : false
    //                )
    //
    //
    //
    //            }
    //            else
    //            {
    //
    //
    //                chatModelArray[indexPath.row].direction == Constants.init().SELLER_TO_BUYER ?
    //                    cell.setLayout(false)
    //                    :  cell.setLayout(true)
    //
    //
    //            }
    //            ////
    //
    //
    //            return cell
    //        }
    //
    //        else
    //        {
    //
    //
    //            let  cell = tv.dequeueReusableCell(withIdentifier: "chatOfferCell") as! chatOfferCell
    //
    //            cell.dateLabel.text = convertTimestamp(timeStamp: TimeInterval(chatModelArray[indexPath.row].createdAt?.time ?? 0))
    //
    //
    //
    //            if(checkIamSeller!)
    //            {
    //
    //                cell.setOfferText(offer:  Int(chatModelArray[indexPath.row].offer ?? 0.0) , isRight:  chatModelArray[indexPath.row].direction == Constants.init().SELLER_TO_BUYER ? true : false)
    //
    //
    //
    //
    //                cell.setLayout(chatModelArray[indexPath.row].direction == Constants.init().SELLER_TO_BUYER ? true : false)
    //
    //            }
    //            else
    //            {
    //
    //                cell.setLayout(chatModelArray[indexPath.row].direction == Constants.init().BUYER_TO_SELLER ? false : true)
    //
    //
    //                cell.setOfferText(offer:  Int(chatModelArray[indexPath.row].offer ?? 0.0) , isRight:  chatModelArray[indexPath.row].direction == Constants.init().BUYER_TO_SELLER ? false : true)
    //
    //
    //            }
    //
    //            return cell
    //        }
    //
    //    }
    
    
    
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
        
        
        if(checkIamSeller){
            let val = Double(self.offer)!
            if(val < self.buyerMaxOffer)
            {
                
                Helper().showToast(message: "Your amount is less than the one offered to you.", controller: self)
                
                return false
            }
            else
            {
                if(val == 0){
                    
                    if(val > self.parking_details.initialPrice!){
                        
                        Helper().showToast(message: "You are offering more than the parking price", controller: self)
                        
                        return false
                        
                    }
                    else if (val > self.sellerMinOffer){
                        
                        Helper().showToast(message: " You are offering more than the sellers last offer", controller: self)
                        
                        return false
                        
                    }
                    
                }
            }
            
        }
        
        return true
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




