//
//  UpdateParkingSendingModel.swift
//  PeerParking
//
//  Created by talha on 22/06/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

// MARK: - UpdateParkingSendingModel
struct UpdateParkingSendingModel: Codable {
    
    var status: Int?
    var startAt:String?
    var address: String?
    var title: String?
    var isNegotiable:Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case startAt = "start_at"
        case address
        case title
        case isNegotiable = "is_negotiable"
        
        
    }
}
