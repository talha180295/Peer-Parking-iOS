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


protocol MySpotParkingDetailVCDelegate : NSObjectProtocol {
    func didBackButtonPressed()
}
class MySpotParkingDetailVC : UIViewController{
    
    
    //Delegates
    var delegate:MySpotParkingDetailVCDelegate!
    
    //Intent Variables
    private var parkingModel:Parking!
    private var privateParkingModel:PrivateParkingModel!
    var isPublicParking:Bool = false
    
    //Outlets
    @IBOutlet weak var timingTblView:UITableView!
    @IBOutlet weak var image:UIImageView!
    @IBOutlet weak var parkingTitle:UITextField!
    @IBOutlet weak var location:UILabel!
    @IBOutlet weak var price:UILabel!
    @IBOutlet weak var type:UILabel!
    @IBOutlet weak var size:UILabel!
    @IBOutlet weak var date:UILabel!
    @IBOutlet weak var timingsCard: CardView!
    @IBOutlet weak var availableOnCard: CardView!
    @IBOutlet weak var availableSwitch: UISwitch!
    @IBOutlet weak var negotiableSwitch: UISwitch!
    @IBOutlet weak var isAlwaysSwitch: UISwitch!
    @IBOutlet weak var timeSwitch: UISwitch!
    
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Sarurday", "Sunday"]
    
    //    var day = ["day" : "", "start_at" : "", "end_at" : ""]
    
    var daysModel = [Slot]()
    var selectedItems = [Int]()
    var seletedCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timingTblView.delegate = self
        timingTblView.dataSource = self
        timingTblView.isScrollEnabled = false
        Helper().registerTableCell(tableView: timingTblView, nibName: "TimingsCell", identifier: "TimingsCell")
        
        if isPublicParking{
            self.setPublicData(data: self.parkingModel)
        }
        else{
            self.setPrivateData(data: self.privateParkingModel)
        }
        
    }
    
    func setParingModel(parkingModel: Parking){
        self.parkingModel = parkingModel
    }
    func setPrivateParingModel(privateParkingModel: PrivateParkingModel){
        self.privateParkingModel = privateParkingModel
    }
    
    @IBAction func alwaysSwitch(_ sender:UISwitch){
        
        if sender.isOn{
            //            timingTblView.isHidden = true
            //            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(1, forKey: "is_always")
            //            GLOBAL_VAR.PRIVATE_PARKING_MODEL.removeValue(forKey: "days")
        }
        else{
            //            timingTblView.isHidden = false
            //            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(0, forKey: "is_always")
            //
            //
            //            let depStr = filterString(str: self.daysModel.description)
            //            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(depStr, forKey: "days")
            //            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(self.daysModel, forKey: "days")
        }
        
    }
    
    func filterString(str:String) -> String{
        
        let  depStr = str.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "[[", with: "[{").replacingOccurrences(of: "],[", with: "},{").replacingOccurrences(of: "]]", with: "}]").replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: "),", with: ",").replacingOccurrences(of: ")", with: "")
        
        return depStr
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.dismiss(animated: true){
            if self.isPublicParking{
                self.delegate.didBackButtonPressed()
            }
        }
        
    }
    
    @IBAction func updateBtn(_ sender: UIButton) {
        
        if isPublicParking{
            self.updatePublicParking()
        }
        else{
            self.updatePrivateParking()
        }
        
    }
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        
        self.showDeleteParkingConfirmationDialog()
    
    }
}

//Ui methods
extension MySpotParkingDetailVC{
    
    
}
//Data methods
extension MySpotParkingDetailVC{
    
