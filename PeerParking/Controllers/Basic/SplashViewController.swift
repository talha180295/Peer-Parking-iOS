//
//  SplashViewController.swift
//  Mantra
//
//  Created by Munzareen Atique on 08/07/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

/// @brief Login View Controller is use as the first screen of the app
class SplashViewController: UIViewController {
  
    
    /// @abstract Viewdidload method
    
    @IBOutlet weak var app_version: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UserDefaults.standard.set("no", forKey: "login")
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
           if(Helper().IsUserLogin()){
                 self.refreshToken()
             }
             
             
             let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
             let app_build_Version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
             
             print("appVersion=\(appVersion!)(\(app_build_Version!))")
             
             self.app_version.text = "v \(appVersion!)(\(app_build_Version!))"
             
            
             DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                 
                 
                 
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "customVC") as! CustomSideMenuController
                 //
                 
                 self.navigationController?.pushViewController(vc, animated: true)

             };
    }
   
    func refreshToken(){
        
        let url = APIRouter.refresh
        let decoder = ResponseData<RefreshTokenModel>.self
        
        APIClient.serverRequest(url: url, path: url.getPath(), dec: decoder) { (response, error) in
            
                        
            if(response != nil){
                if let success = response?.success {
            //                    Helper().showToast(message: "Succes=\(success)", controller: self)
                    if let val = response?.data {
                        
                        UserDefaults.standard.set(val.user?.accessToken, forKey: APP_CONSTANT.ACCESSTOKEN)
                        UserDefaults.standard.synchronize()
                    }
                }
                else{
                    Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                }
            }
            else if(error != nil){
                Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
            }
            else{
                Helper().showToast(message: "Nor Response and Error!!", controller: self)
            }
        }
    }
    

}
