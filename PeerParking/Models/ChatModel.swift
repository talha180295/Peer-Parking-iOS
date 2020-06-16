//
//  ChatModel.swift
//  PeerParking
//
//  Created by APPLE on 6/12/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import Foundation
class ChatModel: Codable {
    var createdAt: CreatedAt?
    var direction: Int?
    var id, message: String?
    var messageType, offerStatus: Int?
    var offer : Double?
    
    
    
    
//    init(
//        message: String? = "", //
//         createdAt: CreatedAt? = nil,
//         direction: Int? = nil ,
//         messageType :Int? = nil,
//         offer : Int? = 0,
//         offerStatus : Int? = nil,
//        id : String? = ""
//         ) {
//        
//        self.message = message!
//        self.createdAt = createdAt!
//        self.direction = direction!
//        self.messageType = messageType!
//        self.offer = offer!
//        self.offerStatus = offerStatus!
//        self.id = id!
//
//    }
    
   
    
    
    
}


// MARK: - CreatedAt

class CreatedAt: Codable {
     
    var  date, day, hours, minutes: Int?
    var month, seconds, time, timezoneOffset: Int?
    var year: Int?
    
    
    
    
}



