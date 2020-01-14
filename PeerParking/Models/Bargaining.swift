// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let bargainings = try? newJSONDecoder().decode(Bargainings.self, from: jsonData)

import Foundation



// MARK: - Bargainings
struct Bargaining: Codable {
    let id, parkingID, buyerID, status: Int?
    let offer: Double?
    let direction: Int?
    let createdAt, updatedAt, deletedAt, statusText: String?
    let buyer: Buyer?
    let seller: Seller?
    let parking: Parking?
    
    enum CodingKeys: String, CodingKey {
        case id
        case parkingID = "parking_id"
        case buyerID = "buyer_id"
        case status, offer, direction
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case statusText = "status_text"
        case buyer,parking
        case seller
    }
}



