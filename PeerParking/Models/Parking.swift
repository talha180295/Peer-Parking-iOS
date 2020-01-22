//
//  Parkings.swift
//  ObjectMapDemo
//
//  Created by Apple on 13/01/2020.
//  Copyright © 2020 Talha. All rights reserved.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let parkings = try? newJSONDecoder().decode(Parkings.self, from: jsonData)

import Foundation

// MARK: - Parkings
struct Parking: Codable {
    let id, sellerID, buyerID, vehicleType: Int?
    let parkingType, status: Int?
    let initialPrice, finalPrice: Double?
    let isNegotiable: Bool?
    let startAt, endAt, address, latitude: String?
    let longitude, image, note: String?
    let parkingHoursLimit: String?
    let parkingExtraFee, parkingAllowedUntil: String?
    let parkingExtraFeeUnit: Int?
    let isResidentFree: Bool?
    let createdAt, updatedAt, deletedAt: String?
    let action: Int?
    let extraFeeUnitText, vehicleTypeText: String?
    let imageURL: String?
    let parkingTypeText: String?
    let seller: Seller?
    let buyer: Buyer?
    
    enum CodingKeys: String, CodingKey {
        case id
        case sellerID = "seller_id"
        case buyerID = "buyer_id"
        case vehicleType = "vehicle_type"
        case parkingType = "parking_type"
        case status
        case initialPrice = "initial_price"
        case finalPrice = "final_price"
        case isNegotiable = "is_negotiable"
        case startAt = "start_at"
        case endAt = "end_at"
        case address, latitude, longitude, image, note
        case parkingHoursLimit = "parking_hours_limit"
        case parkingAllowedUntil = "parking_allowed_until"
        case parkingExtraFee = "parking_extra_fee"
        case parkingExtraFeeUnit = "parking_extra_fee_unit"
        case isResidentFree = "is_resident_free"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case action
        case extraFeeUnitText = "extra_fee_unit_text"
        case vehicleTypeText = "vehicle_type_text"
        case imageURL = "image_url"
        case parkingTypeText = "parking_type_text"
        case seller, buyer
    }
}

