//
//  PrivateWhenStepVC.swift
//  PeerParking
//
//  Created by Apple on 20/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import EzPopup

//struct Day {
//
//    let day: Int!
//    let startAt, endAt: String!
//
//    enum CodingKeys: String, CodingKey {
//        case day
//        case startAt = "start_at"
//        case endAt = "end_at"
//    }
//}


class PrivateWhenStepVC: UIViewController {

    //Outlets
    @IBOutlet weak var timingTblView:UITableView!
   
    
    
    //Variables
    
    //    var daysModel = [Day]()
    
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Sarurday", "Sunday"]
    
//    var day = ["day" : "", "startAt" : "", "endAt" : ""]

    var daysModel = [[String : Any]]()
    var selectedItems = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timingTblView.delegate = self
        timingTblView.dataSource = self
        
        Helper().registerTableCell(tableView: timingTblView, nibName: "TimingsCell", identifier: "TimingsCell")
    
        
    }
    

    @IBAction func alwaysSwitch(_ sender:UISwitch){
        
        if sender.isOn{
            timingTblView.isHidden = true
            GLOBAL_VAR.PRIVATE_PARKING_MODEL.removeValue(forKey: "days")
        }
        else{
            timingTblView.isHidden = false
            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(self.daysModel, forKey: "days")
        }
        
    }
    

}

extension PrivateWhenStepVC:UITableViewDelegate, UITableViewDataSource, TimePop{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimingsCell", for: indexPath) as! TimingsCell
        
        cell.delegate = self
        cell.index = indexPath.row
        cell.day.text = self.days[indexPath.row]
        cell.checkBoxOutlet.tag = indexPath.row
        if (selectedItems.contains(indexPath.row)) {
            
            cell.checkBoxOutlet.setImage(UIImage(named:"checkbox"), for: .normal)
            cell.checkBoxOutlet.isSelected = true
        }
        else {
            cell.checkBoxOutlet.setImage(UIImage(named: "uncheckbox"), for: .normal)
            cell.checkBoxOutlet.isSelected = false
        }
        cell.checkBoxOutlet.addTarget(self, action:#selector(self.buttonClicked), for: UIControl.Event.touchUpInside)
        
        return cell
    }
 
    @objc func buttonClicked(sender: UIButton) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.timingTblView.cellForRow(at: indexPath) as! TimingsCell
        
        if (self.selectedItems.contains(sender.tag)) {
        
            let index = self.selectedItems.firstIndex(of: sender.tag)!
            self.selectedItems.remove(at: index)
            
            self.daysModel.remove(at: index)
            
           
            
        }
        else {
            self.selectedItems.append(sender.tag)
            let dayCount = sender.tag + 1
            self.daysModel.append( [ "day" : dayCount, "startAt" : cell.startTime.text ?? "", "endAt" : cell.endTime.text ?? "" ] )
//            self.daysModel.append(Day(day: dayCount , startAt: cell.startTime.text, endAt: cell.endTime.text))
        }
        
        
        if(self.selectedItems.count == 0){
            GLOBAL_VAR.PRIVATE_PARKING_MODEL.removeValue(forKey: "days")
        }
        else{
            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(self.daysModel, forKey: "days")
        }
        
        self.timingTblView.reloadData()
    }
    
    func setTime(index: Int) {
        
        let indexPath = IndexPath(row: index, section: 0)
        let cell = self.timingTblView.cellForRow(at: indexPath) as! TimingsCell
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartEndPopUp") as! StartEndPopUp
        vc.startDate = cell.startTime.text ?? ""
        vc.endDate = cell.endTime.text ?? ""
        
        vc.completionBlock = {(startDtae, endDate) -> ()in
            
           
            cell.startTime.text = startDtae
            cell.endTime.text = endDate
            self.daysModel.append( [ "day" :  index+1, "startAt" : cell.startTime.text ?? "", "endAt" : cell.endTime.text ?? "" ] )
//            self.daysModel.append(Day(day: index+1 , startAt: cell.startTime.text, endAt: cell.endTime.text))
            
//            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(Double(dataReturned)!, forKey: "parking_extra_fee")
        }
        let popupVC = PopupViewController(contentController: vc, popupWidth: 320, popupHeight: 350)
        popupVC.canTapOutsideToDismiss = true
        
        //properties
        // popupVC.backgroundAlpha = 1
        // popupVC.backgroundColor = .black
        // popupVC.canTapOutsideToDismiss = true
        popupVC.cornerRadius = 10
        // popupVC.shadowEnabled = true
        
        // show it by call present(_ , animated:) method from a current UIViewController
        self.present(popupVC, animated: true)
//        Helper().showToast(message: "\(index)", controller: self)
    }
    
   
}
