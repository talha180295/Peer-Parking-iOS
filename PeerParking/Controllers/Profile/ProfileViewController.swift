//
//  ProfileViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 05/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import HelperClassPod
class ProfileViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtLast: UITextField!
    @IBOutlet weak var txtFirst: UITextField!
    @IBOutlet weak var img: UIImageView!
       var imagePicker = UIImagePickerController()
    var me:NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
  getMe()
        print(UserDefaults.standard.string(forKey: "last_name"))
        self.img.clipsToBounds = true
       
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
    }
    func getMe() {
        
    
        
        var auth_value : String = UserDefaults.standard.string(forKey: "auth_token")!
        auth_value = "bearer " + auth_value
        
        
        let headers: HTTPHeaders = [
            "Authorization" : auth_value
            
        ]
        print(auth_value)
        //        Analytics.logEvent("Forgot Password Screen", parameters: ["email":email] )
        
    
        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.ME
        print(url)
        Helper().Request_Api(url: url, methodType: .post, parameters: [:], isHeaderIncluded: true, headers: headers)
        {
            response in
            print(response)
            if response.result.value == nil {
                print("No response")
                
                return
            }
            else {
                let responseData = response.result.value as! NSDictionary
                let status = responseData["success"] as! Bool
                if(status)
                {
                    
                  
                    print(responseData)
                    self.me = (responseData["data"] as! NSDictionary)
                    self.setData(data:self.me)
                    
                }
                else
                {
                    let message = responseData["message"] as! String
                    SharedHelper().showToast(message: message, controller: self)
                   
                    
                }
            }
        }
        
    }
    /**  @brief This method is use to call register Api to register the user into the app
     **  @param name : String
     **  @param email : String
     **  @param password: String
     **/
    func edit(email : String) {
        //   let FCMToken :String = UserDefaults.standard.string(forKey: "FCMToken")!
        //        var strRole="2"
        //
        let name:String!
        if (self.txtFirst.text?.elementsEqual(""))!{
           name = self.txtLast.text!
        }
        else if(self.txtLast.text?.elementsEqual(""))! {
            name = self.txtFirst.text!
        }
        else if !(self.txtFirst.text!.isEmpty) &&
            !(self.txtLast.text!.isEmpty)
        {
            name = self.txtFirst.text! + self.txtLast.text!
            
        }
        else{
            name = ""
        }
        
        let param  = [
           
            "phone" : self.txtPhone.text!,
    
            "name" : name!
        
            ] as [String : Any]
        var auth_value : String = UserDefaults.standard.string(forKey: "auth_token")!
        auth_value = "bearer " + auth_value
      
        print(param)
  
        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.UPDATE
        
        let imgData =  (self.img.image!.jpegData(compressionQuality: 1.0) )
        Helper().UpateProfileRequestPut(url: url, profileImg: imgData!, parameters: param)     {
            response in
            print(response)
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
                    
                    print(responseData)
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
   
       
        UserDefaults.standard.set(userData["id"], forKey: "id")
      
   
        let  image_url = userData["image_url"] as! String
        
        let full_name : String!
        let phone : String!
        let address : String!
        let about:String!
        let fName:String!
        let lName:String!
        //  let null = NSNull()
        
        if userData["first_name"] is NSNull {
            fName = ""
        }
        else
        {
            fName = userData["first_name"] as? String
        }
        if userData["last_name"] is NSNull {
            lName = ""
        }
        else
        {
            lName = userData["last_name"] as? String
        }
        
        
        if userData["full_name"] is NSNull {
            full_name = ""
        }
        else
        {
            full_name = userData["full_name"] as? String
        }
       
        if userData["phone"] is NSNull {
            phone = ""
        }
        else
        {
            phone = userData["phone"] as? String
        }
        
      
        
        
        //        let about = detailUser["about"] as! String
        //        let address = detailUser["address"] as! String
        //        let full_name = detailUser["full_name"] as! String
        //        let phone = detailUser["phone"] as! String
        let is_social_login = userData["is_social_login"] as! Int
        // let tier = userData["tier"] as! Int
        //        let total_followers = userData["total_followers"] as! Int
        //        let total_points = userData["total_points"] as! Int
        //        let total_reviews = userData["total_reviews"] as! Int
        //        let total_swipe = userData["total_swipe"] as! Int
        //
        
       
        if(!fName.isEmpty)
        {
            UserDefaults.standard.set(fName, forKey: "first_name")
        }
        else
        {
            UserDefaults.standard.set("", forKey: "first_name")
        }
        print(lName)
        if(!lName.isEmpty)
        {
            UserDefaults.standard.set(lName, forKey: "last_name")
        }
        else
        {
            UserDefaults.standard.set("", forKey: "last_name")
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
       
      
  
        SharedHelper().showToast(message: "UPDATED", controller: self)
        UserDefaults.standard.synchronize()

        
        //        let fname :String = UserDefaults.standard.string(forKey: "name")!
        //        let UID :String = UserDefaults.standard.string(forKey: "id")!
        //        Analytics.logEvent("Sign Up Screen", parameters: ["user_id": UID, "user_name": fname])
        
    }
    func setData(data:NSDictionary){
        print(data)
        self.txtEmail.text = (data["email"] as! String)
        let details = data["details"] as! NSDictionary
        self.txtFirst.text = (details["first_name"] as! String)
        let lName:String!
        if details["last_name"] is NSNull{
            lName = ""
        }
        else{
            lName = (details["last_name"]  as! String)
        }
        self.txtLast.text = lName
        let phine:String!
        if details["phone"]  is NSNull{
            phine = ""
        }
        else{
            phine = details["phone"] as! String
        }
        self.txtPhone.text = phine
        let imag:String!
        if details["image_url"] is NSNull{
            imag = ""
        }
        else{
            imag = (details["image_url"]  as! String)
        }
        
        img.sd_setImage(with: URL(string: imag),placeholderImage: UIImage.init(named: "placeholder_user") )
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let ImageChose = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.img.image = ImageChose
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
    
    @IBAction func uploadImage(_ sender: Any) {
         uploadImage()
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        edit(email: self.txtEmail.text!)
    }
   
}
