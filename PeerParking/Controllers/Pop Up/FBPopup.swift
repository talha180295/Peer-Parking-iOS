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

    var key = ""
    
    var parking_details:NSDictionary!
    
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
        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.SOCIAL_LOGIN
        SharedHelper().Request_Api(url: url, methodType: .post, parameters: param, isHeaderIncluded: false, headers: headers){
            response in
            print("response=\(response)")
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
                    let uData = responseData["data"] as! NSDictionary
                    let userData = uData["user"] as! NSDictionary
                    self.saveData(userData: userData)
//                    SharedHelper().hideSpinner(view: self.view)
//                     UserDefaults.standard.set("yes", forKey: "login")
//                    UserDefaults.standard.synchronize()
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
            
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingNavVC") as! ParkingNavVC
//            //
//            vc.vcName = ""
//            self.present(vc, animated: false, completion: nil)
            
            //SharedHelper().showToast(message: "Login", controller: self)
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingNavVC") as! ParkingNavVC
            //
            vc.parking_details = self.parking_details
            vc.p_id = Int(self.parking_details["id"] as! Int)
            vc.p_title =  parking_details["address"] as? String ?? ""
            
            vc.p_lat = Double(self.parking_details["latitude"] as! String)!
            vc.p_longg = Double(self.parking_details["longitude"] as! String)!
            vc.vcName = ""
            
            
            //            self.navigationController?.pushViewController(vc, animated: true)
            //            self.navigationController?.pushViewController(vc, animated: true)
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
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingNavVC") as! ParkingNavVC
        vc.vcName = ""
        self.present(vc, animated: false, completion: nil)
    }
    
    func saveData(userData : NSDictionary)  {
        
        print("userData==\(userData)")
//       // SharedHelper().hideSpinner(view: self.view)
//        let detailUser = userData["user"] as! NSDictionary
//        //let detailUser = userData["details"] as! NSDictionary
//        UserDefaults.standard.set(userData["id"], forKey: "id")
//
//        let user_name = detailUser["fullname"] as! String
//        //let bio = detailUser["bio"] as! NSNull
//        let user_email = detailUser["email"] as! String
//        let userID = detailUser["id"] as! String
//        let  image_url = detailUser["image"] as! String
//        // let address = detailUser["address"] as! NSNull
//        let detailAuth = userData["auth"] as! NSDictionary
        
        let auth_token = userData["access_token"] as! String
        let created_at = userData["created_at"] as! String
        let email = userData["email"] as! String
        let expires_in = userData["expires_in"] as! Int
        let token_type = userData["token_type"] as! String
        
        let userDetails = userData["details"] as! NSDictionary
        
        
//        let address:String!
//        let average_rating:String!
//        let balance:String!
//        let email_updates:String!
//        let first_name:String!
//        let full_name:String!
//        let id:String!
//        let image:String!
//        let image_url:String!
//        let last_name:String!
//        let phone:String!
        
        
      
        key = "auth_token"
        if !auth_token.isEmpty && !(userDetails[key] is NSNull)
        {
            UserDefaults.standard.set(auth_token, forKey: key)
        }
        else
        {
            UserDefaults.standard.set("", forKey: key)
        }
        
        key = "created_at"
        if !created_at.isEmpty && !(userDetails[key] is NSNull)
        {
            UserDefaults.standard.set(auth_token, forKey: key)
        }
        else
        {
            UserDefaults.standard.set("", forKey: key)
        }
        
        
        
        key = "email"
        if !email.isEmpty && !(userDetails[key] is NSNull)
        {
            UserDefaults.standard.set(auth_token, forKey: key)
        }
        else
        {
            UserDefaults.standard.set("", forKey: key)
        }
        
        key = "expires_in"
        if expires_in > 0 && !(userDetails[key] is NSNull)
        {
            UserDefaults.standard.set(auth_token, forKey: key)
        }
        else
        {
            UserDefaults.standard.set("", forKey: key)
        }
        
        key = "token_type"
        if !token_type.isEmpty && !(userDetails[key] is NSNull)
        {
            UserDefaults.standard.set(auth_token, forKey: key)
        }
        else
        {
            UserDefaults.standard.set("", forKey: key)
        }
        
        

        
        //User Details
        key = "address"
        if userDetails[key] is NSNull {
            
            UserDefaults.standard.set("", forKey: key)
        }
        else
        {
            
            let val = userDetails[key] as? String
            UserDefaults.standard.set(val, forKey: key)
        }
        
        key = "average_rating"
        if userDetails[key] is NSNull {
            
            UserDefaults.standard.set("", forKey: key)
        }
        else
        {
            
            let val = userDetails[key] as? String
            UserDefaults.standard.set(val, forKey: key)
        }
        
        key = "balance"
        if userDetails[key] is NSNull {
            
            UserDefaults.standard.set("", forKey: key)
        }
        else
        {
            
            let val = userDetails[key] as? String
            UserDefaults.standard.set(val, forKey: key)
        }

        
        key = "email_updates"
        if userDetails[key] is NSNull {
            
            UserDefaults.standard.set("", forKey: key)
        }
        else
        {
            
            let val = userDetails[key] as? String
            UserDefaults.standard.set(val, forKey: key)
        }
        
        key = "first_name"
        if userDetails[key] is NSNull {
            
            UserDefaults.standard.set("", forKey: key)
        }
        else
        {
            
            let val = userDetails[key] as? String
            UserDefaults.standard.set(val, forKey: key)
        }
        
        key = "full_name"
        if userDetails[key] is NSNull {
            
            UserDefaults.standard.set("", forKey: key)
        }
        else
        {
            
            let val = userDetails[key] as? String
            UserDefaults.standard.set(val, forKey: key)
        }
        
        key = "id"
        if userDetails[key] is NSNull {
            
            UserDefaults.standard.set("", forKey: key)
        }
        else
        {
            
            let val = userDetails[key] as? String
            UserDefaults.standard.set(val, forKey: key)
        }
        
        
        key = "image"
        if userDetails[key] is NSNull {
            
            UserDefaults.standard.set("", forKey: key)
        }
        else
        {
            
            let val = userDetails[key] as? String
            UserDefaults.standard.set(val, forKey: key)
        }
        
        
        key = "image_url"
        if userDetails[key] is NSNull {
            
            UserDefaults.standard.set("", forKey: key)
        }
        else
        {
            
            let val = userDetails[key] as? String
            UserDefaults.standard.set(val, forKey: key)
        }
        
        
        key = "last_name"
        if userDetails[key] is NSNull {
            
            UserDefaults.standard.set("", forKey: key)
        }
        else
        {
            
            let val = userDetails[key] as? String
            UserDefaults.standard.set(val, forKey: key)
        }
        
        
        key = "phone"
        if userDetails[key] is NSNull {
            
            UserDefaults.standard.set("", forKey: key)
        }
        else
        {
            
            let val = userDetails[key] as? String
            UserDefaults.standard.set(val, forKey: key)
        }
        
        
        
        
        UserDefaults.standard.set("yes", forKey: "login")
        UserDefaults.standard.synchronize()

        //print("nnnn= \(auth_token) \(created_at) \(email) \(expires_in) \(token_type) \(userDetails) ")
        
        
//        let add : String!
//        let bioD:String!
//        let iD:String!
//        let full_name : String!
//        let CellNumber : String!
//        if detailUser["address"] is NSNull {
//            add = ""
//        }
//        else
//        {
//            add = detailUser["address"] as? String
//        }
//
//        if detailUser["bio"] is NSNull {
//            bioD = ""
//        }
//        else
//        {
//            bioD = detailUser["bio"] as? String
//        }
//
//
//        if detailUser["id"] is NSNull {
//            iD = ""
//        }
//        else
//        {
//            iD = detailUser["id"] as? String
//        }
//
//        if detailUser["fullname"] is NSNull {
//            full_name = ""
//        }
//        else
//        {
//            full_name = detailUser["fullname"] as? String
//        }
//        if detailUser["cellNumber"] is NSNull {
//            CellNumber = ""
//        }
//        else
//        {
//            CellNumber = detailUser["cellNumber"] as? String
//        }
//
//
//        if(!bioD.isEmpty)
//        {
//            UserDefaults.standard.set(bioD, forKey: "bio")
//        }
//        else
//        {
//            UserDefaults.standard.set("", forKey: "bio")
//        }
//        if(!userID.isEmpty)
//        {
//            UserDefaults.standard.set(userID, forKey: "user_Id")
//        }
//        else
//        {
//            UserDefaults.standard.set("", forKey: "user_Id")
//        }
//        if(!add.isEmpty)
//        {
//            UserDefaults.standard.set(add, forKey: "address")
//        }
//        else
//        {
//            UserDefaults.standard.set("", forKey: "address")
//        }
//
//        if(!full_name.isEmpty)
//        {
//            UserDefaults.standard.set(full_name, forKey: "fullname")
//        }
//        else
//        {
//            UserDefaults.standard.set("", forKey: "fullname")
//        }
//        if(!CellNumber.isEmpty)
//        {
//            UserDefaults.standard.set(CellNumber, forKey: "cellNumber")
//        }
//        else
//        {
//            UserDefaults.standard.set("", forKey: "cellNumber")
//        }
//
//        if(!image_url.isEmpty)
//        {
//            UserDefaults.standard.set(image_url, forKey: "image")
//        }
//        else
//        {
//            UserDefaults.standard.set("", forKey: "image")
//        }
//        if(!user_name.isEmpty)
//        {
//            UserDefaults.standard.set(user_name, forKey: "name")
//        }
//        else
//        {
//            UserDefaults.standard.set("", forKey: "name")
//        }
//        if(!user_email.isEmpty)
//        {
//            UserDefaults.standard.set(user_email, forKey: "email")
//        }
//        else
//        {
//            UserDefaults.standard.set("", forKey: "image")
//        }
//        if(!auth_token.isEmpty)
//        {
//            UserDefaults.standard.set(auth_token, forKey: "auth_token")
//        }
//        else
//        {
//            UserDefaults.standard.set("", forKey: "auth_token")
//        }
//        if(!token_type.isEmpty)
//        {
//            UserDefaults.standard.set(token_type, forKey: "token_type")
//        }
//        else
//        {
//            UserDefaults.standard.set("", forKey: "token_type")
//        }
//
//        UserDefaults.standard.set(expires_in, forKey: "expires_in")
//        UserDefaults.standard.set("yes", forKey: "login")
//        UserDefaults.standard.set("homeVC", forKey: "VC")
//        UserDefaults.standard.synchronize()
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabVC") as! TabBarViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//
        
    }
}

