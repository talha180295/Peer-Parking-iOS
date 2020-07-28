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
    
    
    static func serverRequest<T:Decodable>(url:URLRequestConvertible,path:String, body:[String:Any]? = nil ,dec:T.Type,completion:@escaping (T? ,Error?)->Void) {
        
        
        
       
        refreshTokenRequest(completion:{
            response in
            print("***************** RefreshToken Response Start ********************")
            print(response)
            print("***************** RefreshToken Response End ********************\n")
            if Helper().IsUserLogin() == true && response.result.value == nil {
                print("No response")
                
                //            SharedHelper().hideSpinner(view: self.view)
                return
            }
            else{
                print("***************** Requst Start \(path) ********************")
                print("url==\(try! url.asURLRequest())")
                print("Headers: \(url.urlRequest?.allHTTPHeaderFields ?? [:])")
//                print("Body: \(url.urlRequest?.httpBody?.description ?? "")")
                print("Body: \(body ?? [:])")
                print("***************** Requst End \(path) ********************\n")
                
                Alamofire.request(url).responseJSON { (response) in
                    
                    print("***************** Response Start \(path) ********************")
                    print(response)
                    print("***************** Response End \(path) ********************\n")
                    print(response.response?.statusCode ?? 0)
                    if(response.response?.statusCode ?? 0 >= 200 && response.response?.statusCode ?? 0  <= 299 || response.response?.statusCode ?? 0 == 404){
                        
                        if(response.result != nil)
                        {
                            if response.result.isSuccess {
                                
                                
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
                            else{
                                
                                completion(nil,response.error!)
                            }
                        }
                        
                        
                    }
                    else if(response.response?.statusCode ?? 0 == 401){
                        
                        //refresh Token
                        completion(nil,nil)
                    }
                    else{
                        completion(nil,response.error)
                    }
                }
            }
            
        })
        
    }
    
    
    
    
    static func refreshTokenRequest(completion: @escaping (_ result: DataResponse<Any>) -> Void){
        
        //        let url = APIRouter.refresh
        //        let decoder = ResponseData<RefreshTokenModel>.self
        
        //        print("token=\(String(describing: UserDefaults.standard.string(forKey: APP_CONSTANT.ACCESSTOKEN)))")
        //        String(describing: UserDefaults.standard.string(forKey: APP_CONSTANT.ACCESSTOKEN))
        
        var auth_value : String = UserDefaults.standard.string(forKey: APP_CONSTANT.ACCESSTOKEN) ?? ""
        
        
        auth_value = "bearer " + auth_value
        
        
        let headers: HTTPHeaders = [
            "Authorization" : auth_value
        ]
        
        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.REFRESH_TOKEN
        
        
        print("refresh url \(url)")
        print("refresh header \(auth_value)")
        
        Alamofire.request(url, method: .post, parameters: nil, headers:headers).validate(contentType: ["application/json","text/html"]).responseJSON { (response) in
            
            print(response.response?.statusCode ?? 0)
            
            
            
            switch response.result {
            case .success:
                let responseData = response.result.value as! NSDictionary
                let uData = responseData["data"] as! NSDictionary
                let userData = uData["user"] as! NSDictionary
                
                let auth_token = userData[APP_CONSTANT.ACCESSTOKEN] as! String
                
                UserDefaults.standard.set(auth_token, forKey: APP_CONSTANT.ACCESSTOKEN)
                
                completion(response)
                break
            case .failure(let error):
                print(error)
                completion(response)
            }
            //            if(response.response?.statusCode ?? 0 >= 200 && response.response?.statusCode ?? 0  <= 299){
            //
            //                if response.result.isSuccess {
            //
            //                    if let jsonData = response.data{
            //                        let response = try! JSONDecoder().decode(decoder.self, from: jsonData)
            //
            ////                        print(response.data?.user?.accessToken)
            //
            //
            //                    }
            //
            //                }
            //                else{
            //
            //                }
            //            }
            //            else if(response.response?.statusCode ?? 0 == 401){
            //
            //
            //            }
        }
    }
    
    
    private func ifUserlogedIN(){
        
        
    }
}
