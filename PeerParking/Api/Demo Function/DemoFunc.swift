//
//  DemoFunc.swift
//  PeerParking
//
//  Created by Apple on 14/01/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import Foundation
import Alamofire

class DemoFunc {
    
    let params:[String:Any] = [
        "parking_id": 0,
        "buyer_id": 0,
        "status": 0,
        "offer": 0,
        "direction": 0
    ]
    
    func postBargainingOffer(params:[String:Any]){
        
        Helper().RefreshToken { response in
            
            print(response)
            if response.result.value == nil {
                print("No response")
                
                return
            }
            else{
                
                Alamofire.request(APIRouter.postBargainingOffer(params)).responsePost{ response in
                    
                    switch response.result {
                    case .success:
                        if response.result.value?.success ?? false{
                            
                            print("val=\(response.result.value?.message ?? "-")")
                            
                        }
                        else{
                            print("Server Message=\(response.result.value?.message ?? "-" )")
                            
                        }
                        
                    case .failure(let error):
                        print("ERROR==\(error)")
                    }
                }
                
            }
        }
        
    }
    
    func postParking(params:[String:Any]){
        
        Helper().RefreshToken { response in
            
            print(response)
            if response.result.value == nil {
                print("No response")
                
                return
            }
            else{
                
                Alamofire.request(APIRouter.postParking(params)).responsePost{ response in
                    
                    switch response.result {
                    case .success:
                        if response.result.value?.success ?? false{
                            
                            print("val=\(response.result.value?.message ?? "-")")
                            
                        }
                        else{
                            print("Server Message=\(response.result.value?.message ?? "-" )")
                            
                        }
                        
                    case .failure(let error):
                        print("ERROR==\(error)")
                    }
                }
                
            }
        }
        
    }


    func getParkings(){
        
        let params:[String:Any]  = [ : ]
        
        
        Helper().RefreshToken { response in
            
            print(response)
            if response.result.value == nil {
                print("No response")
                
                return
            }
            else{
                
                Alamofire.request(APIRouter.getParkings(params)).responseParking{ response in
                    
                    switch response.result {
                    case .success:
                        if response.result.value?.success ?? false {
                            
                            if let val = response.result.value?.data {
                                //                print("bData=\(bData)")
        //                        self.pData = val
        //                        self.myTableView.reloadData()
                            }
                            
                        }
                        else{
                            print("Server Message=\(response.result.value?.message ?? "-" )")
                            
                        }
                        
                    case .failure(let error):
                        print("ERROR==\(error)")
                    }
                }
            }
        }
    }


    func getBargainings(){
        
        let params:[String:Any]  = [ : ]
        
        Alamofire.request(APIRouter.getBargainings(params)).responseBargaining{ response in
            
            switch response.result {
            case .success:
                if response.result.value?.success ?? false {
                    
                    if let val = response.result.value?.data {
                        //                print("bData=\(bData)")
//                        self.bData = val
//                        self.myTableView.reloadData()
                    }
                    
                }
                else{
                    print("Server Message=\(response.result.value?.message ?? "-" )")
                    
                }
                
            case .failure(let error):
                print("ERROR==\(error)")
            }
        }
    }
    
    
    func getParkingsNew(){
        
        let params:[String:Any]  = [ "is_schedule" : 1 ]
        
        
        APIClient.serverRequest(url: APIRouter.getParkings(params), dec: ResponseData<Parking>.self) { (response,error) in
            
            if(response != nil){
                if (response?.success) != nil {
                    //Helper().showToast(message: "Succes=\(success)", controller: self)
                    if let val = response?.data {
                    
                        print(val)
                    }
                }
                else{
                    //Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                }
            }
            else if(error != nil){
                //Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
            }
            else{
                //Helper().showToast(message: "Nor Response and Error!!", controller: self)
            }
            
        }
        
    }
    
    
    


}
