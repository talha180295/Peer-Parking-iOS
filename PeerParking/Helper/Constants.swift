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
    
    static let public_step_text = ["Details","Price","When","Limitations","Location","Image"]
    static let private_step_text = ["Details","Price","When","Location","Image"]
//    static let PAGE_URL = "http://peer-parking.apps.fomarkmedia.com/pages/"
    static let PAGE_URL = "http://peer-parking.demo.servstaging.com/pages/"
    static let ACCESSTOKEN = "access_token"
    
    struct API {
       
        //BASE URL FOR PEER PARKING
//        static let BASE_URL = "http://peer-parking.apps.fomarkmedia.com/api/v1/"
        
      static let BASE_URL = "http://peer-parking.demo.servstaging.com/api/v1/"
        
        //STAGING_BASE_URL
        static let STAGING_BASE_URL = "http://peer-parking.demo.servstaging.com/api/v1/"
        
        //SOCIAL LOGIN API
        static let SOCIAL_LOGIN = "social_login"
        
        //LOGIN API
        static let LOGIN = "login"
        
        //GET /parkings API
        static let POST_PARKING = "parkings"
        
        static let POST_PRIVATE_PARKING = "private-parkings"
        
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
    static let SHORT_DATE_TIME_FORMAT = "yyyy-MM-dd"
                                    
    // VEHICLE_TYPES
    
    struct VEHICLE_TYPES{
        
        static let vehicle_type = "vehicle_type"
        static let MINI = 10
        static let FAMILY = 20
        static let SUV = 30
        static let BUS = 40
    }
    
    // PARKING_TYPES
    struct PARKING_TYPES{
        
        static let parking_type = "parking_type"
        static let PUBLIC_CONST = 10
        static let PRIVATE_CONST = 20
        
    }
    
    // PARKING_SUB_TYPES
    struct PARKING_SUB_TYPES{
        
        static let parking_sub_type = "parking_sub_type"
        static let LOT_CONST = 10
        static let STREET_CONST = 20
        
    }
    
    struct DIRECTION{
        
        static let SELLER_TO_BUYER = 10
        static let BUYER_TO_SELLER = 20
        
    }
}



struct GLOBAL_VAR {
    
  
    static  let imgData : Data = (UIImage.init(named: "bg_img")?.pngData())!
   // static var  PARKING_POST_DETAILS:[String : Any] = ["vehicle_type": 0, "parking_type": 0, "status": 10, "initial_price": 0.0, "final_price": 0.0, "start_at": "string", "end_at": "string", "address": "string", "longitude": "string", "latitude": "string", "is_negotiable": false, "image": imgData, "note": "string", "parking_hours_limit": 0.0, "parking_allowed_until": "string", "parking_extra_fee" : 0.0,"parking_extra_fee_unit": NSNull(), "is_resident_free": false]
    
    static var  PARKING_POST_DETAILS:[String : Any] = [:]
    static var PRIVATE_PARKING_MODEL : [String : Any] = [:]
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
    
    static let  STATUS_ACCEPTED = 10
    static let  STATUS_REJECTED = 20
    static let  STATUS_COUNTER_OFFER = 30
    
    static let  SELLER_TO_BUYER = 10
    static let  BUYER_TO_SELLER = 20

}




struct ParkingSubTypeText{
    
    static let  PARKING_LOT = "Parking Lot"
    static let  STRRET_PARKING = "Street Paking"
    static let  PRIVATE_PARKING = "Private Parking"
}

enum ParkingSubTypesEnum:Int{
    
    case PARKING_LOT     = 10
    case STRRET_PARKING  = 20
    case PRIVATE_PARKING = 30
    
    func getString() -> String {
        switch self {
        case .PARKING_LOT:
            return ParkingSubTypeText.PARKING_LOT
        case .STRRET_PARKING:
            return ParkingSubTypeText.STRRET_PARKING
        case .PRIVATE_PARKING:
            return ParkingSubTypeText.PRIVATE_PARKING
            
        }
    }
    
  
}


struct VehicleTypeText{
    
    static let  SUPER_MINI = "Super Mini"
    static let  FAMILY = "Family"
    static let  SUV = "SUV"
    static let  BUS = "Bus"
    
    
}

enum VehicleTypeEnum:Int {
    
    case    SUPER_MINI = 10
    case    FAMILY     = 20
    case    SUV        = 30
    case    BUS        = 40

    func getString() -> String {
        switch self {
        case .SUPER_MINI:
            return VehicleTypeText.SUPER_MINI
        case .FAMILY:
            return VehicleTypeText.FAMILY
        case .SUV:
            return VehicleTypeText.SUV
        case .BUS:
            return VehicleTypeText.BUS
            
        }
    }
}
enum ParkingStatus: Int{
    
    case  AVAILABLE  = 10
    case  BOOKED     = 20
    case  PARKED     = 30
    case  CANCEL     = 40
    case  UNAVAILABLE    = 50
    case  NAVIGATING = 60
    
}

enum Action:Int{
    
    case Posted = 10;
    case Booked = 20;

}


enum Transaction_Types:Int{
    
    case CREDIT = 10;  // Sold
    case DEBIT  = 20;  // Bought
//    const EXTRA_FEE_NULL = null;
}
   

enum Type:Int{
    
    case VIRTUAL = 10;     //  In App Transaction
    case GATEWAY = 20;  //  Top-Up and Withdraw
}
public class ParkingType {
    public static let  PARKING_TYPE_PUBLIC = 10;
    public static let PARKING_TYPE_PRIVATE = 20;

}
 
