//
//  FBPopup.swift
//  PeerParking
//
//  Created by Apple on 23/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import HelperClassPod
import FacebookLogin
import FacebookCore
import Alamofire
import EzPopup

class FBPopup: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func fb_login(){
        
        let loginManager = LoginManager()
        if let accessToken = AccessToken.current{
            print(accessToken)
            loginManager.logOut()
        }
        loginManager.logIn(permissions: [.publicProfile,.email], viewController: self) { loginResult in
            switch loginResult {
                case .failed(let error):
                print(error)
                case .cancelled:
                print("User cancelled login.")
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                // let facebookAPIManager = FacebookAPIManager(accessToken: accessToken)
                if((AccessToken.current) != nil){
                    GraphRequest(graphPath: "me", parameters: ["fields": "id,email,name, first_name, last_name, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        
                        let fbDetails = result as! NSDictionary
                        print("fbDetails=\(fbDetails)")
                        //let name = fbDetails["first_name"] as? String
                        //let lname = fbDetails["last_name"] as? String
                        let fullName = fbDetails["name"] as? String
                        let email = fbDetails["email"] as? String
                        let UserId = fbDetails["id"] as? String
                        let picture1: NSDictionary = fbDetails["picture"] as! NSDictionary
                        let data1: NSDictionary = picture1["data"] as! NSDictionary
                        let url1: String = data1["url"] as! String
                        print(accessToken.tokenString)
                        self.LoginSocial(platform: "facebook", client_id: UserId!, token: accessToken.tokenString, username: fullName!, email: email!,imageUrl: url1)
                        print(result)
                    }
                        print(error)
                    })
                }
            }
            
        }
    
    }
    
    
    func LoginSocial(platform : String,client_id : String,token : String,username : String,email : String,imageUrl : String) {
        
     //   let FCMToken :String = UserDefaults.standard.string(forKey: "FCMToken")!
        //        var strRole="2"
        //
        // SharedHelper().showSpinner(view: self.view)
        let deviceToken = "ios"
        //  SharedHelper().showSpinner(view: self.view)
        // let deviceToken : String?
        let param = [
        "platform" : platform,
        "client_id" : client_id,
        "token" : token,
        "username" : username,
        "email" : email,
        "device_token" : "FCMToken",
        "device_type" : deviceToken,
        "image" : imageUrl
        ]
        print(param)
        let headers: HTTPHeaders = [
            "Authorization" : ""
        ]
        let url = APP_CONSTANT.BASE_URL + APP_CONSTANT.SOCIAL_LOGIN
        SharedHelper().Request_Api(url: url, methodType: .post, parameters: param, isHeaderIncluded: false, headers: headers){
            response in
            print(response)
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
                    //                    UserDefaults.standard.set("isSocial", forKey: "yes")
                    //                    UserDefaults.standard.synchronize()
                   
                    let message = responseData["message"] as! String
//                    let uData = responseData["data"] as! NSDictionary
//                    let userData = uData["user"] as! NSDictionary
//                    self.saveData(userData: userData)
//                    SharedHelper().hideSpinner(view: self.view)
                     UserDefaults.standard.set("yes", forKey: "login")
                    SharedHelper().showToast(message: message, controller: self)
                    
                    self.after_signin()
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

    
    func after_signin(){
        
        if(tab_index==2){
            
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FinishPopup")
            
            
            let popupVC = PopupViewController(contentController: vc, popupWidth: 320, popupHeight: 365)
            popupVC.canTapOutsideToDismiss = true
            
            //properties
            //            popupVC.backgroundAlpha = 1
            //            popupVC.backgroundColor = .black
            //            popupVC.canTapOutsideToDismiss = true
            //            popupVC.cornerRadius = 10
            //            popupVC.shadowEnabled = true
            
            // show it by call present(_ , animated:) method from a current UIViewController
            present(popupVC, animated: true)
            
        }
        else{
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingNavVCNav")
            //
            self.present(vc, animated: false, completion: nil)
            
        }
        
    }
    
    @IBAction func fb_btn(_ sender: UIButton) {
        
        
        fb_login()
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingNavVCNav")
//
//        self.present(vc, animated: false, completion: nil)
    }
    
    
    @IBAction func twitter_btn(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingNavVCNav")
        self.present(vc, animated: false, completion: nil)
    }
}

