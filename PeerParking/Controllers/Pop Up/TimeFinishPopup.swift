//
//  TimeFinishPopup.swift
//  PeerParking
//
//  Created by Apple on 31/01/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class TimeFinishPopup: UIViewController {

     var parking_details:Parking!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func extendBtn(_ sender: UIButton) {
    }
    

    @IBAction func cancelBtn(_ sender: UIButton) {
        
        let pId = self.parking_details.id
      
//        print(pId)
        cancelParkking(id: self.parking_details.id ?? 0)
        
    }
    
    func cancelParkking(id:Int){
        
        
        APIClient.serverRequest(url: APIRouter.cancelSellerParking(id: id), path: APIRouter.cancelSellerParking(id: id).getPath(), dec: PostResponseData.self) { (response, error) in
            
            if(response != nil){
                if (response?.success) != nil {
                    Helper().showToast(message: "\(response?.message ?? "-")", controller: self)
                   
                    Helper.deleteChatAndRequests(parkingModel1: self.parking_details)
                    
                }
                else{
                    Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                }
            }
            else if(error != nil){
                Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
            }
            else{
                Helper().showToast(message: "Nor Response and Error!!", controller: self)
            }
            
            Helper().presentOnMainScreens(controller: self, index: 1)
        }
    }
}
