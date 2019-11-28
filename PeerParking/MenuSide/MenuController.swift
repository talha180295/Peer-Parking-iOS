//
//  MenuController.swift
//  Example
//
//  Created by Teodor Patras on 16/06/16.
//  Copyright © 2016 teodorpatras. All rights reserved.
//

import UIKit
import HelperClassPod
import Alamofire

class MenuController: UIViewController  ,UITableViewDelegate,UITableViewDataSource{

    let dict = [["name" : "Home","segue":"HomeVC"],["name" : "Profile","segue":"ProfileVC"],["name" : "Wallet","segue":"WalletVC"],["name" : "Parkings","segue":"parkingVC"],
                ["name" : "Requests","segue":"requestVC"],["name" : "Notifications","segue":"NotificationVC"],["name" : "","segue":""],["name" : "Settings","segue":"SettingVC"],["name" : "Help","segue":"helpVC"],["name" : "","segue":""],["name" : "Logout","segue":""]]
    let segues = ["showCenterController1", "showCenterController2", "showCenterController3"]
    private var previousIndex: NSIndexPath?
    
    @IBOutlet weak var tblMenu: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tblMenu.delegate =  self
        tblMenu.dataSource = self
        tblMenu.register(UINib(nibName: "menuCell", bundle: nil), forCellReuseIdentifier: "cellItem")
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dict.count
    }

         func tableView(_ tableView: UITableView,
                                cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            let dictInner = dict[indexPath.row] as NSDictionary
            
            let cell = tblMenu.dequeueReusableCell(withIdentifier: "cellItem") as! menuCell
            let nameStr = (dictInner["name"] as! String)
            if(nameStr.count>0)
            {
                cell.lblName?.text = nameStr
            }
            else
            {
                cell.viewLine.isHidden = true
            }
            

        return cell
    }

         func tableView(_ tableView: UITableView,
                                didSelectRowAt indexPath: IndexPath)  {

        if let index = previousIndex {
            tableView.deselectRow(at: index as IndexPath, animated: true)
        }

            let dictInner = dict[indexPath.row] as NSDictionary
            let nameStr = dictInner["name"] as! String
            if(nameStr.elementsEqual("Logout"))
            {
                //
                logOut()
            }
            else
            {
            
           
            let segue = (dictInner["segue"] as! String)
            if(segue.count>0)
            {
                sideMenuController?.performSegue(withIdentifier: segue, sender: nil)
            }
                
            }
        previousIndex = indexPath as NSIndexPath?
    }
    
    
    func logOut() {
        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.LOGOUT
        
        let auth_value =  "Bearer \(UserDefaults.standard.string(forKey: "auth_token")!)"
        let headers: HTTPHeaders = [
            "Authorization" : auth_value
        ]
        
        SharedHelper().Request_Api(url: url, methodType: .post, parameters: [:], isHeaderIncluded: true, headers: headers){
            response in
            
            if response.result.value == nil {
                print("No response")
               // SharedHelper().hideSpinner(view: self.view)
                return
            }
            else {
                let responseData = response.result.value as! NSDictionary
                let status = responseData["success"] as! Bool
                if(status)
                    //                {  let fcmToken :String = UserDefaults.standard.string(forKey: "FCMToken")!
                {
                    //                    let user_id : String = UserDefaults.standard.string(forKey: "id")!
                    self.resetDefaults()
                    // UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
                    UserDefaults.standard.set("no", forKey: "login")
                    UserDefaults.standard.synchronize()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "customVC") as! CustomSideMenuController
                    //
                    self.navigationController?.pushViewController(vc, animated: true)
                    // UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
                }
                else
                {
                    let messageDict = responseData["meta"] as! NSDictionary
                    //                    let msg = messageDict["message" ] as! String
                   // SharedHelper().hideSpinner(view: self.view)
                    UserDefaults.standard.set("no", forKey: "login")
                    UserDefaults.standard.synchronize()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "customVC") as! CustomSideMenuController
                    //
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
//        SharedHelper().dynamicPostRequestWithoutParam(url: url)    {
//            response in
//            print(response)
//            if response.result.value == nil {
//                print("No response")
//                SharedHelper().hideSpinner(view: self.view)
//                return
//            }
//            else {
//                let responseData = response.result.value as! NSDictionary
//                let status = responseData["success"] as! Bool
//                if(status)
//                    //                {  let fcmToken :String = UserDefaults.standard.string(forKey: "FCMToken")!
//                {
//                    //                    let user_id : String = UserDefaults.standard.string(forKey: "id")!
//                    self.resetDefaults()
//                    // UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
//                    UserDefaults.standard.set("no", forKey: "login")
//                    UserDefaults.standard.synchronize()
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    // UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
//                }
//                else
//                {
//                    let messageDict = responseData["meta"] as! NSDictionary
//                    //                    let msg = messageDict["message" ] as! String
//                    SharedHelper().hideSpinner(view: self.view)
//                    UserDefaults.standard.set("no", forKey: "login")
//                    UserDefaults.standard.synchronize()
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            }
//        }
    }
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
