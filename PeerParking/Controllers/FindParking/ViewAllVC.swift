//
//  ViewAllVC.swift
//  PeerParking
//
//  Created by Apple on 06/11/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class ViewAllVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var my_table_view: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        my_table_view.register(UINib(nibName: "Parking_table_cell", bundle: nil), forCellReuseIdentifier: "Parking_table_cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return transactionArr.count
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = my_table_view.dequeueReusableCell(withIdentifier: "Parking_table_cell") as! Parking_table_cell
        
        
       // cell.selectionStyle = .none
        return  cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
  

}
