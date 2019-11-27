//
//  FeedbackVC.swift
//  PeerParking
//
//  Created by Apple on 24/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import Cosmos
import EzPopup
import Alamofire
import HelperClassPod

class FeedbackVC: UIViewController {

    @IBOutlet weak var emoji: UIImageView!
    @IBOutlet weak var rating_bar: CosmosView!
    @IBOutlet weak var label: UILabel!
    
    
    var p_id:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Called when user finishes changing the rating by lifting the finger from the view.
        // This may be a good place to save the rating in the database or send to the server.
        rating_bar.didFinishTouchingCosmos = { rating in
            
            print("Rating=\(rating)")
            if(rating >= 3.0){
                self.emoji.image = UIImage(named: "happy")
                self.label.text = "Ok Ok!"
            }
            else{
                self.emoji.image = UIImage(named: "sad")
                self.label.text = "No No!"
            }
        }
    }
    
    @IBAction func share_btn(_ sender: UIButton) {
        
        
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "parkedVC")
//
//        self.show(vc, sender: sender)
        
        if let id = p_id {
            
            print("p_id==\(id)")
            post_rating(p_id: p_id, rating: rating_bar.rating){
                
                self.wantToSellParking()
            }
            
        }
       
        
        
    }
    
    func wantToSellParking(){
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Sell_parking_popup")
        
        Helper().popUp(controller: vc, view_controller: self)
    }
    
   
    func post_rating(p_id:Int,rating:Double,completion: @escaping () -> Void){
        
       
        
        var params:[String:Any] = [
            
            "parking_id": p_id,
            "rating": rating
            
        ]
        
        //params.updateValue("hello", forKey: "new_val")
        let auth_value =  "Bearer \(UserDefaults.standard.string(forKey: "auth_token")!)"
        let headers: HTTPHeaders = [
            "Authorization" : auth_value
        ]
        print("==0params=\(params)")
        print("==0headers=\(headers)")
        
        //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customVC")
        //        self.present(vc, animated: true, completion: nil)
        
        
        let url = "\(APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.ASSIGN_BUYER)/\(p_id)"
        
        print("url--\(url)")
        
        
        SharedHelper().Request_Api(url: url, methodType: .post, parameters: params, isHeaderIncluded: true, headers: headers){ response in
            
            print("response>>>\(response)")
            
            if response.result.value == nil {
                print("No response")
                
                SharedHelper().showToast(message: "Internal Server Error", controller: self)
                return
            }
            else {
                let responseData = response.result.value as! NSDictionary
                let status = responseData["success"] as! Bool
                if(status)
                {
                    let message = responseData["message"] as! String
                    //let uData = responseData["data"] as! NSDictionary
                    //let userData = uData["user"] as! NSDictionary
                    //self.saveData(userData: userData)
                    //                    SharedHelper().hideSpinner(view: self.view)
                    //                     UserDefaults.standard.set("yes", forKey: "login")
                    //                    UserDefaults.standard.synchronize()
                    SharedHelper().showToast(message: message, controller: self)
                    
                    completion()
                    //self.after_signin()
                }
                else
                {
                    let message = responseData["message"] as! String
                    SharedHelper().showToast(message: message, controller: self)
                    //   SharedHelper().hideSpinner(view: self.view)
                }
            }
        }
    }

}
