//
//  RefreshTokenModel.swift
//  PeerParking
//
//  Created by Apple on 14/01/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let refreshTokenModel = try? newJSONDecoder().decode(RefreshTokenModel.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseRefreshTokenModel { response in
//     if let refreshTokenModel = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - RefreshTokenModel
struct RefreshTokenModel: Codable {
    let success: Bool?
    let data: DataClass?
    let message: String?
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseDataClass { response in
//     if let dataClass = response.result.value {
//       ...
//     }
//   }

// MARK: - DataClass
struct DataClass: Codable {
    let user: User?
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseUser { response in
//     if let user = response.result.value {
//       ...
//     }
//   }

// MARK: - User
struct User: Codable {
    let id: Int?
    let name, email, createdAt: String?
    let details: Details?
    let card: Card?
    let accessToken, tokenType: String?
    let expiresIn: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, email
        case createdAt = "created_at"
        case details, card
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

