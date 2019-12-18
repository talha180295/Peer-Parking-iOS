//
//  RequestVC.swift
//  PeerParking
//
//  Created by Apple on 07/11/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import Alamofire

class RequestVC: UIViewController ,UITableViewDataSource,UITableViewDelegate, ViewOfferProtocol {
  
    
    
    
    var requests:[Any] = []
    var auth_value = ""
    
    @IBOutlet weak var tblNotification: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblNotification.tableFooterView = UIView()
        tblNotification.dataSource = self
        tblNotification.delegate = self
        
        tblNotification.register(UINib(nibName: "RequestCell", bundle: nil), forCellReuseIdentifier: "RequestCell")
        // Do any additional setup after loading the view.
        self.tblNotification.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "headerCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        

        get_all_requests(isHeaderIncluded: true){

        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // return the number of rows in the specified section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        switch (section) {
        case 0:
            rowCount = 2
        case 1:
            rowCount = 2
        case 2:
            rowCount = 2
        default:
            rowCount = 0
        }
        
//        return rowCount
        return self.requests.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    // Header Cell
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCell

        headerCell.month.text = "December"

        return headerCell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblNotification.dequeueReusableCell(withIdentifier: "RequestCell") as! RequestCell
        cell.delegate = self
        
        if(requests.count>0){
            
            
            let dict = requests[indexPath.row] as! NSDictionary
            print("bargaining=\(dict)")
            
            
            let parking = dict["parking"] as! NSDictionary
            
            
            if let p_address = parking["address"] as? String{
                
                Helper().showToast(message: p_address, controller: self)
            }
            
        }
          
            
        
        return  cell;
    }
    
    //protocol function
    func ViewOfferButtonDidSelect() {
        
//        
//        helper.bottomSheet(storyBoard: "Main",identifier: "OfferBottomSheetVC", sizes: [.fixed(420)],cornerRadius: 0, handleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), view_controller: self)
//        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OfferBottomSheetVC")
        
        
        Helper().bottomSheet(controller: controller, sizes: [.fixed(500),.fullScreen],cornerRadius: 0, handleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), view_controller: self)
    }
    
    
    func get_all_requests(isHeaderIncluded:Bool,completion: @escaping () -> Void){//(withToken:Bool,completion: @escaping (JSON) -> Void){
        
        
        requests = []
        
        let params = [
            
            "is_mine": 1
            
        ]
        
        print("param123=\(params)")
        
       
        
        if let value : String = UserDefaults.standard.string(forKey: "auth_token"){
            
            auth_value = "bearer " + value
        }
        
        
        let headers: HTTPHeaders = [
            "Authorization" : auth_value
        ]
        
        
        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.BARGAININGS
        
        print("BARGAININGS_url=\(url)")
        
        Helper().Request_Api(url: url, methodType: .get, parameters: params, isHeaderIncluded: isHeaderIncluded, headers: headers){
            response in
            //print("response=\(response)")
            if response.result.value == nil {
                print("No response")
                
                Helper().showToast(message: "Internal Server Error", controller: self)
                completion()
                return
            }
            else{
                let responseData = response.result.value as! NSDictionary
                let status = responseData["success"] as! Bool
                if(status){
                  
//                    let message = responseData["message"] as! String
                    let data = responseData["data"] as! [Any]
                   
                    self.requests = data
                    print("parkings.count=\(self.requests.count)")
                    
                    
                    self.tblNotification.reloadData()
                    //SharedHelper().showToast(message: message, controller: self)
                    
                    completion()
                  
                        
                }
                else
                {
                    let message = responseData["message"] as! String
                    Helper().showToast(message: message, controller: self)
                    //   SharedHelper().hideSpinner(view: self.view)
                    completion()
                }
            }
        }
        
    }
    
    
        
//        //protocol function
//        func ViewOfferButtonDidSelect() {
//
//            //
//            //        helper.bottomSheet(storyBoard: "Main",identifier: "OfferBottomSheetVC", sizes: [.fixed(420)],cornerRadius: 0, handleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), view_controller: self)
//            //
//            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OfferBottomSheetVC")
//
//
//            Helper().bottomSheet(controller: controller, sizes: [.fixed(500),.fullScreen],cornerRadius: 0, handleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), view_controller: self)
//        }
}
