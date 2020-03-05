//
//  RegistrationViewController.swift
//  PeerParking
//
//  Created by Haya on 1/13/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import Alamofire
import HelperClassPod
    var isSocial:Bool!
class RegistrationViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
   
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imgDp: UIImageView!
    
    @IBOutlet weak var txtNAme: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        txtNAme.delegate = self
        txtEmail.delegate = self
        txtPass.delegate = self
        txtConfirmPass.delegate = self
    }
    /// @brief This function is use to check internet connection textfield validations and call register function
    
    func register()
    {
        txtConfirmPass.resignFirstResponder()
        if(Helper().isInternetAvailable())
        {
            if(!((txtNAme.text?.isEmpty)!))
            {
                if(!((txtEmail.text?.isEmpty)!))
                {
                    if( Helper().validateEmail(enteredEmail: txtEmail.text!))
                    {
                        
                        if(!(txtPass.text?.isEmpty)!)
                        {
                            if((txtPass.text?.count)!>=6)
                            {
                                if((txtPass.text?.elementsEqual(txtConfirmPass.text!))!)
                                {
                                    
                                 Register(name: txtNAme.text!, email: txtEmail.text!, password: txtPass.text!);
                                }
                                else
                                {
                                    Helper().showToast(message: "Password and Confirm Password are not matched", controller: self)
                                }
                                
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
                Helper().showToast(message: "Full name is missing", controller: self)
            }
        }
        else
        {
            Helper().showToast(message: "Check your internet connection", controller: self)
        }
    }
    /**  @brief This method is use to call register Api to register the user into the app
     **  @param name : String
     **  @param email : String
     **  @param password: String
     **/
    func Register(name: String, email : String, password : String) {
     //   let FCMToken :String = UserDefaults.standard.string(forKey: "FCMToken")!
        //        var strRole="2"
        //
        Helper().showSpinner(view: self.view)
   
        let deviceToken = "ios"
        
        let param  = [
            "name" : name,
            "email" : email,
            "password" : password,
            "password_confirmation" : txtConfirmPass.text!,
            "device_token" : "string",
            "device_type" : deviceToken
        ]
        let headers: HTTPHeaders = [
            "Authorization" : ""
        ]
        print(param)
        // print(param)
     let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.SIGN_UP
        
         let imgData =  (self.imgDp.image!.jpegData(compressionQuality: 1.0) )
       Helper().SignUpProfileRequest(url: url, profileImg: imgData!, parameters: param)     {
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
                    let uData = responseData["data"] as! NSDictionary
                    
                    let message = responseData["message"] as! String
                    let userData = uData["user"] as! NSDictionary
                    print("successful")
                   isSocial = false
                    SharedHelper().showToast(message: message, controller: self)
                    
                    self.saveData(userData: uData)
                    
                }
                else
                {
                    let message = responseData["message"] as! String
                    SharedHelper().showToast(message: message, controller: self)
                  
                }
            }
        }
    }
    
    /// @brief This function is use to  save the signup credentials
    func saveData(userData : NSDictionary)  {
        
        
        
        print(userData)
        let userDict = userData["user"] as! NSDictionary
        let detailUser = userDict["details"] as! NSDictionary
        UserDefaults.standard.set(userData["id"], forKey: "id")
        
        let user_name = userDict["name"] as! String
        let user_email = userDict["email"] as! String
        let auth_token = userDict["access_token"] as! String
        let token_type = userDict["token_type"] as! String
        let expires_in = userDict["expires_in"] as! Int
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
            UserDefaults.standard.set(auth_token, forKey: "auth_token")
        }
        else
        {
            UserDefaults.standard.set("", forKey: "auth_token")
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
        UserDefaults.standard.set(expires_in, forKey: "expires_in")
        UserDefaults.standard.set("yes", forKey: "login")
        UserDefaults.standard.set("homeVC", forKey: "VC")
        
        UserDefaults.standard.synchronize()
 
   
         Helper().presentOnMainScreens(controller: self, index: 1)
        
        //        let fname :String = UserDefaults.standard.string(forKey: "name")!
        //        let UID :String = UserDefaults.standard.string(forKey: "id")!
        //        Analytics.logEvent("Sign Up Screen", parameters: ["user_id": UID, "user_name": fname])
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let ImageChose = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.imgDp.image = ImageChose
        dismiss(animated:true, completion: nil)
        
    }
    
    func uploadImage() {
        let alert = UIAlertController(title: "", message: "Select Image", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "From Camera", style: UIAlertAction.Style.default, handler:{ action in
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion:nil)
        }))
        alert.addAction(UIAlertAction(title: "From Gallery", style: UIAlertAction.Style.cancel, handler:{ action in
            
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion:nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler:{ action in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnBack(_ sender: Any) {
//         self.dismiss(animated: true, completion: nil)
        Helper().presentOnMainScreens(controller: self, index: 1)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        register()
    }
    @IBAction func btnUploadImage(_ sender: Any) {
        uploadImage()
        
    }
    
  
}


extension RegistrationViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField{
            
        case txtNAme:
            txtEmail.becomeFirstResponder()
        case txtEmail:
            txtPass.becomeFirstResponder()
        case txtPass:
            txtConfirmPass.becomeFirstResponder()
        case txtConfirmPass:
            txtConfirmPass.resignFirstResponder()
        default:
            register()
            textField.resignFirstResponder()
        }
        return false
      }
}
