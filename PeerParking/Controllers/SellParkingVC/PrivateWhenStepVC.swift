//
//  PrivateWhenStepVC.swift
//  PeerParking
//
//  Created by Apple on 20/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import EzPopup

class PrivateWhenStepVC: UIViewController {

    //Outlets
    @IBOutlet weak var timingTblView:UITableView!
   
    
    //Variables
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Sarurday", "Sunday"]
    var selectedItems = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timingTblView.delegate = self
        timingTblView.dataSource = self
        
        Helper().registerTableCell(tableView: timingTblView, nibName: "TimingsCell", identifier: "TimingsCell")
    
        // Do any additional setup after loading the view.
    }
    

    @IBAction func alwaysSwitch(_ sender:UISwitch){
        
        if sender.isOn{
            timingTblView.isHidden = true
        }
        else{
             timingTblView.isHidden = false
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
         if (self.selectedItems.contains(sender.tag)) {
            let index = self.selectedItems.firstIndex(of: sender.tag)!
              self.selectedItems.remove(at: index)
         }
         else {
              self.selectedItems.append(sender.tag)
         }
         self.timingTblView.reloadData()
    }
    
    func setTime(index: Int) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartEndPopUp") as! StartEndPopUp
        
        let popupVC = PopupViewController(contentController: vc, popupWidth: 320, popupHeight: 350)
        popupVC.canTapOutsideToDismiss = true
        
        //properties
        //            popupVC.backgroundAlpha = 1
        //            popupVC.backgroundColor = .black
        //            popupVC.canTapOutsideToDismiss = true
                    popupVC.cornerRadius = 10
        //            popupVC.shadowEnabled = true
        
        // show it by call present(_ , animated:) method from a current UIViewController
        self.present(popupVC, animated: true)
//        Helper().showToast(message: "\(index)", controller: self)
    }
    
   
}
