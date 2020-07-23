//
//  LoginViewController.swift
//  PeerParking
//
//  Created by Haya on 1/13/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging

class LoginViewController: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        txtPassword.delegate = self
        txtEmail.delegate = self
    }
    /// @brief This function is use to check internet connection textfield validations and call login function
    
    func newMethod() {
        txtPassword.resignFirstResponder()
        if(Helper().isInternetAvailable())
        {
            if(!((txtEmail.text?.isEmpty)!))
            {
                if( Helper().validateEmail(enteredEmail: txtEmail.text!))
                {
                    if(!(txtPassword.text?.isEmpty)!)
                    {
                        if((txtPassword.text?.count)!>=6)
                        {
                            
                            
                            Login(email: txtEmail.text!, password: txtPassword.text!);
                            
                        }
                        else
                        {
                            Helper().showToast(message: "Password must be 6 character long", controller: self)
                        }
                    }
                    else
                    {
                        Helper().showToast(message: "Add password", controller: self)
                    }
                }
                else
                {
                    Helper().showToast(message: "Email is invalid", controller: self)
                }
            }
            else
            {
                Helper().showToast(message: "Email is missing", controller: self)
            }
        }
        else
        {
            Helper().showToast(message: "Check your internet connection", controller: self)
        }
    }
    
    /**  @brief This method is use to call login Api to login user into the app
     **  @param email : String
     **  @param password: String
     **/
    
    func Login(email : String, password : String) {
      
        //        var strRole="2"
        //
        
        Helper().showSpinner(view: self.view)
        let deviceToken = "ios"
        // SharedHelper().showSpinner(view: self.view)
        // let deviceToken : String?
        
        
        guard let device_token :String = Messaging.messaging().fcmToken
            else{
                Helper().showToast(message: "Fcm Token Error", controller: self)
                return
        }
        let param = [
            
            "email" : email,
            "password" : password,
            "device_type" : deviceToken,
            "device_token" : device_token
            
        ]
        
        let headers: HTTPHeaders = [
            "Authorization" : ""
        ]
        
          let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.LOGIN
        Helper().Request_Api(url: url, methodType: .post, parameters: param, isHeaderIncluded: false, headers: headers){
            response in
            print(response)
            Helper().hideSpinner(view: self.view)
            if response.result.value == nil {
                print("No response")
                
                return
            }
            else {
                let responseData = response.result.value as! NSDictionary
                let status = responseData["success"] as! Bool
                if(status)
                {
                    
                    let message = responseData["message"] as! String
                    isSocial = false
                    let uData = responseData["data"] as! NSDictionary
                    print(responseData)
                    let userData = uData["user"] as! NSDictionary
                    self.saveData(userData: userData)
                    Helper().showToast(message: message, controller: self)
                    
                    
                    
                }
                else
                {
                    let message = responseData["message"] as! String
                    Helper().showToast(message: message, controller: self)
                    
                }
            }
        }
    }
    /// @brief This function is use to  save the signup credentials
    func saveData(userData : NSDictionary)  {
        
        
        
        
        print(userData)
      
        let detailUser = userData["details"] as! NSDictionary
        UserDefaults.standard.set(userData["id"], forKey: "id")
        
        let user_name = userData["name"] as! String
        let user_email = userData["email"] as! String
        let auth_token = userData[APP_CONSTANT.ACCESSTOKEN] as! String
        let token_type = userData["token_type"] as! String
        let expires_in = userData["expires_in"] as! Int
        let  image_url = detailUser["image_url"] as! String
        
        let full_name : String!
        let phone : String!
        let address : String!
        let about:String!
        //  let null = NSNull()
        
        
        
        if detailUser["full_name"] is NSNull {
            full_name = ""
        }
        else
        {
            full_name = detailUser["full_name"] as? String
        }
        if detailUser["about"] is NSNull {
            about = ""
        }
        else
        {
            about = detailUser["about"] as? String
        }
        if detailUser["phone"] is NSNull {
            phone = ""
        }
        else
        {
            phone = detailUser["phone"] as? String
        }
        
        if detailUser["address"] is NSNull {
            address = ""
        }
        else
        {
            address = detailUser["address"] as? String
        }
        if(!image_url.isEmpty)
        {
            UserDefaults.standard.set(image_url, forKey: "image_url")
        }
        else
        {
            UserDefaults.standard.set("", forKey: "image_url")
        }
        
        
        
        //        let about = detailUser["about"] as! String
        //        let address = detailUser["address"] as! String
        //        let full_name = detailUser["full_name"] as! String
        //        let phone = detailUser["phone"] as! String
        let is_social_login = detailUser["is_social_login"] as! Int
        // let tier = userData["tier"] as! Int
        //        let total_followers = userData["total_followers"] as! Int
        //        let total_points = userData["total_points"] as! Int
        //        let total_reviews = userData["total_reviews"] as! Int
        //        let total_swipe = userData["total_swipe"] as! Int
        //
        
        if(!address.isEmpty)
        {
            UserDefaults.standard.set(address, forKey: "address")
        }
        else
        {
            UserDefaults.standard.set("", forKey: "address")
        }
        
        
        if(!full_name.isEmpty)
        {
            UserDefaults.standard.set(full_name, forKey: "full_name")
        }
        else
        {
            UserDefaults.standard.set("", forKey: "full_name")
        }
        if(!phone.isEmpty)
        {
            UserDefaults.standard.set(phone, forKey: "phone")
        }
        else
        {
            UserDefaults.standard.set("", forKey: "phone")
        }
        
        
        
        UserDefaults.standard.set(is_social_login, forKey: "is_social_login")
        
        
        
        
                if(!image_url.isEmpty)
                {
                    UserDefaults.standard.set(image_url, forKey: "image_url")
                }
                else
                {
                    UserDefaults.standard.set("", forKey: "image_url")
                }
        if(!user_name.isEmpty)
        {
            UserDefaults.standard.set(user_name, forKey: "name")
        }
        else
        {
            UserDefaults.standard.set("", forKey: "name")
        }
        if(!user_email.isEmpty)
        {
            UserDefaults.standard.set(user_email, forKey: "email")
        }
        else
        {
            UserDefaults.standard.set("", forKey: "email")
        }
        if(!auth_token.isEmpty)
        {
            UserDefaults.standard.set(auth_token, forKey: APP_CONSTANT.ACCESSTOKEN)
        }
        else
        {
            UserDefaults.standard.set("", forKey: APP_CONSTANT.ACCESSTOKEN)
        }
        if(!token_type.isEmpty)
        {
            UserDefaults.standard.set(token_type, forKey: "token_type")
        }
        else
        {
            UserDefaults.standard.set("", forKey: "token_type")
        }
        
        
        
        if(isSocial)
        {
            UserDefaults.standard.set("yes", forKey: "isSocial")
        }
        else
        {
            UserDefaults.standard.set("no", forKey: "isSocial")
        }
        
        if(!token_type.isEmpty)
        {
            UserDefaults.standard.set(token_type, forKey: "wallet")
        }
        else
        {
            UserDefaults.standard.set("", forKey: "wallet")
        }
        
        let key = "wallet"
        if detailUser[key] is NSNull {
            
            UserDefaults.standard.set("", forKey: key)
        }
        else
        {
            
            let val = detailUser[key] as? Double
            UserDefaults.standard.set(val, forKey: key)
        }
        
        
        UserDefaults.standard.set(expires_in, forKey: "expires_in")
        UserDefaults.standard.set("yes", forKey: "login")
        UserDefaults.standard.set("homeVC", forKey: "VC")
        
        UserDefaults.standard.synchronize()
      
        Helper().presentOnMainScreens(controller: self, index: tab_index)
        
        //        let fname :String = UserDefaults.standard.string(forKey: "name")!
        //        let UID :String = UserDefaults.standard.string(forKey: "id")!
        //        Analytics.logEvent("Sign Up Screen", parameters: ["user_id": UID, "user_name": fname])
        
    }

    @IBAction func btnRegister(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "registerVC") as! RegistrationViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnBack(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        Helper().presentOnMainScreens(controller: self, index: tab_index)
    }
    @IBAction func btnForget(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "forgetVC") as! ForgetPassViewController
        
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func btnLogin(_ sender: Any) {
        
        newMethod()
    }
}


extension LoginViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == txtEmail)
        {
            txtPassword.becomeFirstResponder()
        }
        else
        {
            txtPassword.resignFirstResponder()
            newMethod()
        }
        return true
      }
}
