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
import DatePickerDialog


enum dayTag:Int{
    case Monday = 1
    case Tuesday = 2
    case Wednesday = 3
    case Thursday = 4
    case Friday = 5
    case Saturday = 6
    case Sunday = 7
}
protocol MySpotParkingDetailVCDelegate : NSObjectProtocol {
    func didBackButtonPressed()
}
class MySpotParkingDetailVC : UIViewController,UITextFieldDelegate {
    
    
    
    
    //Delegates
    var delegate:MySpotParkingDetailVCDelegate!
    
    
    //Intent Variables
    
    private var parkingModel:Parking!
    private var privateParkingModel = PrivateParkingModel()
    var isPublicParking:Bool = false
    
    //Outlets
    @IBOutlet var day:[UILabel]!
    @IBOutlet var startTime:[UILabel]!
    @IBOutlet var endTime:[UILabel]!
    @IBOutlet var checkBox:[UIButton]!
    
    @IBOutlet weak var parkingTimeLabel: UILabel!
    @IBOutlet weak var stackView:UIStackView!
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
    
    var bookingsExist:Bool = false
    
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    //    var day = ["day" : "", "start_at" : "", "end_at" : ""]
    
    var daysModel = [Slot]()
    var selectedItems = [Int]()
    var seletedCounter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parkingTitle.delegate = self
        //        timingTblView.delegate = self
        //        timingTblView.dataSource = self
        //        timingTblView.isScrollEnabled = false
        //        Helper().registerTableCell(tableView: timingTblView, nibName: "TimingsCell", identifier: "TimingsCell")
        
        self.checkIfBookingExists()
        if isPublicParking{
            self.setPublicData(data: self.parkingModel)
        }
        else{
            self.setPrivateData(data: self.privateParkingModel)
        }
        
        
        
        
        //        timePicker = UIAlertDateTimePicker(withPickerMode: .time, pickerTitle: "Select Time", showPickerOn: self.view)
        //        timePicker.delegate = self
        
        
        
