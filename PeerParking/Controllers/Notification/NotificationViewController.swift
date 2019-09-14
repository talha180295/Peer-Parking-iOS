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
        self.tblNotification.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "headerCell")
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
        
        return rowCount
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    // Header Cell
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCell
        
        
        
        
        return headerCell
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
