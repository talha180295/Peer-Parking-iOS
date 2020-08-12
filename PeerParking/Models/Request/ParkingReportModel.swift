//
//  ParkingReportModel.swift
//  PeerParking
//
//  Created by APPLE on 8/12/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

struct ParkingReportModel: Codable {
    let reason: Int?
    let parking_id: Int?
    let description:String?
    let parking_type: Int?
    
}
