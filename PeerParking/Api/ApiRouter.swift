//
//  ApiRouter.swift
//  ObjectMapDemo
//
//  Created by Apple on 09/01/2020.
//  Copyright © 2020 Talha. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    
    
    case getParkingsWithoutToken([String:Any])
    case getParkings([String:Any])
    case getParkingsById(id:Int)
    case getBargainings([String:Any])
    case getBargainingsById(id:Int)
    case postParking([String:Any])
    case postBargainingOffer([String:Any])
    case addUserCard([String:Any])
    case me
    case refresh
    case cancelSellerParking(id:Int)
    case cancelBuyerParking(id:Int)
    case assignBuyer(id:Int,Data)
    case getTransactions([String:Any])
    case getPrivateParkings([String:Any])
    case updateParking(id:Int,Data)
    case createTempParking(Data)
    case sendNotification(Data)
    case loginUser(Data)
    case chargeCard([String:Any])
    case addExternalCard([String:Any])
    
    
    private var accessToken:String{
        return  UserDefaults.standard.string(forKey: APP_CONSTANT.ACCESSTOKEN) ?? ""
    }
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
            
        case .getParkingsWithoutToken,.getParkings,.getParkingsById,.getBargainings,.getBargainingsById , .getTransactions ,.getPrivateParkings:
            return .get
            
        case .postParking,.postBargainingOffer,.addUserCard,.me,.refresh, .cancelSellerParking, .assignBuyer, .updateParking, .cancelBuyerParking, .createTempParking, .sendNotification, .loginUser, .chargeCard, .addExternalCard:
            return .post
            
        }
        
    }
    
    // MARK: - Path
    private var path: String {
        
        switch self {
            
        case .getParkingsWithoutToken:
            return "parkings-without-token"
        case .postParking:
            return "parkings"
        case .getParkings(_):
            return "parkings"
        case .getParkingsById(let id):
            return "parkings/\(id)"
        case .getBargainings(_):
            return "bargainings"
        case .postBargainingOffer:
            return "bargainings"
        case .addUserCard:
            return "user-cards"
        case .me:
            return "me"
        case .refresh:
            return "refresh"
        case .cancelSellerParking(let id):
            return "cancel-seller-parking/\(id)"
        case .assignBuyer(let id, _):
            return "assign-buyer/\(id)"
        case .getBargainingsById(let id):
            return "bargainings/\(id)"
        case .getTransactions:
            return "transactions"
        case .getPrivateParkings:
            return "private-parkings"
        case .updateParking(let id, _):
            return "update-parking/\(id)"
        case .cancelBuyerParking(let id):
            return "cancel-buyer-parking/\(id)"
        case .createTempParking(_):
            return "parkings"
        case .sendNotification(_):
            return "send-notification"
        case .loginUser(_):
            return APP_CONSTANT.API.LOGIN
        case .chargeCard(_):
            return APP_CONSTANT.API.ChargeCard
        case .addExternalCard(_):
            return "external-cards"
           
            
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
            
        case .getParkingsWithoutToken(let params):
            return (params)
        case .postParking(let params):
            return (params)
        case .getParkings(let params):
            return (params)
        case .getParkingsById:
            return nil
        case .getBargainings(let params):
            return (params)
        case .postBargainingOffer(let params):
            return (params)
        case .addUserCard(let params):
            return (params)
        case .me:
            return nil
        case .refresh:
            return nil
        case .cancelSellerParking:
            return nil
        case .assignBuyer(_,_):
            return nil
        case .getBargainingsById:
            return nil
        case .getTransactions(let params):
            return (params)
        case .getPrivateParkings(let params):
            return (params)
        case .chargeCard(let params):
            return (params)
        case .updateParking, .cancelBuyerParking, .createTempParking, .sendNotification,.loginUser:
            return nil
        case .addExternalCard(let params):
            return (params)
            
            
            
        }
    }
    
    // MARK: - HTTPMethod
    private var urlEncoding: URLEncoding {
        switch self {
            
        case .assignBuyer, .updateParking, .createTempParking, .sendNotification , .loginUser:
            return .httpBody
        case .getParkingsWithoutToken, .postParking ,.getParkings, .getParkingsById, .postBargainingOffer, .addUserCard, .me, .refresh ,.cancelSellerParking ,.getBargainingsById ,.getTransactions ,.getPrivateParkings,.getBargainings ,.cancelBuyerParking, .addExternalCard:
            return .default
        case .chargeCard:
            return .queryString
        }
    }
    
    // MARK: - HTTPMethod
    private var body: Data? {
        switch self {
            
        case .assignBuyer(_,let data), .updateParking(_,let data), .createTempParking(let data), .sendNotification(let data) ,.loginUser(let data):
            return data
        case .getParkingsWithoutToken, .postParking ,.getParkings, .getParkingsById, .postBargainingOffer, .addUserCard, .me, .refresh ,.cancelSellerParking ,.getBargainingsById ,.getTransactions ,.getPrivateParkings, .getBargainings, .cancelBuyerParking,.chargeCard, .addExternalCard:
            return nil
            
        }
    }
    
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try APP_CONSTANT.API.BASE_URL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        //        urlRequest.allHTTPHeaderFields = ["Authorization" : K.AccessToken]
        
        urlRequest.httpBody = body
        
        return try urlEncoding.encode(urlRequest, with: parameters)
        //        let encoding = URLEncoding(destination: .queryString)
        //        return try encoding.encode(urlRequest, with: parameters)
        //        return urlRequest
    }
    
    public func getPath() -> String{
        return path
    }
}
