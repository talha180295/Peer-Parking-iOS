//
//  LoginRequest.swift
//  PeerParking
//
//  Created by talha on 27/06/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import Foundation


// MARK: - LoginRequest
struct LoginRequest: Codable {
    var email: String?
    var password: String?
    var deviceType: String?
    var deviceToken: String?

    enum CodingKeys: String, CodingKey {
        case email = "email"
        case password = "password"
        case deviceType = "device_type"
        case deviceToken = "device_token"
    }
}
