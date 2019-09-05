//
//  MenuController.swift
//  Example
//
//  Created by Teodor Patras on 16/06/16.
//  Copyright © 2016 teodorpatras. All rights reserved.
//

import UIKit

class MenuController: UIViewController  ,UITableViewDelegate,UITableViewDataSource{

    let dict = [["name" : "Home","segue":"HomeVC"],["name" : "Profile","segue":"ProfileVC"],["name" : "Wallet","segue":""],["name" : "My Vehicles","segue":"VehicleVC"],["name" : "Parkings","segue":""],["name" : "","segue":""],["name" : "Settings","segue":""],["name" : "Help","segue":""],["name" : "","segue":""],["name" : "Logout","segue":""]]
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
            
           
            let segue = (dictInner["segue"] as! String)
            if(segue.count>0)
            {
        sideMenuController?.performSegue(withIdentifier: segue, sender: nil)
            }
        previousIndex = indexPath as NSIndexPath?
    }
    
}
