//
//  UpdateTempParkingSendingModel.swift
//  PeerParking
//
//  Created by APPLE on 6/25/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

struct UpdateTempParkingSendingModel: Codable {
    let startAt: String?
    let endAt: String?
    let initialPrice:Double?
    let finalPrice:Double?

    enum CodingKeys: String, CodingKey {
        case startAt = "start_at"
        case endAt = "end_at"
        case initialPrice = "initial_price"
        case finalPrice = "final_price"
    }
}

