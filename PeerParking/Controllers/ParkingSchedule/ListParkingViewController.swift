//
//  ListParkingViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 11/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class ListParkingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var btnS: UIButton!
    @IBOutlet weak var btnH: UIButton!
    @IBOutlet weak var tblHistory: UITableView!
    @IBOutlet weak var tblParking: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblHistory.dataSource =  self
        tblHistory.delegate = self
        
        tblHistory.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        
        tblParking.dataSource =  self
        tblParking.delegate = self
        
        tblParking.register(UINib(nibName: "ScheduledCell", bundle: nil), forCellReuseIdentifier: "ScheduledCell")
        // Do any additional setup after loading the view.
        self.tblParking.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "headerCell")
        
            self.tblHistory.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "headerCell")
        
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
        let cell = tblHistory.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        
        if(tableView == tblHistory)
        {
            cell.selectionStyle = .none
            return  cell;
        }
        else if(tableView == tblParking)
        {
             let cell = tblParking.dequeueReusableCell(withIdentifier: "ScheduledCell") as! ScheduledCell
            cell.selectionStyle = .none
            return  cell;
        }
        cell.selectionStyle = .none
        return  cell;
    }
    
   
    
    @IBAction func btnHistory(_ sender: Any) {
        
        tblParking.isHidden = true
        tblHistory.isHidden = false
        btnH.setBackgroundImage(UIImage.init(named: "big_white_btn"), for: .normal)
        btnS.setBackgroundImage(UIImage.init(named: ""), for: .normal)
        
    }
    
    @IBAction func btnScheduled(_ sender: Any) {
        tblParking.isHidden = false
        tblHistory.isHidden = true
        btnS.setBackgroundImage(UIImage.init(named: "big_white_btn"), for: .normal)
        btnH.setBackgroundImage(UIImage.init(named: ""), for: .normal)
        
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
