//
//  Constants.swift
//  PeerParking
//
//  Created by Apple on 23/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import Foundation

struct Key{
    
    static let DeviceType = "iOS"
    
    struct Google{
        static let placesKey = "AIzaSyCkoOvnd1_eougL23wAx7DP65C_duaJRjQ"//for photos
        
        static let placesKey2 = "AIzaSyAdxovNnHIWKOKQcgn6H0PhwZsFCMfXjnQ"
        
        static let serverKey = "some key here"
    }
    
    
}
struct APP_CONSTANT {
    
    
    static let BASE_URL = "http://peer-parking.apps.fomarkmedia.com/api/v1/"
    static let SOCIAL_LOGIN = "social_login"
    
    
    // VEHICLE_TYPES
    
    struct VEHICLE_TYPES{
        
        static let MINI = 10
        static let FAMILY = 20
        static let SUV = 30
        static let BUS = 40
    }
    
    // PARKING_TYPES
    struct PARKING_TYPES{
        
        static let PAR_LOT = 10
        static let ST_PARKING = 20
        static let PVT_PARKING = 30
        
    }
}


struct GLOBAL_VAR {
    
    
    static var  PARKING_POST_DETAILS:[String : Any] = ["vehicle_type": 0, "parking_type": 0, "status": 10, "initial_price": 0.0, "final_price": 0.0, "start_at": "string", "end_at": "string", "address": "string", "longitude": "string", "latitude": "string", "is_negotiable": false, "image": "string", "note": "string", "parking_hours_limit": 0.0, "parking_allowed_until": "string", "parking_extra_fee_unit": 0.0, "is_resident_free": false]
    
    
}


