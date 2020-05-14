//
//  ResetViewController.swift
//  PeerParking
//
//  Created by Haya on 1/13/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import Alamofire
import HelperClassPod
class ResetViewController: UIViewController {

    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtVerify: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    var verifyCode:Int!
    var email:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtVerify.text = "\(verifyCode ?? 0)"
        txtEmail.text = email
        
        txtPass.delegate = self
        txtConfirmPass.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    /// @brief This function is use to check internet connection textfield validations and call reset Password function
    func resetMain()
    {
        if(Helper().isInternetAvailable())
        {if(!(txtEmail.text?.isEmpty)!)
        {
            if(!(txtVerify.text?.isEmpty)!)
            {
            if(!(txtPass.text?.isEmpty)!)
            {
               if((txtPass.text?.count)!>=6)
                {
                    
                    if((txtPass.text?.elementsEqual(txtConfirmPass.text!))!)
                    {
                        ResetPassword(code: txtVerify.text!, email: txtEmail.text!, password: txtPass.text!, confirmPassword: txtConfirmPass.text!)
                        
                    }
                    else
                    {
                        SharedHelper().showToast(message: "Password and Confirm Password does not match", controller: self)
                    }
                    
                }
                else
                {
                    SharedHelper().showToast(message: "Password must be 6 character long", controller: self)
                }
            }
                    
                else
                {
                    SharedHelper().showToast(message: "Please Add Password ", controller: self)
                }
                
            }
            else
            {
                SharedHelper().showToast(message: "Add Verification Code", controller: self)
            }
            
        }
        else
        {
            SharedHelper().showToast(message: "Add Email ", controller: self)
            }
            
        }
        else
        {
            SharedHelper().showToast(message: "Check your internet connection", controller: self)
        }
    }
    /**  @brief This method is use to call Reset password Api to reset user's password
     **  @param code : String
     **  @param email: String
     **  @param password: String
     **  @param confirmPassword: String
     **/
    
    func ResetPassword(code : String, email: String, password: String, confirmPassword: String) {
        
         Helper().showSpinner(view: self.view)
        
        let param = [
            "verification_code" : code,
            "email" : email,
            "password" : password,
            "password_confirmation":confirmPassword
        ]
        
        let headers: HTTPHeaders = [
            "Authorization" : ""
        ]
          let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.RESET_PASS + email + "&verification_code=" + code + "&password=" + password + "password_confirmation=" + confirmPassword
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
                      SharedHelper().showToast(message: message, controller: self)
              
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                        
                        self.present(vc, animated: true, completion: nil)
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
    
    @IBAction func btnReset(_ sender: Any) {
      resetMain()
    }
 
    

    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension ResetViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField{
            
            
        case txtPass:
            txtConfirmPass.becomeFirstResponder()
        case txtConfirmPass:
            txtConfirmPass.resignFirstResponder()
        default:
            resetMain()
            textField.resignFirstResponder()
        }
        return false
      }
}
