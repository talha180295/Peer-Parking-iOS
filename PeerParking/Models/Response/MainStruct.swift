//
//  MainStruct.swift
//  ObjectMapDemo
//
//  Created by Apple on 13/01/2020.
//  Copyright © 2020 Talha. All rights reserved.
//

import Foundation
import Alamofire

//struct ResponseDataArray <T:Codable> : Codable {
//    var success:Bool
//    var data:[T]?
//    var message:String
//}


struct ResponseData <T:Codable> : Codable {
    var success:Bool
    var data:T?
    var message:String
}

struct PostResponseData: Codable {
    var success:Bool
    var message:String
}


// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try JSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseBargaining(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ResponseData<[Bargaining]>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseParking(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ResponseData<[Parking]>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    
    @discardableResult
    func responsePost(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<PostResponseData>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseRefreshTokenModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<RefreshTokenModel>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responsePostBargainigOffer(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ResponseData<[PostBargainigOfferModel]>>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}


