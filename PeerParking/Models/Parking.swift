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
    var id, sellerID, buyerID, vehicleType: Int?
    var parkingType, status: Int?
    var initialPrice, finalPrice ,distance: Double?
    var isNegotiable: Bool?
    var title,startAt, endAt, address, latitude: String?
    var longitude, image, note: String?
    var parkingHoursLimit: String?
    var parkingExtraFee, parkingAllowedUntil: String?
    var parkingExtraFeeUnit: Int?
    var isResidentFree: Bool?
    var createdAt, updatedAt, deletedAt: String?
    var action: Int?
    var extraFeeUnitText, vehicleTypeText: String?
    var imageURL: String?
    var parkingTypeText, parkingSubTypeText: String?
    var seller: Seller?
    var buyer: Buyer?
    var slots: [Slot]?
    var tempParkingID:Int?
    var isAlways:Bool?
    
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case distance
        case parkingSubTypeText = "parking_sub_type_text"
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
        case seller, buyer , slots
        case isAlways = "is_always"
        case tempParkingID = "temp_parking_id"
    }
}

