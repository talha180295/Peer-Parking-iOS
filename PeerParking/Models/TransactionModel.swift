//
//  TransactionModel.swift
//  PeerParking
//
//  Created by Apple on 27/02/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import Foundation

// MARK: - TransactionModel
struct TransactionModel: Codable {
    let id, parkingID, parentID, userID: Int?
    let gatewayTransactionID, transactionType, type, paymentStatus: Int?
    let amount, previousAmount, appMargin: Double?
    let currencyCode, createdAt, updatedAt, deletedAt: String?
    let typeText, transactionTypeText, paymentStatusText: String?

    enum CodingKeys: String, CodingKey {
        case id
        case parkingID = "parking_id"
        case parentID = "parent_id"
        case userID = "user_id"
        case gatewayTransactionID = "gateway_transaction_id"
        case transactionType = "transaction_type"
        case type
        case paymentStatus = "payment_status"
        case amount
        case previousAmount = "previous_amount"
        case appMargin = "app_margin"
        case currencyCode = "currency_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case typeText = "type_text"
        case transactionTypeText = "transaction_type_text"
        case paymentStatusText = "payment_status_text"
    }
}
