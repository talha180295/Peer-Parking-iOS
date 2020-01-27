//
//  Me.swift
//  PeerParking
//
//  Created by Apple on 27/01/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import Foundation
// MARK: - Me
struct Me: Codable {
    let id: Int?
    let name, email, createdAt: String?
    let details: Details?
    let card: [Card]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, email
        case createdAt = "created_at"
        case details, card
    }
}
