//
//  PostBargainigOfferModel.swift
//  PeerParking
//
//  Created by Apple on 14/01/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import Foundation

// MARK: - PostBargainigOfferModel
struct PostBargainigOfferModel: Codable {
    let parkingID, buyerID, status, offer: Int?
    let direction: Int?
    let updatedAt, createdAt: String?
    let id: Int?
    let statusText: String?
    
    enum CodingKeys: String, CodingKey {
        case parkingID = "parking_id"
        case buyerID = "buyer_id"
        case status, offer, direction
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
        case statusText = "status_text"
    }
}
