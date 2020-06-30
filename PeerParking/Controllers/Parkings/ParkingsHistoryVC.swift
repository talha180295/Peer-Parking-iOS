//
//  ParkingsHistoryVC.swift
//  PeerParking
//
//  Created by Apple on 28/01/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class ParkingsHistoryVC: UIViewController,IndicatorInfoProvider {
    
  
    var parkingModel = [Parking]()
    var params:[String:Any] = ["is_mine":1]
//    var filter:[String:Any]?
       
    //Outlets
    @IBOutlet weak var historyParkingTbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(filter ?? [:])
        
        Helper().registerTableCell(tableView: historyParkingTbl, nibName: "HistoryCell", identifier: "HistoryCell")
              
        
        getHistoryParking(params: params)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.getFilters(notification:)), name: NSNotification.Name(rawValue: "history_filter"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: "HISTORY", accessibilityLabel: "HISTORY", image: UIImage(named: "historyUn"), highlightedImage: UIImage(named: "history"), userInfo: nil)
    }
    
    
    @objc func getFilters(notification: NSNotification) {

    
        
        if let dict = notification.userInfo as NSDictionary? {
            
            if let mode = dict.value(forKey: "mode"){
                
                self.params.updateValue(mode, forKey: "mood")
//                Helper().showToast(message: "Notify -\(self.params)", controller: self)
               
//                let params:[String:Any] = ["is_mine":1]
                getHistoryParking(params: self.params)
            }
            if let is_mine = dict.value(forKey: "is_mine"){
                let param = ["is_mine":is_mine]
                getHistoryParking(params: param)
            }
        }
    }
  

    
    func getHistoryParking(params:[String:Any]){
        
        self.parkingModel.removeAll()
        self.historyParkingTbl.reloadData()
        
        APIClient.serverRequest(url: APIRouter.getParkings(params), path: APIRouter.getParkings(params).getPath(), dec: ResponseData<[Parking]>.self) { (response, error) in
            
            if(response != nil){
                if (response?.success) != nil {
//                    Helper().showToast(message: response?.message ?? "-", controller: self)
                    if let val = response?.data {
                    
                        self.parkingModel = val
                        self.historyParkingTbl.reloadData()
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



extension ParkingsHistoryVC: UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.parkingModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = historyParkingTbl.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell

        cell.address.text = self.parkingModel[indexPath.row].address ?? ""
        cell.price.text = "$\(self.parkingModel[indexPath.row].initialPrice ?? 0.0)"
        
//        if let parkingStatus = ParkingStatus(rawValue: self.parkingModel[indexPath.row].status ?? 0){
//
//
//        }
        if let action = Action(rawValue: self.parkingModel[indexPath.row].action ?? 0){
                               
                  cell.direction.text = "\(action)"
        }
//        if let type = ParkingTypes(rawValue: self.parkingModel[indexPath.row].parkingType ?? 0){
//
//                         cell.type.text = "\(type)"
//        }
        
        cell.status.text = Helper.getStatusText(status: self.parkingModel[indexPath.row].status ?? 0)
        cell.parkingTitle.text = self.parkingModel[indexPath.row].title ?? "-"
        cell.type.text = self.parkingModel[indexPath.row].parkingSubTypeText ?? "-"
        cell.availablity.text = "\(self.parkingModel[indexPath.row].startAt ?? "") - \(self.parkingModel[indexPath.row].endAt ?? "")"
        
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let parking = parkingModel[indexPath.item]
        
        let vc = ParkingBookingDetailsVC.instantiate(fromPeerParkingStoryboard: .ParkingDetails)
        vc.parkingModel = parking
//        vc.setParingModel(parkingModel: parking)
        self.present(vc, animated: true)
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}

//extension ParkingsHistoryVC:Filters{
//
//    func getFilters(filter: [String : Any]) {
//        print(filter)
//    }
//
//
//}
