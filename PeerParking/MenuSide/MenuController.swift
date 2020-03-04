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
import EzPopup
import FacebookLogin
import FacebookCore


class MenuController: UIViewController  ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var top_view_height_contr: NSLayoutConstraint!
    
    let story = UIStoryboard(name: "Main", bundle: nil)
    
    let dict1 = [["name" : "Home","segue":"HomeVC"],["name" : "Profile","segue":"ProfileVC"],["name" : "Wallet","segue":"WalletVC"],["name" : "Parkings","segue":"parkingVC"],
                ["name" : "Requests","segue":"requestVC"],["name" : "","segue":""],["name" : "Settings","segue":"SettingVC"],["name" : "Help","segue":"helpVC"],["name" : "","segue":""],["name" : "Logout","segue":""]]
    
    
    let dict2 = [["name" : "Settings","segue":""],["name" : "Help","segue":""],["name" : "","segue":""], ["name" : "Login","segue":""]]
    
    
    
    let segues = ["showCenterController1", "showCenterController2", "showCenterController3"]
    private var previousIndex: NSIndexPath?
    
    @IBOutlet weak var tblMenu: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.img.clipsToBounds = true
        var imag:String!
        if UserDefaults.standard.string(forKey: "image_url") == nil{
            imag = ""
        }
        else{
            imag =  UserDefaults.standard.string(forKey: "image_url")!
            
            
                    img.sd_setImage(with: URL(string: imag),placeholderImage: UIImage.init(named: "placeholder_user") )
        }

        tblMenu.delegate =  self
        tblMenu.dataSource = self
        tblMenu.register(UINib(nibName: "menuCell", bundle: nil), forCellReuseIdentifier: "cellItem")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(!IsUserLogin()){
            top_view_height_contr.constant = 0
        }
        else{
            top_view_height_contr.constant = 210
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reload_table(notification:)), name: NSNotification.Name(rawValue: "reload_table"), object: nil)
        
//        self.img.sd_setImage(with: URL(string: UserDefaults.standard.string(forKey: "image") ?? ""),placeholderImage: UIImage.init(named: "placeholder-img") )
        self.name.text = UserDefaults.standard.string(forKey: "full_name")
    }
//    override func viewDidAppear(_ animated: Bool) {
//
//        print("tblMenu.reloadData()")
//        tblMenu.reloadData()
//    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
    }

    @objc func reload_table(notification: NSNotification) {
        
        if(!IsUserLogin()){
            top_view_height_contr.constant = 0
        }
        else{
            top_view_height_contr.constant = 210
        }
        self.img.sd_setImage(with: URL(string: UserDefaults.standard.string(forKey: "image") ?? ""),placeholderImage: UIImage.init(named: "placeholder-img") )
        self.name.text = UserDefaults.standard.string(forKey: "full_name")
        print("tblMenu.reloadData()")
        tblMenu.reloadData()
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let isLogin = IsUserLogin()
        if(isLogin)
        {
            return dict1.count
        }
        else
        {
            return dict2.count
        }
        
        
    }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            let dictInner:NSDictionary!
            
            let isLogin = IsUserLogin()
            if(isLogin)
            {
                dictInner = dict1[indexPath.row] as NSDictionary
            }
            else
            {
                dictInner = dict2[indexPath.row] as NSDictionary
            }
            
            let cell = tblMenu.dequeueReusableCell(withIdentifier: "cellItem") as! menuCell
            let nameStr = (dictInner["name"] as! String)
            if(nameStr.count>0)
            {
                cell.lblName?.text = nameStr
            }
            else
            {
                cell.viewLine.isHidden = true
                cell.selectionStyle = .none
            }
            

            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {

            if let index = previousIndex {
                tableView.deselectRow(at: index as IndexPath, animated: true)
            }

            let dictInner:NSDictionary!
            
            let isLogin = IsUserLogin()
            if(isLogin)
            {
                dictInner = dict1[indexPath.row] as NSDictionary
            }
            else
            {
                dictInner = dict2[indexPath.row] as NSDictionary
            }
            
            
            let nameStr = dictInner["name"] as! String
            
            if(nameStr.elementsEqual("Logout"))
            {
                //
                let isLogin = IsUserLogin()
                if(isLogin)
                {
                    let alert = UIAlertController(title: "Alert", message: "Are sure to Logout?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { action in

                        // do something like...
                        self.tblMenu.reloadData()
                        self.logOut()

                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { action in

                        // do something like...
                        self.dismiss(animated: true, completion: nil)

                    }))
                    self.present(alert, animated: true, completion: nil)
                   
                }
                else
                {
                   
                }
                
            }
            else if(nameStr.elementsEqual("Login"))
            {
                //
                let isLogin = IsUserLogin()
                if(isLogin)
                {
//                    tblMenu.reloadData()
//                    logOut()
                }
                else
                {
                    tblMenu.reloadData()
                    logIn()
                }
                
            }
            else
            {
            
           
                let segue = (dictInner["segue"] as! String)
                if(segue.count>0)
                {
                    if(segue == "HomeVC"){
                        tab_index = 1
                    }
                    sideMenuController?.performSegue(withIdentifier: segue, sender: nil)
                }
                
            }
        previousIndex = indexPath as NSIndexPath?
    }
    
    
    func logOut() {
        
//        let loginManager = LoginManager()
//        if let accessToken = AccessToken.current{
//            print(accessToken)
//            loginManager.logOut()
//        }
        
        Helper().showSpinner(view: RootViewController().view)
        loginManager.logOut()
        
        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.LOGOUT
        
        let auth_value =  "Bearer \(UserDefaults.standard.string(forKey: "auth_token")!)"
        let headers: HTTPHeaders = [
            "Authorization" : auth_value
        ]
        
        Helper().Request_Api(url: url, methodType: .post, parameters: [:], isHeaderIncluded: true, headers: headers){
            response in
            Helper().hideSpinner(view: RootViewController().view)
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
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "customVC") as! CustomSideMenuController
//                    //
//                    self.navigationController?.pushViewController(vc, animated: true)
                    // UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
                }
                else
                {
                    let messageDict = responseData["meta"] as! NSDictionary
                    //                    let msg = messageDict["message" ] as! String
                   // SharedHelper().hideSpinner(view: self.view)
                    UserDefaults.standard.set("no", forKey: "login")
                    UserDefaults.standard.synchronize()
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "customVC") as! CustomSideMenuController
//                    //
//                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                Helper().presentOnMainScreens(controller: self, index: 1)
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
    
    func logIn(){
        
        let vc = self.story.instantiateViewController(withIdentifier: "FBPopup") as? FBPopup
        
        vc?.source = "sideMenu"
        let popupVC = PopupViewController(contentController: vc!, popupWidth: 320, popupHeight: 365)
        popupVC.canTapOutsideToDismiss = true
        
        //properties
        //            popupVC.backgroundAlpha = 1
        //            popupVC.backgroundColor = .black
        //            popupVC.canTapOutsideToDismiss = true
        //            popupVC.cornerRadius = 10
        //            popupVC.shadowEnabled = true
        
        // show it by call present(_ , animated:) method from a current UIViewController
        present(popupVC, animated: true)
    }
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
