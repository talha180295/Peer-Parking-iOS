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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "customVC") as! CustomSideMenuController
            //
            self.present(vc, animated: true, completion: nil)
//            self.img.image =  UIImage.init(named: "mainLogo")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                if ((UserDefaults.standard.object(forKey: "login")) == nil) {
//                    UserDefaults.standard.set("no", forKey: "login")
//
//                    UserDefaults.standard.synchronize()
//
//
//
//
//
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "laguageVC") as! LanguageViewController
//
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//                else
//                {
//                    let isLogin :String = UserDefaults.standard.string(forKey: "login")!
//
//                    if(isLogin.elementsEqual("yes"))
//                    {
//
//                        let type :String = UserDefaults.standard.string(forKey: "type")!
//                        if(type.elementsEqual("customer"))
//                        {
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! ViewController
//                            //
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                        else
//                        {
//
//
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "customVC") as! CustomSideMenuController
//                            //
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//
//
//                        //                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "customVC") as! CustomSideMenuController
//                        //                    self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                    else if(isLogin.elementsEqual("no"))
//                    {
//
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "laguageVC") as! LanguageViewController
//
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                }
//            };
        };
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
