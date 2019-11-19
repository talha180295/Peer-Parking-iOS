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
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblRoute.dequeueReusableCell(withIdentifier: "RoutesCell") as! RoutesCell
        
        
        cell.selectionStyle = .none
        return  cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func back_btn(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
