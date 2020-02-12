//
//  AlternateRouteViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 11/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import SwiftyJSON

class AlternateRouteViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblRoute: UITableView!
    
        var alternateRoutes:[Route]!
        var arrAlternate : [Any] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
           
            
            tblRoute.dataSource = self
            tblRoute.delegate = self
            
            tblRoute.register(UINib(nibName: "RoutesCell", bundle: nil), forCellReuseIdentifier: "RoutesCell")
            // Do any additional setup after loading the view.
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //        return transactionArr.count
            return alternateRoutes.count;
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tblRoute.dequeueReusableCell(withIdentifier: "RoutesCell") as! RoutesCell
            if(alternateRoutes.count>0)
            {
                let dict = alternateRoutes[indexPath.row]
                
                
                
                let leg = dict.legs
               let legDict = leg?[0]
                let dictanceDict = legDict?.distance
                let distance = dictanceDict?.text
                cell.lblDistance.text = distance! + "Away"
                let durationDict = legDict?.duration
                let duration = durationDict?.text
                cell.lblTime.text = duration
                
                let end_address = legDict?.endAddress
                cell.lblName.text = end_address
                
                
            }
            
            cell.selectionStyle = .none
            return  cell;
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let dict = alternateRoutes[indexPath.row]
           
            NotificationCenter.default.post(name: Notification.Name(rawValue: "NotificationRemoveRoute"), object: nil , userInfo: ["dict":dict])
            self.dismiss(animated: true, completion: nil)
            
        }
        
        @IBAction func back_btn(_ sender: UIButton) {
            
            self.dismiss(animated: true, completion: nil)
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

