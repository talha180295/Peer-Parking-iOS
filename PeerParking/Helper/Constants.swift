//
//  Constants.swift
//  PeerParking
//
//  Created by Apple on 23/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import Foundation
import UIKit

struct Key{
    
    static let DeviceType = "iOS"
    
    struct Google{
        static let placesKey = "AIzaSyCkoOvnd1_eougL23wAx7DP65C_duaJRjQ"//for photos
        
        static let placesKey2 = "AIzaSyAdxovNnHIWKOKQcgn6H0PhwZsFCMfXjnQ"
        
        static let serverKey = "some key here"
    }
    
    
}
struct APP_CONSTANT {
    
    
    struct API {
       
        //BASE URL FOR PEER PARKING
        static let BASE_URL = "http://peer-parking.apps.fomarkmedia.com/api/v1/"
//        static let BASE_URL = "http://peer-parking.servstaging.com/api/v1/"
        
        
        //STAGING_BASE_URL
        static let STAGING_BASE_URL = "http://peer-parking.servstaging.com/api/v1/"
        //SOCIAL LOGIN API
        static let SOCIAL_LOGIN = "social_login"
        //GET /parkings API
        static let POST_PARKING = "parkings"
        
        
        
        //GET /parkings-without-token
        static let GET_PARKING_WITHOUT_TOKEN = "parkings-without-token"
        
        static let ASSIGN_BUYER = "assign-buyer"
        
        static let REFRESH_TOKEN = "refresh"
        
        static let LOGOUT = "logout"
        
        
        static let REVIEWS = "reviews"
        
 
        
    }
   
    
    static let DATE_TIME_FORMAT = "yyyy-MM-dd hh:mm:ss"
    
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
    
  
    static  let imgData : Data = (UIImage.init(named: "bg_img")?.pngData())!
   // static var  PARKING_POST_DETAILS:[String : Any] = ["vehicle_type": 0, "parking_type": 0, "status": 10, "initial_price": 0.0, "final_price": 0.0, "start_at": "string", "end_at": "string", "address": "string", "longitude": "string", "latitude": "string", "is_negotiable": false, "image": imgData, "note": "string", "parking_hours_limit": 0.0, "parking_allowed_until": "string", "parking_extra_fee" : 0.0,"parking_extra_fee_unit": NSNull(), "is_resident_free": false]
    
    static var  PARKING_POST_DETAILS:[String : Any] = [:]
    
    static var PARKING_POST_DONE = false
}


