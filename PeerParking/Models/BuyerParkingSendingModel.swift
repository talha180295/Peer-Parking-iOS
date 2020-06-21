//
//  BuyerParkingSendingModel.swift
//  PeerParking
//
//  Created by talha on 21/06/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import Foundation

// MARK: - BuyerParkingSendingModel
struct BuyerParkingSendingModel: Codable {
    let status: Int?
    let endAt: String?


    enum CodingKeys: String, CodingKey {
        case status
        case endAt = "end_at"
    }
}
