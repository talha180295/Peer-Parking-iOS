//
//  NotificationViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 11/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tblNotification: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tblNotification.dataSource = self
        tblNotification.delegate = self
        
        tblNotification.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return transactionArr.count
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblNotification.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        
       
        cell.selectionStyle = .none
        return  cell;
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
