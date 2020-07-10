//
//  FinishPopup.swift
//  PeerParking
//
//  Created by Apple on 29/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import HelperClassPod
import Alamofire

class FinishPopup: UIViewController {
    
    //Intent Variables
    var isPrivate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func finish_btn(_ sender: UIButton) {
        
        
        if(self.isPrivate){
            
            self.postPrivateParking(sender)
        }
        else{
            self.postPublicParking(sender)
        }
        
        
        
        
    }
    
    func postPublicParking(_ sender: UIButton){
        
        Helper().showSpinner(view: self.view)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customVC")
        tab_index = 1
        //        Helper().presentOnMainScreens(controller: vc, index: tab_index)
        
        
        GLOBAL_VAR.PARKING_POST_DONE = true
        
        sender.isHidden = true
        
        let image = GLOBAL_VAR.PARKING_POST_DETAILS["image"]
        
        
        var params:[String:Any] = GLOBAL_VAR.PARKING_POST_DETAILS
        
        params.removeValue(forKey: "image")
        
        let auth_value =  "Bearer \(UserDefaults.standard.string(forKey: APP_CONSTANT.ACCESSTOKEN)!)"
        let headers: HTTPHeaders = [
            "Authorization" : auth_value
        ]
        print("==0params=\(params)")
        print("==0headers=\(headers)")
        
        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.POST_PARKING
        
        print("url--\(url)")
        
        GLOBAL_VAR.PARKING_POST_DETAILS.removeAll()
        
        uploadImage(urlString: url, imageParamKey: "image", imageData: image as! Data, param: params, headers: headers){
            response in
            
            if response?.result.value == nil {
                print("No response")
                
                Helper().hideSpinner(view: self.view)
                SharedHelper().showToast(message: "Internal Server Error", controller: vc)
                
            }
            else {
                let responseData = response?.result.value as! NSDictionary
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
                    SharedHelper().showToast(message: message, controller: vc)
                    //                    tab_index = 1
                    //                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    
                    
                    //self.after_signin()
                }
                else
                {
                    let message = responseData["message"] as! String
                    SharedHelper().showToast(message: message, controller: self)
                    //   SharedHelper().hideSpinner(view: self.view)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of seconds.
                // Code you want to be delayed
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //                Helper().presentOnMainScreens(controller: self, index: 2)
                self.dismiss(animated: true){
                    
                    isUserSellParking = true
                    //                                 appDelegate.window?.rootViewController?.present(vc, animated: true,completion: nil)
                    Helper().presentOnMainScreens(controller: self, index: 2)
                    
                    
                    
                }
                
            }
            
            
        }
    }
    
    func postPrivateParking(_ sender: UIButton){
        
        Helper().showSpinner(view: self.view)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customVC")
        tab_index = 1
        //        Helper().presentOnMainScreens(controller: vc, index: tab_index)
        
        
        GLOBAL_VAR.PARKING_POST_DONE = true
        
        sender.isHidden = true
        
        let image = GLOBAL_VAR.PRIVATE_PARKING_MODEL["image"]
        
        
        
        var params:[String:Any] = GLOBAL_VAR.PRIVATE_PARKING_MODEL
        
        params.removeValue(forKey: "image")
        
        let auth_value =  "Bearer \(UserDefaults.standard.string(forKey: APP_CONSTANT.ACCESSTOKEN)!)"
        let headers: HTTPHeaders = [
            "Authorization" : auth_value
        ]
        print("==0private_params=\(params)")
        print("==0headers=\(headers)")
        
        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.POST_PRIVATE_PARKING
        
        print("url--\(url)")
        
        GLOBAL_VAR.PRIVATE_PARKING_MODEL.removeAll()
        
        uploadImage(urlString: url, imageParamKey: "image", imageData: image as! Data, param: params, headers: headers){
            response in
            print("response>>>\(response)")
            
            Helper().hideSpinner(view: self.view)
            if response?.result.value == nil {
                print("No response")
                
                SharedHelper().showToast(message: "Internal Server Error", controller: vc)
                
            }
            else {
                let responseData = response?.result.value as! NSDictionary
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
                    //                    tab_index = 1
                    //                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    
                    
                    //self.after_signin()
                }
                else
                {
                    let message = responseData["message"] as! String
                    SharedHelper().showToast(message: message, controller: vc)
                    //   SharedHelper().hideSpinner(view: self.view)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of seconds.
                // Code you want to be delayed
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //                Helper().presentOnMainScreens(controller: self, index: 2)
                self.dismiss(animated: true){
                    
                     isUserSellParking = true
                    //                                 appDelegate.window?.rootViewController?.present(vc, animated: true,completion: nil)
                    Helper().presentOnMainScreens(controller: self, index: 2)
                    
                    
                    
                }
                
            }
            
            
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of seconds.
            //               // Code you want to be delayed
            //
            //                Helper().presentOnMainScreens(controller: self, index: 2)
            //                self.dismiss(animated: true, completion: nil)
            //            }
        }
    }
    
    func uploadImage(urlString : String ,imageParamKey:String, imageData : Data, param : [String : Any],headers:HTTPHeaders, completion: @escaping (_ result: DataResponse<Any>?) -> Void){
        
        
        //        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
        //            print("Could not get JPEG representation of UIImage")
        //            return
        //        }
        
        
        
        Helper().RefreshToken(completion:{
            response in
            print(response)
            if response.result.value == nil {
                print("No response")
                completion(nil)
                return
            }
            else {
                let responseData = response.result.value as! NSDictionary
                let status = responseData["success"] as! Bool
                if(status)
                {
                    let uData = responseData["data"] as! NSDictionary
                    
                    let userData = uData["user"] as! NSDictionary
                    
                    let auth_token = userData[APP_CONSTANT.ACCESSTOKEN] as! String
                    UserDefaults.standard.set(auth_token, forKey: APP_CONSTANT.ACCESSTOKEN)
                    UserDefaults.standard.synchronize()
                    
                    var auth_value : String = UserDefaults.standard.string(forKey: APP_CONSTANT.ACCESSTOKEN)!
                    auth_value = "bearer " + auth_value
                    
                    let headers1: HTTPHeaders = [
                        "Authorization" : auth_value,
                        //                        "Accept" : "application/json",
                        "Content-Type" : "application/json"
                    ]
                    
                    Alamofire.upload(multipartFormData: { multipartFormData in
                        for (key, value) in param {
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                        }
                        
                        multipartFormData.append(imageData,
                                                 withName: imageParamKey,
                                                 fileName: "image.jpg",
                                                 mimeType: "image/jpeg")
                    },
                                     to: urlString,
                                     headers: headers1,
                                     encodingCompletion: { encodingResult in
                                        
                                        switch encodingResult {
                                        case .success(let upload, _, _):
                                            upload.uploadProgress { progress in
                                                print(progress)
                                            }
                                            upload.validate()
                                            upload.responseJSON { response in
                                                
                                                switch response.result {
                                                case .success:
                                                    print(response)
                                                    completion(response)
                                                    break
                                                case .failure(let error):
                                                    print(error)
                                                    completion(response)
                                                }
                                            }
                                        case .failure(_):
                                            print(encodingResult)
                                            //                                completion(encodingResult)
                                            
                                        }
                    })
                    
                }
            }
            
            
        });
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
}
