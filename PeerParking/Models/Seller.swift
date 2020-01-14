//
//  Seller.swift
//  ObjectMapDemo
//
//  Created by Apple on 13/01/2020.
//  Copyright © 2020 Talha. All rights reserved.
//

import Foundation
// MARK: - Seller
struct Seller: Codable {
    let id: Int?
    let name, email, createdAt: String?
    let details: Details?
    let card: Card?
    
    enum CodingKeys: String, CodingKey {
        case id, name, email
        case createdAt = "created_at"
        case details, card
    }
}
