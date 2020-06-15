//
//  ChatModel.swift
//  PeerParking
//
//  Created by APPLE on 6/12/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import Foundation
struct ChatModel: Codable {
    let createdAt: CreatedAt
    let direction: Int
    let id, message: String
    let messageType, offer, offerStatus: Int
}


// MARK: - CreatedAt

struct CreatedAt: Codable {
    let date, day, hours, minutes: Int
    let month, seconds, time, timezoneOffset: Int
    let year: Int
}