        let distanceTap = UITapGestureRecognizer(target: self, action: #selector(dateTapFunction))
        
        date.isUserInteractionEnabled = true
        date.addGestureRecognizer(distanceTap)
        
        let TimeTap = UITapGestureRecognizer(target: self, action: #selector(timeTapFunction))
        
        parkingTimeLabel.isUserInteractionEnabled = true
        parkingTimeLabel.addGestureRecognizer(TimeTap)
        
        
//        setTimings()
    }
    
    
    private func checkIfBookingExists() {
        
        Helper().showSpinner(view: self.view)
        let params:[String:Any] = ["private_parking_id" : self.privateParkingModel.id ?? 0]
        let request = APIRouter.getParkings(params)
        APIClient.serverRequest(url: request, path: request.getPath(), dec: ResponseData<[PrivateParkingModel]>.self) { (response, error) in
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if (response?.success) != nil {
                    //                    Helper().showToast(message: response?.message ?? "-", controller: self)
                    if let val = response?.data {
                        for item in val{
                            if(item.status == APP_CONSTANT.STATUS_PARKING_BOOKED ||
                                    item.status == APP_CONSTANT.STATUS_PARKING_NAVIGATING){
                                self.bookingsExist = true
                            }
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

    func setTimings(){
        
       
        
        for items in day{
            let tag:dayTag = dayTag(rawValue: items.tag)!
            let index = tag.rawValue - 1
            switch tag {
            case .Monday:
                self.day[index].text = days[index]
            case .Tuesday:
                self.day[index].text = days[index]
            case .Wednesday:
                self.day[index].text = days[index]
            case .Thursday:
                self.day[index].text = days[index]
            case .Friday:
                self.day[index].text = days[index]
            case .Saturday:
                self.day[index].text = days[index]
            case .Sunday:
                self.day[index].text = days[index]
            }
            
            if (selectedItems.contains(index)) {
                self.checkBox[index].setImage(UIImage(named: "checkbox"), for: .normal)
                self.checkBox[index].isSelected = true
                
                for item in daysModel{
                    if item.day == index + 1{
                        let day = item
                        self.startTime[index].text = DateHelper.getFormatedDate(dateStr: day.startAt ?? "", inFormat: dateFormat.HHmmss.rawValue, outFormat: dateFormat.hmma.rawValue)
                        self.endTime[index].text =  DateHelper.getFormatedDate(dateStr: day.endAt ?? "", inFormat: dateFormat.HHmmss.rawValue, outFormat: dateFormat.hmma.rawValue)
                        self.seletedCounter += 1
                    }
                }
                
            }
            else {
                self.checkBox[index].setImage(UIImage(named: "uncheckbox"), for: .normal)
                self.checkBox[index].isSelected = false
            }
        }
        
        
    }
    @objc func dateTapFunction(sender:UITapGestureRecognizer) {
        
        
        DatePickerDialog(buttonColor:#colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)).show("Select Date", doneButtonTitle: "DONE", cancelButtonTitle: "CANCEL", datePickerMode: .date) {
            (date) -> Void in
            if let time = date {
                let formatter = DateFormatter()
                formatter.dateFormat = APP_CONSTANT.DATE_TIME_FORMAT
                var stringDate = formatter.string(from: time)
                stringDate =  Helper().getFormatedDateAndTimeList(dateStr: stringDate ?? "" )
                
                self.date.text =  stringDate.components(separatedBy: " ")[0]
                
                //                       GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(self.time_field.text!, forKey: "start_at")
                
            }
        }
        
    }
    
    
    @objc func timeTapFunction(sender:UITapGestureRecognizer) {
        
        DatePickerDialog(buttonColor:#colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)).show("Select Time", doneButtonTitle: "DONE", cancelButtonTitle: "CANCEL", datePickerMode: .time) {
            (date) -> Void in
            if let time = date {
                let formatter = DateFormatter()
                formatter.dateFormat = APP_CONSTANT.DATE_TIME_FORMAT
                
                var stringDate = formatter.string(from: time)
                stringDate =  Helper().getFormatedDateAndTimeList(dateStr: stringDate ?? "" )
                
                
                
                self.parkingTimeLabel.text = stringDate.components(separatedBy: " ")[1] + " " + stringDate.components(separatedBy: " ")[2]
                
                //                       GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(self.time_field.text!, forKey: "start_at")
                
            }
        }
        
    }
    
    
    
    func setParingModel(parkingModel: Parking){
        self.parkingModel = parkingModel
    }
    func setPrivateParingModel(privateParkingModel: PrivateParkingModel){
        self.privateParkingModel = privateParkingModel
    }
    
    @IBAction func timingButton(_ sender:UIButton){
        
        let index = sender.tag - 1
        print(index)
        if(checkBox[index].isSelected){
            self.setTime(index: index)
        }
        
    }
    @IBAction func checkbox(_ sender: UIButton) {
        
        let index = sender.tag - 1
        self.setCheckBox(index: index)
        
        if (self.selectedItems.contains(index)) {

            let index = self.selectedItems.firstIndex(of: index)!
            self.selectedItems.remove(at: index)

            self.daysModel.remove(at: index)
            self.seletedCounter = 0


        }
        else {
            self.selectedItems.append(index)
            let dayCount = index + 1

            let s_dateAsString = self.startTime[index].text ?? ""
            let e_dateAsString = self.endTime[index].text ?? ""

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"

            let date1 = dateFormatter.date(from: s_dateAsString)
            let date2 = dateFormatter.date(from: e_dateAsString)

            dateFormatter.dateFormat = "HH:mm:ss"
            let s_time24 = dateFormatter.string(from: date1!)
            let e_time24 = dateFormatter.string(from: date2!)
            self.seletedCounter = 0

            let slot = Slot(dictionary:  ["day" : dayCount, "start_at" : s_time24, "end_at" : e_time24 ] )
            self.daysModel.append(slot!)
        }


        if(self.selectedItems.count == 0){
            self.privateParkingModel.slots = nil
            //            GLOBAL_VAR.PRIVATE_PARKING_MODEL.removeValue(forKey: "days")
        }
        else{

            self.privateParkingModel.slots = self.daysModel
        }
    }
    
    func setCheckBox(index:Int){
        if(checkBox[index].isSelected){
            checkBox[index].setImage(UIImage(named: "uncheckbox"), for: .normal)
            checkBox[index].isSelected = false
        }
        else{
            checkBox[index].setImage(UIImage(named: "checkbox"), for: .normal)
            checkBox[index].isSelected = true
        }
    }
    
    @IBAction func alwaysSwitch(_ sender:UISwitch){
        
        if sender.isOn{
            stackView.isHidden = true
            self.privateParkingModel.isAlways = true
            self.privateParkingModel.slots = nil
        }
        else{
            stackView.isHidden = false
            self.privateParkingModel.isAlways = false
            self.privateParkingModel.slots = self.daysModel
        }
        
    }
    
    @IBAction func negoSwitch(_ sender:UISwitch){
        
        if sender.isOn{
            
            self.privateParkingModel.isNegotiable = true
        }
        else{
            self.privateParkingModel.isNegotiable = false

        }
    }
    
    @IBAction func availableSwitch(_ sender:UISwitch){
        
        if sender.isOn{
            self.privateParkingModel.status = APP_CONSTANT.STATUS_PARKING_AVAILABLE
        } else {
            self.privateParkingModel.status = APP_CONSTANT.STATUS_PARKING_UNAVAILABLE
        }
    }
    
    func filterString(str:String) -> String{
        
        let  depStr = str.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "[[", with: "[{").replacingOccurrences(of: "],[", with: "},{").replacingOccurrences(of: "]]", with: "}]").replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: "),", with: ",").replacingOccurrences(of: ")", with: "")
        
        return depStr
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
    
    @IBAction func updateBtn(_ sender: UIButton) {
        
        if isPublicParking{
            self.updatePublicParking()
        }
        else{
            self.updatePrivateParking(data: self.privateParkingModel)
        }
        
    }
    
    @IBAction func didendediting(_ sender: UITextField) {
        if(!isPublicParking){
            self.privateParkingModel.title = sender.text
        
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
        
        //        self.date.text =    data.startAt ?? "-"
        
        
        var convertedDate = Helper().getFormatedDateAndTimeList(dateStr: data.startAt ?? "" )
        self.date.text = convertedDate.components(separatedBy: " ")[0]
        
        
        
        
        
        if(convertedDate.components(separatedBy: " ").count ==  3)
        {
            self.parkingTimeLabel.text = convertedDate.components(separatedBy: " ")[1] + " " + convertedDate.components(separatedBy: " ")[2]
            
        }
        else
        {
            self.parkingTimeLabel.text = convertedDate.components(separatedBy: " ")[1]
        }
        
        
        
        //        self.date.text = convertedDate.
        
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
            self.stackView.isHidden = true
        }
        else {
            self.isAlwaysSwitch.isOn = false
            self.stackView.isHidden = false
        }
        
        if (data.slots != nil) {
            
            for item in data.slots!{
                let index = item.day! - 1
                self.selectedItems.append(index)
                self.daysModel.append(item)
            }
        }
        self.setTimings()
//        self.day.text = self.days[indexPath.row]
////        self.checkBox.tag = indexPath.row
//        if (selectedItems.contains(indexPath.row)) {
//
//            self.checkBox.setImage(UIImage(named:"checkbox"), for: .normal)
//            self.checkBox.isSelected = true
//
//            let day = self.daysModel[self.seletedCounter]
//
//            //            let dateFormatter = DateFormatter()
//            //            dateFormatter.dateFormat = "HH:mm:ss"
//            //
//            //
//            //            let date1 = dateFormatter.date(from: day.startAt ?? "")
//            //            let date2 = dateFormatter.date(from: day.endAt ?? "")
//            //
//            //            dateFormatter.dateFormat = "hh:mm a"
//            //
//            //            let s_time = dateFormatter.string(from: date1!)
//            //            let e_time = dateFormatter.string(from: date2!)
//
//            self.startTime.text = day.startAt
//            self.endTime.text = day.endAt
//            self.seletedCounter += 1
//        }
//        else {
//            self.checkBox.setImage(UIImage(named: "uncheckbox"), for: .normal)
//            self.checkBox.isSelected = false
//        }
        
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
        //        park_model.startAt = self.parkingModel.startAt
        //        park_model.startAt = self.date.text ?? "" + " " + (self.parkingTimeLabel.text ?? "")
        
        var startDateandTime = "\((self.date.text ?? "") + (" ") + (self.parkingTimeLabel.text ?? ""))"
        startDateandTime = Helper().getFormatedServerDateTimeForDetail(dateStr: startDateandTime)
        park_model.startAt = startDateandTime
        
        
        
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
    
    public func updatePrivateParking(data:PrivateParkingModel) {

        do{
            let data = try JSONEncoder().encode(self.privateParkingModel)
            Helper().showSpinner(view: self.view)
            let request = APIRouter.privateParkingEdit(id: self.privateParkingModel.id!, data)
            APIClient.serverRequest(url: request, path: request.getPath(),body: privateParkingModel.dictionary ?? [:], dec: PostResponseData.self) { (response, error) in
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
    
    private func showDeleteParkingConfirmationDialog() {
        
        let alert = UIAlertController(title: "Alert!", message: "Do you really want to delete?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
            if self.isPublicParking{
                self.deleteBuyerPublicParking()
            }
            else{
                if(self.bookingsExist){

                    Helper().showToast(message: "Cannot delete unless all current bookings are complete. Change status to unavailable, to prevent further request on this parking.", controller: self)
                
                
                }else{
                    self.deleteParking()
                }
            }
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func deleteParking() {

        self.privateParkingModel.status = APP_CONSTANT.STATUS_PRIVATE_PARKING_CANCEL
       
        self.updatePrivateParking(data: self.privateParkingModel)
    }
    
    public func deleteBuyerPublicParking() {
        
        
        Helper().showSpinner(view: self.view)
        let request = APIRouter.cancelSellerParking(id: self.parkingModel.id!)
        APIClient.serverRequest(url: request, path: request.getPath(),body:nil, dec: PostResponseData.self) { (response, error) in
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if (response?.success) != nil {
                    Helper().showToast(message: response?.message ?? "-", controller: self)
                     Helper.deleteChatAndRequests(parkingModel1: self.parkingModel)
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
        
//        let indexPath = IndexPath(row: sender.tag, section: 0)
        //        let cell = self.timingTblView.cellForRow(at: indexPath) as! TimingsCell
        
        if (self.selectedItems.contains(sender.tag)) {
            
            let index = self.selectedItems.firstIndex(of: sender.tag)!
            self.selectedItems.remove(at: index)
            
            self.daysModel.remove(at: index)
            self.seletedCounter = 0
            
            
        }
        else {
            self.selectedItems.append(sender.tag)
            let dayCount = sender.tag + 1
            
            //            let s_dateAsString = cell.startTime.text ?? ""
            //            let e_dateAsString = cell.endTime.text ?? ""
            //
            //            let dateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "h:mm a"
            //
            //            let date1 = dateFormatter.date(from: s_dateAsString)
            //            let date2 = dateFormatter.date(from: e_dateAsString)
            //
            //            dateFormatter.dateFormat = "HH:mm:ss"
            //            let s_time24 = dateFormatter.string(from: date1!)
            //            let e_time24 = dateFormatter.string(from: date2!)
            //            self.seletedCounter = 0
            //
            //            let slot = Slot(dictionary:  ["day" : dayCount, "start_at" : s_time24, "end_at" : e_time24 ] )
            //            self.daysModel.append(slot!)
        }
        
        
        if(self.selectedItems.count == 0){
            //            GLOBAL_VAR.PRIVATE_PARKING_MODEL.removeValue(forKey: "days")
        }
        else{
            
            let depStr = filterString(str: self.daysModel.description)
            
            //            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(depStr, forKey: "days")
        }
        
        //        self.timingTblView.reloadData()
    }
    
    func setTime(index: Int) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartEndPopUp") as! StartEndPopUp
            vc.startDate = self.startTime[index].text ?? ""
            vc.endDate = self.endTime[index].text ?? ""
        
        vc.completionBlock = {(startDtae, endDate) -> ()in
            
            
            self.startTime[index].text = startDtae
            self.endTime[index].text = endDate
            
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
//            var i = 0
//            for item in self.daysModel{
//                if(item.day == index+1){
//                    self.daysModel.remove(at: i)
//                }
//                i+=1
//            }
            let day = index + 1
            for i in 0...self.daysModel.count - 1{
                if(self.daysModel[i].day == day){
                    self.daysModel.remove(at: i)
                    break
                }
            }
            
            let slot = Slot(dictionary: [ "day" :  day, "start_at" : s_time24, "end_at" : e_time24 ])
            self.daysModel.append(slot!)
            
            self.privateParkingModel.slots = self.daysModel
         
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
