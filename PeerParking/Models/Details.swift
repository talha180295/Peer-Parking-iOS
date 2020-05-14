// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let details = try? newJSONDecoder().decode(Details.self, from: jsonData)

import Foundation

// MARK: - Details
struct Details: Codable {
    let id: Int?
    let firstName, lastName: String?
    let averageRating: Double?
    let phone: String?
    let address: String?
    let image: String?
    let isVerified, emailUpdates, isSocialLogin: Int?
    let wallet: Double?
    let imageURL: String?
    let fullName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case averageRating = "average_rating"
        case phone, address, image
        case isVerified = "is_verified"
        case emailUpdates = "email_updates"
        case isSocialLogin = "is_social_login"
        case wallet
        case imageURL = "image_url"
        case fullName = "full_name"
    }
}
//
//// MARK: - Details
//struct Details: Codable {
//    let id, externalAccountID: Int?
//    let firstName, lastName ,stripeUserID: String?
//    let averageRating, wallet: Double?
//    let phone, address, image: String?
//    let isVerified, emailUpdates, isSocialLogin: Int?
//    let imageURL: String?
//    let fullName: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case stripeUserID = "stripe_user_id"
//        case externalAccountID = "external_account_id"
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case averageRating = "average_rating"
//        case phone, address, image
//        case isVerified = "is_verified"
//        case emailUpdates = "email_updates"
//        case isSocialLogin = "is_social_login"
//        case wallet
//        case imageURL = "image_url"
//        case fullName = "full_name"
//    }
//}
