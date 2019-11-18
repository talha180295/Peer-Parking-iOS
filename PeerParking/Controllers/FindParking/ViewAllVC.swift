//
//  ViewAllVC.swift
//  PeerParking
//
//  Created by Apple on 06/11/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class ViewAllVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var parkings:[Any] = []
    
    @IBOutlet weak var my_table_view: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        my_table_view.register(UINib(nibName: "Parking_table_cell", bundle: nil), forCellReuseIdentifier: "Parking_table_cell")
        
        let dict = parkings[0] as! NSDictionary
        print("viewall=\(dict)")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return transactionArr.count
        return parkings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = my_table_view.dequeueReusableCell(withIdentifier: "Parking_table_cell") as! Parking_table_cell
       
        if(parkings.count>0){
            let dict = parkings[indexPath.row] as! NSDictionary
            print(dict)
            if(dict["address"] is NSNull)
            {
                
            }
            else
            {
                cell.parking_title.text = (dict["address"] as! String)
            }
            //cell.setData(empReqObj: arrModel[indexPath.row])
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.navigationController?.popViewController(animated: true)
    }
  
    @IBAction func back_btn(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    
}
