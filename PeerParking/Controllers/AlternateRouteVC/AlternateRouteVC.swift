//
//  AlternateRouteVC.swift
//  PeerParking
//
//  Created by Apple on 23/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import SwiftyJSON

class AlternateRouteVC: UIViewController ,UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tblRoute: UITableView!
    
    var alternateRoutes:[JSON]!
    var arrAlternate : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        arrAlternate = alternateRoutes
        
        tblRoute.dataSource = self
        tblRoute.delegate = self
        
        tblRoute.register(UINib(nibName: "RoutesCell", bundle: nil), forCellReuseIdentifier: "RoutesCell")
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return transactionArr.count
        return arrAlternate.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblRoute.dequeueReusableCell(withIdentifier: "RoutesCell") as! RoutesCell
        if(arrAlternate.count>0)
        {
            let dict = arrAlternate[indexPath.row] as! NSDictionary
            
            let leg = dict["legs"] as! [Any]
            let legDict = leg[0] as! NSDictionary
            let distanceDict = legDict["distance"] as! NSDictionary
            let distance = distanceDict["text"] as! String
            cell.lblDistance.text = distance + "Away"
            
            let durationDict = legDict["duration"] as! NSDictionary
            let duration = durationDict["text"] as! String
            cell.lblTime.text = duration
            
            let end_address = legDict["end_address"] as! String
            cell.lblName.text = end_address
            
            
        }
        
        cell.selectionStyle = .none
        return  cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func back_btn(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
