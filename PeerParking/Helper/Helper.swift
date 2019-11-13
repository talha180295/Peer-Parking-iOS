//
//  Helper.swift
//  PeerParking
//
//  Created by Apple on 07/11/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import Foundation
import FittedSheets

class Helper{
    
    func bottomSheet(storyBoard:String,identifier:String,sizes:[SheetSize], cornerRadius:CGFloat, handleColor:UIColor,view_controller:UIViewController){
        
        let controller = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        
        
        
        let sheetController = SheetViewController(controller: controller, sizes: sizes)
        //        // Turn off Handle
        sheetController.handleColor = handleColor
        // Turn off rounded corners
        sheetController.topCornersRadius = cornerRadius
        
        view_controller.present(sheetController, animated: false, completion: nil)
    }
    
    
    func IsUserLogin() -> Bool {
        if ((UserDefaults.standard.object(forKey: "login")) == nil) {
            return false
        }
        else
        {
            let isLogin = UserDefaults.standard.string(forKey: "login")!
            if(isLogin.elementsEqual("yes"))
            {
                return true
            }
            else
            {
                return false
            }
        }
    }
    
}