    func setPublicData(data:Parking){
        self.timingsCard.isHidden = true
        self.availableOnCard.isHidden = false
        
        let imgUrl = data.imageURL
        self.image.sd_setImage(with: URL(string: imgUrl ?? ""),placeholderImage: UIImage.init(named: "placeholder-img") )
        self.parkingTitle.text = data.title ?? "-"
        self.location.text = data.address ?? "-"
        self.price.text = "\(data.initialPrice ?? 0.0)"
        self.type.text = data.parkingSubTypeText ?? "-"
        self.size.text = data.vehicleTypeText ?? "-"
        self.date.text = data.startAt ?? "-"
        
        if (data.isNegotiable ?? false) {
            self.negotiableSwitch.isOn = true
        }
        if (data.status == APP_CONSTANT.STATUS_PARKING_AVAILABLE) {
            self.availableSwitch.isOn = true
        }
        else {
            self.availableSwitch.isOn = false
        }
        
    }
    
    func setPrivateData(data:PrivateParkingModel){
        
        self.timingsCard.isHidden = false
        self.availableOnCard.isHidden = true
        
        let imgUrl = data.imageURL
        self.image.sd_setImage(with: URL(string: imgUrl ?? ""),placeholderImage: UIImage.init(named: "placeholder-img") )
        self.parkingTitle.text = data.title ?? "-"
        self.location.text = data.address ?? "-"
        self.price.text = "\(data.initialPrice ?? 0.0)"
        self.type.text = data.parkingSubTypeText ?? "-"
        self.size.text = data.vehicleTypeText ?? "-"
        
        if (data.isNegotiable ?? false) {
            self.negotiableSwitch.isOn = true
        }
        if (data.status == APP_CONSTANT.STATUS_PARKING_AVAILABLE) {
            self.availableSwitch.isOn = true
        }
        else {
            self.availableSwitch.isOn = false
        }
        
        if (data.isAlways ?? false) {
            self.isAlwaysSwitch.isOn = true
            timingTblView.isHidden = true
        }
        else {
            self.isAlwaysSwitch.isOn = false
            timingTblView.isHidden = false
        }
        
        if (data.slots != nil) {
            
            for item in data.slots!{
                let index = item.day! - 1
                self.selectedItems.append(index)
                self.daysModel.append(item)
            }
        }
        
    }
        

    
    public func updatePublicParking() {
        
        print("availableSwitch=\(self.availableSwitch.isOn)")
        print("negotiableSwitch=\(self.negotiableSwitch.isOn)")
        print("title=\(self.parkingTitle.text ?? "")")
        
        var park_model = UpdateParkingSendingModel()
        
        
        
        if (self.availableSwitch.isOn) {
            park_model.status = APP_CONSTANT.STATUS_PARKING_AVAILABLE
        } else {
            park_model.status = APP_CONSTANT.STATUS_PARKING_UNAVAILABLE
        }
        
        park_model.title = self.parkingTitle.text
        park_model.address = self.location.text
        park_model.isNegotiable = self.negotiableSwitch.isOn
        park_model.startAt = self.parkingModel.startAt
        
        do{
            let data = try JSONEncoder().encode(park_model)
            Helper().showSpinner(view: self.view)
            let request = APIRouter.updateParking(id: self.parkingModel.id!, data)
            APIClient.serverRequest(url: request, path: request.getPath(),body: park_model.dictionary ?? [:], dec: PostResponseData.self) { (response, error) in
                Helper().hideSpinner(view: self.view)
                if(response != nil){
                    if (response?.success) != nil {
                        Helper().showToast(message: response?.message ?? "-", controller: self)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.dismiss(animated: true){
                                self.delegate.didBackButtonPressed()
                            }
                        }
                        
                    }
                    else{
                        Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                    }
                }
                else if(error != nil){
                    Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
                }
                else{
                    Helper().showToast(message: "Nor Response and Error!!", controller: self)
                }
                
                
            }
        }
        catch let parsingError {
            
            print("Error", parsingError)
            
        }
    }
    
    public func updatePrivateParking() {
        
        print("availableSwitch=\(self.availableSwitch.isOn)")
        print("negotiableSwitch=\(self.negotiableSwitch.isOn)")
        print("title=\(self.parkingTitle.text ?? "")")
        print("day=\(self.daysModel)")
        
 
        var park_model = self.privateParkingModel!
        
        
        
        if (self.availableSwitch.isOn) {
            park_model.status = APP_CONSTANT.STATUS_PARKING_AVAILABLE
        } else {
            park_model.status = APP_CONSTANT.STATUS_PARKING_UNAVAILABLE
        }
        
        park_model.title = self.parkingTitle.text
        park_model.address = self.location.text
        park_model.isNegotiable = self.negotiableSwitch.isOn

        
//        do{
//            let data = try JSONEncoder().encode(park_model)
//            Helper().showSpinner(view: self.view)
//            let request = APIRouter.updateParking(id: self.parkingModel.id!, data)
//            APIClient.serverRequest(url: request, path: request.getPath(),body: park_model.dictionary ?? [:], dec: PostResponseData.self) { (response, error) in
//                Helper().hideSpinner(view: self.view)
//                if(response != nil){
//                    if (response?.success) != nil {
//                        Helper().showToast(message: response?.message ?? "-", controller: self)
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                            self.dismiss(animated: true){
//                                self.delegate.didBackButtonPressed()
//                            }
//                        }
//
//                    }
//                    else{
//                        Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
//                    }
//                }
//                else if(error != nil){
//                    Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
//                }
//                else{
//                    Helper().showToast(message: "Nor Response and Error!!", controller: self)
//                }
//
//
//            }
//        }
//        catch let parsingError {
//
//            print("Error", parsingError)
//
//        }
    }
    
    private func showDeleteParkingConfirmationDialog() {
        
        let alert = UIAlertController(title: "Alert!", message: "Do you really want to delete?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
            if self.isPublicParking{
                self.deleteBuyerPublicParking()
            }
            else{
            
            }
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func deleteBuyerPublicParking() {
        
        
        Helper().showSpinner(view: self.view)
        let request = APIRouter.cancelSellerParking(id: self.parkingModel.id!)
        APIClient.serverRequest(url: request, path: request.getPath(),body:nil, dec: PostResponseData.self) { (response, error) in
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if (response?.success) != nil {
                    Helper().showToast(message: response?.message ?? "-", controller: self)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.dismiss(animated: true){
                            self.delegate.didBackButtonPressed()
                        }
                    }
                }
                else{
                    Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                }
            }
            else if(error != nil){
                Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
            }
            else{
                Helper().showToast(message: "Nor Response and Error!!", controller: self)
            }
        }
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
            
            let day = self.daysModel[self.seletedCounter]
            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "HH:mm:ss"
//
//
//            let date1 = dateFormatter.date(from: day.startAt ?? "")
//            let date2 = dateFormatter.date(from: day.endAt ?? "")
//
//            dateFormatter.dateFormat = "hh:mm a"
//
//            let s_time = dateFormatter.string(from: date1!)
//            let e_time = dateFormatter.string(from: date2!)
            
            cell.startTime.text = day.startAt
            cell.endTime.text = day.endAt
            self.seletedCounter += 1
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
//            self.seletedCounter -= 1
            
            
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
            self.seletedCounter = 0
            
            let slot = Slot(dictionary:  ["day" : dayCount, "start_at" : s_time24, "end_at" : e_time24 ] )
            self.daysModel.append(slot!)
        }
        
        
        if(self.selectedItems.count == 0){
            //            GLOBAL_VAR.PRIVATE_PARKING_MODEL.removeValue(forKey: "days")
        }
        else{
            
            let depStr = filterString(str: self.daysModel.description)
            
            //            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(depStr, forKey: "days")
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
                if(item.day == index+1){
                    self.daysModel.remove(at: i)
                }
                i+=1
            }
    
            
            let slot = Slot(dictionary: [ "day" :  index+1, "start_at" : s_time24, "end_at" : e_time24 ])
            self.daysModel.append(slot!)
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
