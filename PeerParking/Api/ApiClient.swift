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
            
            print(response)
            print(response.response?.statusCode ?? 0)
            if(response.response?.statusCode ?? 0 >= 200 && response.response?.statusCode ?? 0  <= 299){
                
                if response.result.isSuccess {
                    
                    if let jsonData = response.data{
//                         let response = try! JSONDecoder().decode(dec.self, from: jsonData)
                        do {
                            //here dataResponse received from a network request
                            if let jsonData = response.data{
                                let response = try JSONDecoder().decode(dec.self, from:jsonData) //Decode JSON Response Data
                               
                                completion(response, nil)
                            }
                        } catch let parsingError {
                            print("Error", parsingError)
                        }
                        
                        
                    }
                    
                }
                else{
                    
                    completion(nil,response.error!)
                }
            }
            else if(response.response?.statusCode ?? 0 == 401){
                
                //refresh Token
                completion(nil,nil)
            }
        }
    }
    
    
    static func refreshTokenRequest(){
        
        let url = APIRouter.refresh
        let decoder = ResponseData<RefreshTokenModel>.self
        
        Alamofire.request(url).responseJSON { (response) in
            
            print(response.response?.statusCode ?? 0)
            if(response.response?.statusCode ?? 0 >= 200 && response.response?.statusCode ?? 0  <= 299){
                
                if response.result.isSuccess {
                    
                    if let jsonData = response.data{
                        let response = try! JSONDecoder().decode(decoder.self, from: jsonData)
                        
//                        print(response.data?.user?.accessToken)
                        
                       
                    }
                    
                }
                else{
                    
                }
            }
            else if(response.response?.statusCode ?? 0 == 401){
                
               
            }
        }
    }

}
