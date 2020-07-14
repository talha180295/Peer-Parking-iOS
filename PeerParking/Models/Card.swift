// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let card = try? newJSONDecoder().decode(Card.self, from: jsonData)

import Foundation
//
//struct CardData: Codable{
//    
//    let card: [Card]?
//    
//}

// MARK: - Card
struct Card: Codable {
    let id, userID, type: Int?
    let stripeCardID: String?
    let externalAccountId: String?
    let lastFour: Int?
    let brand, country: String?
    let expMonth, expYear: Int?
    let createdAt, updatedAt, deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case userID = "user_id"
        case stripeCardID = "stripe_card_id"
        case externalAccountId = "external_account_id"
        case lastFour = "last_four"
        case brand, country
        case expMonth = "exp_month"
        case expYear = "exp_year"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}
