//
//  ApiClient.swift
//  PeerParking
//
//  Created by Apple on 27/01/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//


import Foundation
import Alamofire

class APIClient {
    
    static func getDataRequest(url:URLRequestConvertible,completion:@escaping (DataResponse<Any>)->Void) {
        
        print("url==\(String(describing: try? url.asURLRequest()))")
        Alamofire.request(url).responseJSON { (response) in
            
            completion(response)
            
            
        }
        
    }
    
    
    static func serverRequest<T:Decodable>(url:URLRequestConvertible,dec:T.Type,completion:@escaping (T? ,Error?)->Void) {
        
        print("url==\(String(describing: try? url.asURLRequest()))")
        
        
        Alamofire.request(url).responseJSON { (response) in
            
            
            if response.result.isSuccess {
                
                if let jsonData = response.data{
                    let response = try! JSONDecoder().decode(dec.self, from: jsonData)
                    
                    
                    completion(response, nil)
                }
                
            }
            else{
                
                completion(nil,response.error!)
            }
        }
    }
    

}
