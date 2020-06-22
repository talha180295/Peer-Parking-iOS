// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   var privateParkingModel = try? newJSONDecoder().decode(PrivateParkingModel.self, from: jsonData)

import Foundation

// MARK: - PrivateParkingModel
struct PrivateParkingModel: Codable {
    var id, sellerID, vehicleType, parkingSubType: Int?
    var title: String?
    var status: Int?
    var initialPrice: Double?
    var isNegotiable, isAlways: Bool?
    var address, latitude, longitude, image: String?
    var note, createdAt, updatedAt, deletedAt: String?
    var vehicleTypeText, parkingSubTypeText: String?
    var parkingType, tempParkingID: Int?
    var imageURL: String?
    var seller: Seller?
    var slots: [Slot]?

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
    var id, parkingID, day: Int?
    var startAt, endAt, createdAt, updatedAt: String?
    var deletedAt: String?

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

