//
//  DirectionApi.swift
//  PeerParking
//
//  Created by Apple on 11/02/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import Foundation

// MARK: - DirectionAPI
struct DirectionAPI: Codable {
  
    let routes: [Route]?
   

}

// MARK: - Route
struct Route: Codable {
    let bounds: Bounds?
    let copyrights: String?
    let legs: [Leg]?
    let overviewPolyline: Polyline?
    let summary: String?

    enum CodingKeys: String, CodingKey {
        case bounds, copyrights, legs
        case overviewPolyline = "overview_polyline"
        case summary
    }
}

// MARK: - Bounds
struct Bounds: Codable {
    let northeast, southwest: Coordinates?
}

// MARK: - Northeast
struct Coordinates: Codable {
    let lat, lng: Double?
}

// MARK: - Leg
struct Leg: Codable {
    let distance, duration: Distance?
    let endAddress: String?
    let endLocation: Location?
    let startAddress: String?
    let startLocation: Location?
    let steps: [Step]?

    enum CodingKeys: String, CodingKey {
        case distance, duration
        case endAddress = "end_address"
        case endLocation = "end_location"
        case startAddress = "start_address"
        case startLocation = "start_location"
        case steps
        
    }
}

// MARK: - Distance
struct Distance: Codable {
    let text: String?
    let value: Int?
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double?
}

// MARK: - Step
struct Step: Codable {
    let distance, duration: Distance?
    let endLocation: Location?
    let htmlInstructions: String?
    let polyline: Polyline?
    let startLocation: Location?
    let travelMode, maneuver: String?

    enum CodingKeys: String, CodingKey {
        case distance, duration
        case endLocation = "end_location"
        case htmlInstructions = "html_instructions"
        case polyline
        case startLocation = "start_location"
        case travelMode = "travel_mode"
        case maneuver
    }
}

// MARK: - Polyline
struct Polyline: Codable {
    let points: String?
}
