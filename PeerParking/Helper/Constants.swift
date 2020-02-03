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
        
        static let placesKey = "AIzaSyB9ppk-0eNcK42I5ykfreGWwgiUClqmMIs"
//        static let placesKey = "AIzaSyCkoOvnd1_eougL23wAx7DP65C_duaJRjQ"
        
//        static let placesKey2 = "AIzaSyAdxovNnHIWKOKQcgn6H0PhwZsFCMfXjnQ"
        
        static let serverKey = "some key here"
    }
    
}

struct APP_CONSTANT {
    
    
    static let PAGE_URL = "http://peer-parking.apps.fomarkmedia.com/pages/"
    
    struct API {
       
        //BASE URL FOR PEER PARKING
        static let BASE_URL = "http://peer-parking.apps.fomarkmedia.com/api/v1/"
        
//      static let BASE_URL = "http://peer-parking.servstaging.com/api/v1/"
        
        //STAGING_BASE_URL
        static let STAGING_BASE_URL = "http://peer-parking.servstaging.com/api/v1/"
        //SOCIAL LOGIN API
        static let SOCIAL_LOGIN = "social_login"
        //LOGIN API
        static let LOGIN = "login"
        //GET /parkings API
        static let POST_PARKING = "parkings"
        
        //GET /parkings-without-token
        static let GET_PARKING_WITHOUT_TOKEN = "parkings-without-token"
        
        static let GET_PARKING_WITH_TOKEN = "parkings"
        
        static let ASSIGN_BUYER = "assign-buyer"
        
        static let REFRESH_TOKEN = "refresh"
        
        static let LOGOUT = "logout"
        
        static let REVIEWS = "reviews"
        
        static let BARGAININGS = "bargainings"
        
        
        static let SIGN_UP = "register"
      static let FORGET_PASS = "forget-password?email="
        static let VERIFY_CODE = "verify-reset-code?verification_code="
 
        static let RESET_PASS = "reset-password?email="
        static let CHANGE_PASS = "change-password?current_password="
        static let ME = "me"
        static let UPDATE = "profile"
    }
   
    
    static let DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss"
                                    
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




enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}


struct Nulls {
    static let nullInt:Int = 0
    static let nullString = "-"
    static let nullDouble:Double = 0.0
}

struct ParkingConst{



    
    static let  BARGAINING_STATUS_ACCEPTED = 10
    static let  BARGAINING_STATUS_REJECTED = 20
    static let  BARGAINING_STATUS_COUNTER_OFFER = 30
    static let  BARGAINING_SELLER_TO_BUYER = 10
    static let  BARGAINING_BUYER_TO_SELLER = 20

}


 
struct ParkingTypes{
    
    static let  PARKING_LOT = 10
    static let  STRRET_PARKING = 20
    static let  PRIVATE_PARKING = 30
  
    static let  PARKING_LOT_TEXT = "Pakring Lot"
    static let  STRRET_PARKING_TEXT = "Street Parking"
    static let  PRIVATE_PARKING_TEXT = "Private Parking"
    
}

struct VehicleType{

    static let  SUPER_MINI = 10
    static let  FAMILY = 20
    static let  SUV = 30
    static let  BUS = 40
    
    static let  SUPER_MINI_TEXT = "Super Mini"
    static let  FAMILY_TEXT = "Family"
    static let  SUV_TEXT = "SUV"
    static let  BUS_TEXT = "Bus"
}

enum ParkingStatus: Int{
    
    case  AVAILABLE  = 10
    case  BOOKED     = 20
    case  PARKED     = 30
    case  CANCEL     = 40
    case  PENDING    = 50
    case  NAVIGATING = 60
    
}


