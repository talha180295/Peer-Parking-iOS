//
//  AlternateRouteViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 11/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class AlternateRouteViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblRoute: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tblRoute.dataSource = self
        tblRoute.delegate = self
        
        tblRoute.register(UINib(nibName: "RoutesCell", bundle: nil), forCellReuseIdentifier: "routeCell")
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return transactionArr.count
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblRoute.dequeueReusableCell(withIdentifier: "routeCell") as! RoutesCell
        
        
        cell.selectionStyle = .none
        return  cell;
    }
    
    

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
