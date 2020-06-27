//
//  FirebaseRequestModel.swift
//  PeerParking
//
//  Created by APPLE on 6/23/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import Foundation
class FirebaseRequestModel: Codable {
    var buyerID: Int?
    var lastMessage: ChatModel?
    var parkingID: Int?
    var parkingLocation: String?
    var parkingStatus, sellerID: Int?
    var parkingTitle : String!

    enum CodingKeys: String, CodingKey {
        case buyerID = "buyerId"
        case lastMessage
        case parkingID = "parkingId"
        case parkingLocation, parkingStatus
        case sellerID = "sellerId"
        case parkingTitle
    }

    
}
