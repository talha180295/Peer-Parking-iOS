//
//  MySpotParkingDetail.swift
//  PeerParking
//
//  Created by APPLE on 5/27/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import Foundation
import UIKit
import EzPopup

class MySpotParkingDetailVC : UIViewController{
    
    
    //Outlets
    @IBOutlet weak var timingTblView:UITableView!
    
     


    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Sarurday", "Sunday"]
        
    //    var day = ["day" : "", "start_at" : "", "end_at" : ""]

    var daysModel = [[String : Any]]()
    var selectedItems = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timingTblView.delegate = self
        timingTblView.dataSource = self
        
        Helper().registerTableCell(tableView: timingTblView, nibName: "TimingsCell", identifier: "TimingsCell")
        
        
        GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(0, forKey: "is_always")
        
    }
    
    
    @IBAction func alwaysSwitch(_ sender:UISwitch){
        
        if sender.isOn{
            timingTblView.isHidden = true
            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(1, forKey: "is_always")
            GLOBAL_VAR.PRIVATE_PARKING_MODEL.removeValue(forKey: "days")
        }
        else{
            timingTblView.isHidden = false
            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(0, forKey: "is_always")
            
            
            let depStr = filterString(str: self.daysModel.description)
            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(depStr, forKey: "days")
            //            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(self.daysModel, forKey: "days")
        }
        
    }
    
    func filterString(str:String) -> String{
        
        let  depStr = str.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "[[", with: "[{").replacingOccurrences(of: "],[", with: "},{").replacingOccurrences(of: "]]", with: "}]").replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: "),", with: ",").replacingOccurrences(of: ")", with: "")
        
        return depStr
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.dismiss(animated: false)
        
    }
}

extension MySpotParkingDetailVC:UITableViewDelegate, UITableViewDataSource, TimePop{
    
    
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
            
            let s_dateAsString = cell.startTime.text ?? ""
            let e_dateAsString = cell.endTime.text ?? ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            
            let date1 = dateFormatter.date(from: s_dateAsString)
            let date2 = dateFormatter.date(from: e_dateAsString)
            
            dateFormatter.dateFormat = "HH:mm"
            let s_time24 = dateFormatter.string(from: date1!)
            let e_time24 = dateFormatter.string(from: date2!)
            
            
            self.daysModel.append( [ "day" : dayCount, "start_at" : s_time24, "end_at" : e_time24 ] )
        }
        
        
        if(self.selectedItems.count == 0){
            GLOBAL_VAR.PRIVATE_PARKING_MODEL.removeValue(forKey: "days")
        }
        else{
            
            let depStr = filterString(str: self.daysModel.description)
             
            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(depStr, forKey: "days")
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
            
            let s_dateAsString = startDtae
            let e_dateAsString = endDate

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"

            let date1 = dateFormatter.date(from: s_dateAsString)
            let date2 = dateFormatter.date(from: e_dateAsString)

            dateFormatter.dateFormat = "HH:mm"
            let s_time24 = dateFormatter.string(from: date1!)
            let e_time24 = dateFormatter.string(from: date2!)
            
//            print("index=\(index+1)")
            var i = 0
            for item in self.daysModel{
                if(item["day"] as? Int == index+1){
                    self.daysModel.remove(at: i)
                }
                i+=1
            }
            
            self.daysModel.append( [ "day" :  index+1, "start_at" : s_time24, "end_at" : e_time24 ] )
            
            
            let depStr = self.filterString(str: self.daysModel.description)
           
            
            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(depStr, forKey: "days")
            
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
