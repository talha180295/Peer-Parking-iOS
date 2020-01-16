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
    case postParking([String:Any])
    case postBargainingOffer([String:Any])
    
    
    private var accessToken:String{
        return  UserDefaults.standard.string(forKey: "auth_token") ?? ""
    }
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        
        case .getParkingsWithoutToken,.getParkings,.getParkingsById,.getBargainings:
            return .get
            
        case .postParking,.postBargainingOffer:
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
        


        let encoding = URLEncoding(destination: .queryString)
        return try encoding.encode(urlRequest, with: parameters)
//        return urlRequest
    }
}
