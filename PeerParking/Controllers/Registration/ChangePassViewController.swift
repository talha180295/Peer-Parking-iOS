//
//  ChangePassViewController.swift
//  PeerParking
//
//  Created by Haya on 1/13/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import HelperClassPod
import Alamofire
class ChangePassViewController: UIViewController {

    @IBOutlet weak var txtCPass: UITextField!
    @IBOutlet weak var txtNew: UITextField!
    @IBOutlet weak var txtCurrent: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtCurrent.delegate = self
        txtNew.delegate = self
        txtCPass.delegate = self

    }
    
    /// @brief This function is use to check internet connection textfield validations and call change Password function
    func changeMain()
    {
        if(Helper().isInternetAvailable())
        {
            if(!((txtCurrent.text?.isEmpty)!))
            {
                if(!((txtNew.text?.isEmpty)!))
                {
                    if(!((txtCPass.text?.isEmpty)!))
                    {
                        if((txtCurrent.text?.count)!>=6)
                        {
                            
                            if((txtNew.text?.count)!>=6)
                            {
                                
                                if((txtCPass.text?.count)!>=6)
                                {
                                    
                                    
                                    ChangePassword(current: txtCurrent.text!, new: txtNew.text!, confirm: txtCPass.text!)
                                    
                                }
                                else
                                {
                                    SharedHelper().showToast(message: "Confirm Password must be 6 character long", controller: self)
                                }
                                
                                
                            }
                            else
                            {
                                SharedHelper().showToast(message: "New Password must be 6 character long", controller: self)
                            }
                            
                            
                        }
                        else
                        {
                            SharedHelper().showToast(message: "Current Password must be 6 character long", controller: self)
                        }
                    }
                    else
                    {
                        SharedHelper().showToast(message: "Confirm Password is missing", controller: self)
                    }
                    
                }
                else
                {
                    SharedHelper().showToast(message: "New Password is missing", controller: self)
                }
            }
            else
            {
                SharedHelper().showToast(message: "Current Password is missing", controller: self)
            }
        }
        else
        {
            SharedHelper().showToast(message: "Check your internet connection", controller: self)
        }
        
        
    }
    /**  @brief This method is use to call change Password Api to login user into the app
     **  @param current : String
     **  @param new: String
     **  @param confirm: String
     **/
    
    
    func ChangePassword(current: String, new : String, confirm : String) {
        
     
        let  newPass = new.trimmingCharacters(in: CharacterSet.whitespaces)
        let  confirmPass = confirm.trimmingCharacters(in: CharacterSet.whitespaces)
        
        let param  = [
            "current_password" : current,
            "password" : newPass,
            "password_confirmation" : confirmPass
        ]
        var auth_value : String = UserDefaults.standard.string(forKey: APP_CONSTANT.ACCESSTOKEN)!
        auth_value = "bearer " + auth_value
        
        
        let headers: HTTPHeaders = [
            "Authorization" : auth_value
        ]
        
        print(param)
        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.CHANGE_PASS + current + "&password=" + new + "&password_confirmation=" + confirm
        
       Helper().Request_Api(url: url, methodType: .post, parameters: param, isHeaderIncluded: true, headers: headers){
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
                    
                    let message = responseData["message"] as! String
                    
                    // let uData = responseData["data"] as! NSDictionary
                    print(message)
                    
                   
                    SharedHelper().showToast(message: message, controller: self)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
                       // Code you want to be delayed
                        Helper().presentOnMainScreens(controller: self, index: 1)

                    }
                    
                }
                else
                {
                    let message = responseData["message"] as! String
                    SharedHelper().showToast(message: message, controller: self)
                   
                }
            }
        }
        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnChange(_ sender: Any) {
        changeMain()
    }
}

extension ChangePassViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        txtCurrent.delegate = self
               txtNew.delegate = self
               txtCPass.delegate = self
        switch textField{
            
        case txtCurrent:
            txtNew.becomeFirstResponder()
        case txtNew:
            txtCPass.becomeFirstResponder()
        
        default:
            changeMain()
            textField.resignFirstResponder()
        }
        return false
      }
}
