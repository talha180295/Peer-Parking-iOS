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
    
        var alternateRoutes:[JSON]!
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
                let dict = alternateRoutes[indexPath.row].dictionary
                
                
                let leg = dict!["legs"]?.arrayValue
               let legDict = leg![0].dictionary
               let dictanceDict = legDict!["distance"]?.dictionary
               let distance = dictanceDict?["text"]?.stringValue
                cell.lblDistance.text = distance! + "Away"
               let durationDict = legDict!["duration"]?.dictionary
               let duration = durationDict?["text"]?.stringValue
                cell.lblTime.text = duration
                
                 let end_address = legDict!["end_address"]?.stringValue
                cell.lblName.text = end_address
                
                
            }
            
            cell.selectionStyle = .none
            return  cell;
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let dict = alternateRoutes[indexPath.row].dictionary
           
            NotificationCenter.default.post(name: Notification.Name(rawValue: "NotificationName"), object: nil , userInfo: dict)
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
