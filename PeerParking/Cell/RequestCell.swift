//
//  RequestCell.swift
//  PeerParking
//
//  Created by Apple on 07/11/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import FittedSheets


protocol ViewOfferProtocol {
    func chatButtonSelectListner(index:Int)
     func acceptButtonSelectListner(index:Int)
}

class RequestCell: UITableViewCell {

    var index:Int!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var lastMessageView: UILabel!
    @IBOutlet weak var parkingTitleView: UILabel!
    @IBOutlet weak private var date: UILabel!
    
    @IBOutlet weak private var address: UILabel!
    
    @IBOutlet weak private var directionText: UILabel!
    
    @IBOutlet weak private var price: UILabel!
    
    var delegate: ViewOfferProtocol!
    
    var SELLR_TO_BUYER = 10
    var BUYER_TO_SELLER = 20
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    @IBAction func chatButtonAction(_ sender: Any) {
        delegate.chatButtonSelectListner(index: self.index)
    }
    
    @IBAction func acceptButtonAction(_ sender: Any) {
         self.delegate.acceptButtonSelectListner(index: self.index)
        
    }
    @IBAction func view_offer_btn(_ sender: UIButton) {
     
        
        
    }
    
    func setData(requestsModel:FirebaseRequestModel , position : Int){
        
        
        self.index = position
        
        acceptButton.isHidden = true
        parkingTitleView.text = requestsModel.parkingTitle
        address.text = requestsModel.parkingLocation
        
        if(requestsModel.lastMessage?.messageType == 20)
        {
            lastMessageView.text = requestsModel.lastMessage?.message
            
        }
        else
        {
            var currentUserId = Helper().getCurrentUserId()
            
            if(requestsModel.sellerID == currentUserId){
                if(requestsModel.lastMessage?.offerStatus == APP_CONSTANT.STATUS_ACCEPTED){
                    if(requestsModel.lastMessage?.direction == SELLR_TO_BUYER){
                                lastMessageView.text = "Buyer accepted the offer of $ \(requestsModel.lastMessage!.offer!)"
                               }else{
                                
                                 lastMessageView.text = "You accepted the offer of $ \(requestsModel.lastMessage!.offer!)"
                                
                                  
                               }
                           }else{

                               if(requestsModel.lastMessage?.direction == SELLR_TO_BUYER){
                                
                                 lastMessageView.text = "You sent the offer of $ \(requestsModel.lastMessage!.offer!)"
                                
                                  
                               }else{
                                acceptButton.isHidden = false
                                   lastMessageView.text = "Buyer sent the offer of $ \(requestsModel.lastMessage!.offer!)"
                                  
                               }
                           }
                       }else{
                if(requestsModel.lastMessage?.offerStatus == APP_CONSTANT.STATUS_ACCEPTED){
                    if(requestsModel.lastMessage?.direction == BUYER_TO_SELLER){
                        
                         lastMessageView.text = "Seller accepted the offer of $ \(requestsModel.lastMessage!.offer!)"
                        
                                  
                               }else{
                        
                         lastMessageView.text = "You accepted the offer of $ \(requestsModel.lastMessage!.offer!)"
                                  
                               }
                           }else{

                               if(requestsModel.lastMessage?.direction == BUYER_TO_SELLER){
                                
                                 lastMessageView.text = "You sent the offer of $ \(requestsModel.lastMessage!.offer!)"
                                
                                  
                               }else{
                                  acceptButton.isHidden = false
                                
                                 lastMessageView.text = "Seller sent the offer of $ \(requestsModel.lastMessage!.offer!)"
                                
                                  
                               }
                           }
                       }
        }
        
        
        
        
       
        
        
    }
    
}
