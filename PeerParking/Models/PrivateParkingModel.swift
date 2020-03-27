// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let privateParkingModel = try? newJSONDecoder().decode(PrivateParkingModel.self, from: jsonData)

import Foundation

// MARK: - PrivateParkingModel
struct PrivateParkingModel: Codable {
    let id, sellerID, vehicleType, parkingSubType: Int?
    let title: String?
    let status: Int?
    let initialPrice: Double?
    let isNegotiable, isAlways: Bool?
    let address, latitude, longitude, image: String?
    let note, createdAt, updatedAt, deletedAt: String?
    let vehicleTypeText, parkingSubTypeText: String?
    let parkingType, tempParkingID: Int?
    let imageURL: String?
    let seller: Seller?
    let slots: [Slot]?

    enum CodingKeys: String, CodingKey {
        case id
        case sellerID = "seller_id"
        case vehicleType = "vehicle_type"
        case parkingSubType = "parking_sub_type"
        case title, status
        case initialPrice = "initial_price"
        case isNegotiable = "is_negotiable"
        case isAlways = "is_always"
        case address, latitude, longitude, image, note
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case vehicleTypeText = "vehicle_type_text"
        case parkingSubTypeText = "parking_sub_type_text"
        case parkingType = "parking_type"
        case tempParkingID = "temp_parking_id"
        case imageURL = "image_url"
        case seller, slots
    }
}

// MARK: - Slot
struct Slot: Codable {
    let id, parkingID, day: Int?
    let startAt, endAt, createdAt, updatedAt: String?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case parkingID = "parking_id"
        case day
        case startAt = "start_at"
        case endAt = "end_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

