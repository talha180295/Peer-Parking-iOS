//
//  ForgetPassViewController.swift
//  PeerParking
//
//  Created by Haya on 1/13/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import HelperClassPod
import Alamofire
class ForgetPassViewController: UIViewController {

    @IBOutlet weak var btnAlreadyHave: UIButton!
    @IBOutlet weak var txtVerifyCode: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSendCode: UIButton!
    @IBOutlet weak var btnVerifyCode: UIButton!
    @IBOutlet weak var viewVerifyCode: UIView!
    var verifyCode:String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /**  @brief This method is use to call Forgot password Api
     **  @param email : String
     **/
    func ForgotPassword(email : String) {
        
    
        Helper().showSpinner(view: self.view)
     
        // let deviceToken : String?
        
        let param = [
            "email" : email
        ]
        
        let headers: HTTPHeaders = [
            "Authorization" : ""
        ]
        //        Analytics.logEvent("Forgot Password Screen", parameters: ["email":email] )
        
        
        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.FORGET_PASS + email
       
        Helper().Request_Api(url: url, methodType: .get, parameters: param, isHeaderIncluded: false, headers: headers)
        {
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
                    print(responseData)
                    self.viewVerifyCode.isHidden = false
                    self.btnVerifyCode.isHidden = false
                    self.btnSendCode.isHidden = true
                    self.txtEmail.isUserInteractionEnabled = false
                    SharedHelper().showToast(message: message, controller: self)
                    
                }
                else
                {
                    let message = responseData["message"] as! String
                    SharedHelper().showToast(message: message, controller: self)
                  
                }
            }
        }
        
    }
    
    /** @discussion verifyMain method is use to verify the provided code
     ** user add the code which he recived in email and request to verify.
     **/
    
    func verifyMain()
    {
        if(SharedHelper().isInternetAvailable())
        {
            if(!((txtVerifyCode.text?.isEmpty)!))
            {
                self.VerifyCode(code: self.txtVerifyCode.text!)
            }
            else
            {
                SharedHelper().showToast(message: "Email is missing", controller: self)
            }
        }
        else
        {
            SharedHelper().showToast(message: "Check your internet connection", controller: self)
        }
    }
    /**  @brief This method is use to call verify code api
     **  @param code : String
     **/
    func VerifyCode(code : String) {
        //        let strType = UserDefaults.standard.string(forKey: "type")
        //        var strRole="2"
        //
        
        Helper().showSpinner(view: self.view)
        // let deviceToken : String?
        
        let param = [
            "verification_code" : code
        ]
        let headers: HTTPHeaders = [
            "Authorization" : ""
        ]
        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.VERIFY_CODE + code
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
                  print(message)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                     let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "resetVC") as! ResetViewController
                        vc.verifyCode = Int(self.txtVerifyCode.text ?? "")
                        vc.email = self.txtEmail.text ?? ""
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
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSendCode(_ sender: Any) {
        self.btnVerifyCode.isHidden = true
        ForgotPassword(email: self.txtEmail.text!)
       
    }
    @IBAction func btnVerifyCode(_ sender: Any) {
       verifyMain()
        
      
    }
    @IBAction func btnAlreadyHave(_ sender: Any) {
        self.viewVerifyCode.isHidden = false
        self.btnSendCode.isHidden = true
        self.btnVerifyCode.isHidden = false
    }
}
