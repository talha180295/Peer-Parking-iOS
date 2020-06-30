//
//  NotificationSendingModel.swift
//  PeerParking
//
//  Created by talha on 24/06/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import Foundation

// MARK: - NotificationSendingModel
struct NotificationSendingModel: Codable {
  
    var actionType: String?
    var message: String?
    var recieverId: Int?
    var refId: String?


    enum CodingKeys: String, CodingKey {
        case actionType = "action_type"
        case message
        case recieverId = "reciever_id"
        case refId = "ref_id"
    }
}
