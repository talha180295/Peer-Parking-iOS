//
//  RequestVC.swift
//  PeerParking
//
//  Created by Apple on 07/11/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class RequestVC: UIViewController ,UITableViewDataSource,UITableViewDelegate, ViewOfferProtocol {
  
    
    let helper = Helper()
    
    
    
    @IBOutlet weak var tblNotification: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblNotification.dataSource = self
        tblNotification.delegate = self
        
        tblNotification.register(UINib(nibName: "RequestCell", bundle: nil), forCellReuseIdentifier: "RequestCell")
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
        let cell = tblNotification.dequeueReusableCell(withIdentifier: "RequestCell") as! RequestCell
        
        
        cell.selectionStyle = .none
        cell.delegate = self
        return  cell;
    }
    
    //protocol function
    func ViewOfferButtonDidSelect() {
        
        
           helper.bottomSheet(storyBoard: "Main",identifier: "BottomSheetVC", sizes: [.fixed(500),.fullScreen],cornerRadius: 0, handleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), view_controller: self)
    }
    
}
