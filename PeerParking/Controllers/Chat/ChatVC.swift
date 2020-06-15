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

class ChatVC: UIViewController  {
    
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
        
    }
    
    @IBOutlet weak var parkingDetailContent: CardView!
    @IBOutlet weak var parkingContentHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var parkingDetailHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bargainCountVoew: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var parkingDetailView: UIView!
    
    @IBOutlet weak var messageTextFieldLabel: UITextField!
    @IBOutlet weak var parkingDetailTopConstrain: NSLayoutConstraint!
    
    
    
   
    
    
    @IBOutlet weak var headerHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var tv: UITableView!
    
    var chatRef : DatabaseReference!
    
    var isScroll : Bool = true
    
    
    var chatModel = [ChatModel]()
    
    
    
    var parking_details:Parking!
    
    var buyerBargainingCount : Int = 0
     var sellerBargainingCount : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tv.delegate = self
        tv.dataSource = self
        messageTextFieldLabel.setLeftPaddingPoints(7)
        
        self.tv.estimatedRowHeight = 200.0;
        self.tv.rowHeight = UITableView.automaticDimension;
        
        self.tv.separatorStyle = .none
        
        bargainCountVoew.isHidden = true
        
        tv.register(UINib(nibName: "chatTextCell", bundle: nil), forCellReuseIdentifier: "chatTextCell")
        tv.register(UINib(nibName: "chatOfferCell", bundle: nil), forCellReuseIdentifier: "chatOfferCell")
        
        
        
        userImageView.layer.masksToBounds = false
        userImageView.layer.borderColor = UIColor.black.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.clipsToBounds = true
        
        
       
        // for reverse the scroll view
//        tv.scrollToRowAtIndexPath(bottomIndexPath, atScrollPosition: .Bottom,
//        animated: true)
        
        setUserData()
        setParkingData()
        initial()
        
        
    }
    
    func scrollToBottom()  {
//        let point = CGPoint(x: 0, y: self.tv.contentSize.height + self.tv.contentInset.bottom - self.tv.frame.height)
//        if point.y >= 0{
//            self.tv.setContentOffset(point, animated: true)
//        }
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chatModel.count-1, section: 0)
            self.tv.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    func initial(){
        
        makeReferences()
        loadChats()
        
        
        
    }
    func setUserData(){
        
        
        if(checkMeAsASeller())
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
        
        
        if(checkMeAsASeller())
        {
            chatRef = Database.database().reference(withPath: "chat/").child(String(self.parking_details.id!)).child(String(self.parking_details.buyer!.id!))
        }
        
        else
        {
             chatRef = Database.database().reference(withPath: "chat/").child(String(self.parking_details.id!)).child(String(UserDefaults.standard.integer(forKey: "id")))
        }
        
       
        
        
        
        
    }
    
    func loadChats(){
        
       
        
        chatRef.observe(.value) { (snapshot) in
            
             self.chatModel.removeAll()
            
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                
                
                
                let enumerator = snapshot.children
                
                
                
                while let childSnapShot = enumerator.nextObject() as? DataSnapshot {
                    
                    guard let value = childSnapShot.value else { return }
                    do {
                        let model = try FirebaseDecoder().decode(ChatModel.self, from: value)
                        
                        
                         print(model.offer)
                        self.chatModel.append(model)
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
        
        if (chatModel.direction == Constants.init().SELLER_TO_BUYER) {
           
            buyerBargainingCount = buyerBargainingCount + 1
//            if (chatModel.getOffer() > buyerMaxOffer) {
//                buyerMaxOffer = chatModel.getOffer();
//            }
        } else if (chatModel.direction == Constants.init().BUYER_TO_SELLER) {
            sellerBargainingCount = sellerBargainingCount + 1
//            if (chatModel.getOffer() < sellerMinOffer || sellerMinOffer == 0) {
//                sellerMinOffer = chatModel.getOffer();
//            }

        }
        
    }
    
    func checkMeAsASeller() -> Bool{
        
        
       let UID :Int = UserDefaults.standard.integer(forKey: "id")
        
        
        let id = self.parking_details.sellerID
        
        print("user id is \(id)")
        
        if(UID == id!)
        {
            return true
        }
        
        return false
        
        
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        
        
        self.presentingViewController?.dismiss(animated: false, completion: nil)
        
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
    
}


extension ChatVC  : UITableViewDelegate,UITableViewDataSource  {
    
    
    
    
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //
    //        var val : CGFloat  = 0.0
    //
    //        if(indexPath.row < 2)
    //               {
    //                val = 100.0
    //
    //        }
    //        else
    //        {
    //            val = 100.0
    //        }
    //
    //         return val
    //    }
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //           let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath)
        //           cell.textLabel?.text = "row \(indexPath.row)"
        
        
        
        
        
             if(chatModel[indexPath.row].messageType == Constants.init().MESSAGETEXT)
                    {
                        
                         let  cell = tv.dequeueReusableCell(withIdentifier: "chatTextCell") as! chatTextCell
                        
            //            let dateFormatter : DateFormatter = DateFormatter()
            //             dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //
            //            let dateString = dateFormatter.string(from:  Date(timeIntervalSinceReferenceDate: ))
                       
                       
                        
                        cell.dateLabel.text = convertTimestamp(timeStamp: TimeInterval(chatModel[indexPath.row].createdAt.time))
                        
                        cell.chatText.text = chatModel[indexPath.row].message
                       
                        
                       
            //            cell.dateLabel.text =  Date(timeIntervalSinceReferenceDate: TimeInterval(chatModel[indexPath.row].createdAt.time))
                        
                        
                        if(!checkMeAsASeller())
                        {
                        
                            
                            cell.setLayout(chatModel[indexPath.row].direction == Constants.init().BUYER_TO_SELLER ? true : false)
                            
                        }
                        else
                        {
                            
                           cell.setLayout(chatModel[indexPath.row].direction == Constants.init().SELLER_TO_BUYER ? true : false)
                        }
                        
                        
                        
                         return cell
                    }
                    
                    else
                    {
                        
                        
                        let  cell = tv.dequeueReusableCell(withIdentifier: "chatOfferCell") as! chatOfferCell
                        
                         cell.dateLabel.text = convertTimestamp(timeStamp: TimeInterval(chatModel[indexPath.row].createdAt.time))
                        
                        
                        
                       if(!checkMeAsASeller())
                        {
                        
                              cell.setOfferText(offer:  chatModel[indexPath.row].offer , isRight:  chatModel[indexPath.row].direction == Constants.init().BUYER_TO_SELLER ? true : false)
                            
                            cell.setLayout(chatModel[indexPath.row].direction == Constants.init().BUYER_TO_SELLER ? true : false)
                            
                        }
                        else
                        {
                            
                           cell.setLayout(chatModel[indexPath.row].direction == Constants.init().SELLER_TO_BUYER ? true : false)
                            
                            
                             cell.setOfferText(offer:  chatModel[indexPath.row].offer , isRight:  chatModel[indexPath.row].direction == Constants.init().BUYER_TO_SELLER ? true : false)
                            
                        }
                        
                        
                      
                       
                        
                        
                        
                        return cell
                    }
       
        
       
        
        
        
        
    }
    
    func setChatDirection(chatModel : ChatModel){
        
        
        
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
    
}

