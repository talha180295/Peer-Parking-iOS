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

let loginManager = LoginManager()

class FBPopup: UIViewController {

    var key = ""
    var source = ""
    var parking_details:Parking!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func fb_login(){
        
        Helper().showSpinner(view: self.view)
        if let accessToken = AccessToken.current{
            print(accessToken)
            loginManager.logOut()
        }
        loginManager.logIn(permissions: [.publicProfile,.email], viewController: self) { loginResult in
            Helper().hideSpinner(view: self.view)
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
         let device_type = "ios"
               
        let device_token :String = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
         print(device_token)
        //  SharedHelper().showSpinner(view: self.view)
        // let deviceToken : String?
        let param = [
        "platform" : platform,
        "client_id" : client_id,
        "token" : token,
        "username" : username,
        "email" : email,
        "device_token" : device_token,
        "device_type" : device_type,
        "image" : imageUrl
        ]
        print(param)
        let headers: HTTPHeaders = [
            "Authorization" : ""
        ]
        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.SOCIAL_LOGIN
        Helper().Request_Api(url: url, methodType: .post, parameters: param, isHeaderIncluded: false, headers: headers){
            response in
            print("response=\(response)")
            Helper().hideSpinner(view: self.view)
            if response.result.value == nil {
                print("No response=\(response.error?.localizedDescription)")
                print("No response=\(response.result.value)")
                
                
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
        
        NotificationCenter.default.post(name: Notification.Name("reload_table"), object: nil)
        
        if(source == "sideMenu"){
           
//            self.dismiss(animated: true, completion: nil)
            Helper().presentOnMainScreens(controller: self, index: 1)
        }
        else{
            
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
                
                let id = self.parking_details.id ?? 0
                
                
                    
                assign_buyer(p_id: id, status: 20)
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingNavVC") as! ParkingNavVC
                //
                vc.parking_details = self.parking_details
                vc.p_id = self.parking_details.id ?? 0
                vc.p_title =  parking_details.address ?? ""
                vc.p_lat = Double(self.parking_details.latitude ?? "0.0") ?? 0.0
                vc.p_longg = Double(self.parking_details.longitude ?? "0.0") ?? 0.0
                vc.vcName = ""
                vc.modalPresentationStyle = .fullScreen
                
                //            self.navigationController?.pushViewController(vc, animated: true)
                //            self.navigationController?.pushViewController(vc, animated: true)
                self.present(vc, animated: false, completion: nil)
                
            }
        }
        
    }
    
    
    func LoginApi(email : String,password : String,device_type:String) {
        
        
        Helper().showSpinner(view: self.view.parentContainerViewController()?.view ?? self.view)
        let device_token :String = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        let param = [
            
            "email" : email,
            "password" : password,
            "device_type" : device_type,
            "device_token" : device_token
            
        ]
        print(param)
        let headers: HTTPHeaders = [
            "Authorization" : ""
        ]
        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.LOGIN
        Helper().Request_Api(url: url, methodType: .post, parameters: param, isHeaderIncluded: false, headers: headers){
            response in
            print("response=\(response)")
            Helper().hideSpinner(view: self.view.parentContainerViewController()?.view ?? self.view)
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
                    
                    isSocial = true
                    
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

    
    @IBAction func fb_btn(_ sender: UIButton) {
        
        
        fb_login()
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingNavVCNav")
//
//        self.present(vc, animated: false, completion: nil)
    }
    
    
    @IBAction func twitter_btn(_ sender: UIButton) {
        
       LoginApi(email: "iosdev2@gmail.com", password: "123456", device_type: "ios")
    }
    
    func saveData(userData : NSDictionary)  {
        
        print("userData==\(userData)")
        
        let auth_token = userData["access_token"] as! String
        let created_at = userData["created_at"] as! String
        let email = userData["email"] as! String
        let expires_in = userData["expires_in"] as! Int
        let token_type = userData["token_type"] as! String
        
        let userDetails = userData["details"] as! NSDictionary
        
        
        
        
      
        key = "auth_token"
        if !(auth_token.isEmpty)
        {
            UserDefaults.standard.set(auth_token, forKey: key)
        }
        else
        {
            UserDefaults.standard.set("", forKey: key)
        }
        
        key = "created_at"
        if !(created_at.isEmpty)
        {
            UserDefaults.standard.set(created_at, forKey: key)
        }
        else
        {
            UserDefaults.standard.set("", forKey: key)
        }
        
        
        
        key = "email"
        if !(email.isEmpty)
        {
            UserDefaults.standard.set(email, forKey: key)
        }
        else
        {
            UserDefaults.standard.set("", forKey: key)
        }
        
        key = "expires_in"
        if (expires_in > 0)
        {
            UserDefaults.standard.set(expires_in, forKey: key)
        }
        else
        {
            UserDefaults.standard.set("", forKey: key)
        }
        
        key = "token_type"
        if !(token_type.isEmpty)
        {
            UserDefaults.standard.set(token_type, forKey: key)
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
            
            UserDefaults.standard.set(0, forKey: key)
        }
        else
        {
            
            let val = userDetails[key] as? Int
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
        
        key = "is_social_login"
        if userDetails[key] is NSNull {
            
            UserDefaults.standard.set("", forKey: key)
            
        }
        else
        {
            
            let val = userDetails[key] as? Int
            UserDefaults.standard.set(val, forKey: key)
        }
        
        print(userDetails)
        
        UserDefaults.standard.set("yes", forKey: "login")
        UserDefaults.standard.synchronize()
        
    }
    
    func assign_buyer(p_id:Int,status:Int){
        
        // let status:Int = 20
        
        var params:[String:Any] = [
            
            
            "status" : status
            
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
        
        
        Helper().Request_Api(url: url, methodType: .post, parameters: params, isHeaderIncluded: true, headers: headers){ response in
            
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
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackVC
                    vc.modalPresentationStyle = .fullScreen
                    vc.parking_details = self.parking_details
                    vc.p_id = p_id
                    self.present(vc, animated: true, completion: nil)
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
   
    @IBAction func btnLogin(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
   
    @IBAction func btnSignUp(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "registerVC") as! RegistrationViewController
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
}

