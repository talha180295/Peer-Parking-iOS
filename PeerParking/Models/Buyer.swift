// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let buyer = try? newJSONDecoder().decode(Buyer.self, from: jsonData)

import Foundation

// MARK: - Buyer
struct Buyer: Codable {
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
