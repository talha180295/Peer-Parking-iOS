//
//  UpcomingParkingVC.swift
//  PeerParking
//
//  Created by Apple on 28/01/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class UpcomingParkingVC: UIViewController,IndicatorInfoProvider {
    
   
    //Variables
    var parkingModel = [Parking]()
    var params:[String:Any] = ["is_schedule":1]
    
    //Outlets
    @IBOutlet weak var upComingParkingTbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        Helper().registerTableCell(tableView: upComingParkingTbl, nibName: "HistoryCell", identifier: "HistoryCell")

        getUpcomingParking(params: params)
    }
    
    override func viewWillAppear(_ animated: Bool) {
           
        NotificationCenter.default.addObserver(self, selector: #selector(self.getFilters(notification:)), name: NSNotification.Name(rawValue: "mode_filter"), object: nil)
    }
       
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        Helper().hideSpinner(view: self.view)
    }
    
    
    @objc func getFilters(notification: NSNotification) {
        
        if let dict = notification.userInfo as NSDictionary? {
            
            if let mode = dict.value(forKey: "mode"){
                
                self.params.updateValue(mode, forKey: "mood")
                //                Helper().showToast(message: "Notify -\(self.params)", controller: self)
                
                //                let params:[String:Any] = ["is_mine":1]
                getUpcomingParking(params: self.params)
            }
            if let _ = dict.value(forKey: "is_schedule"){
                let param = ["is_schedule":1]
                getUpcomingParking(params: param)
            }
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: "UPCOMING", accessibilityLabel: "UPCOMING", image: UIImage(named: "upcomingUn"), highlightedImage: UIImage(named: "upcoming"), userInfo: nil)
    }
    
    
    func getUpcomingParking(params:[String:Any]){
        
        Helper().showSpinner(view: self.view)
        self.parkingModel.removeAll()
        self.upComingParkingTbl.reloadData()
        
        APIClient.serverRequest(url: APIRouter.getParkings(params),path:APIRouter.getParkings(params).getPath(), dec: ResponseData<[Parking]>.self) { (response, error) in
            
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if (response?.success) != nil {
//                    Helper().showToast(message: response?.message ?? "-", controller: self)
                    if let val = response?.data {
                    
                        self.parkingModel = val
                        self.upComingParkingTbl.reloadData()
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



extension UpcomingParkingVC: UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.parkingModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = upComingParkingTbl.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        cell.parkingTitle.text = self.parkingModel[indexPath.row].title ?? ""
        cell.address.text = self.parkingModel[indexPath.row].address ?? ""
        cell.price.text = "$\(self.parkingModel[indexPath.row].initialPrice ?? 0.0)"
        
        if let parkingStatus = ParkingStatus(rawValue: self.parkingModel[indexPath.row].status ?? 0){
                   
            cell.status.text = "\(parkingStatus)"
        }
              
        if let action = Action(rawValue: self.parkingModel[indexPath.row].action ?? 0){
                         
            cell.direction.text = "\(action)"
        }
            
        cell.type.text = self.parkingModel[indexPath.row].parkingSubTypeText ?? "-"
        
        cell.availablity.text = "\(self.parkingModel[indexPath.row].startAt ?? "")"
        
//        cell.availablity.text = "\(self.parkingModel[indexPath.row].startAt ?? "") - \(self.parkingModel[indexPath.row].endAt ?? "")"
               
        

        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let parking = parkingModel[indexPath.item]
        
        if((parking.status == ParkingStatus.AVAILABLE.rawValue ||
            parking.status == ParkingStatus.UNAVAILABLE.rawValue)) &&
            (parking.parkingType == ParkingType.PARKING_TYPE_PUBLIC){
            
            let vc = MySpotParkingDetailVC.instantiate(fromPeerParkingStoryboard: .ParkingDetails)
            vc.setParingModel(parkingModel: parking)
            vc.isPublicParking = true
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true,completion: nil)
            
        }else{
            
            let vc = ParkingBookingDetailsVC.instantiate(fromPeerParkingStoryboard: .ParkingDetails)
            vc.setParingModel(parkingModel: parking)
           
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
       
    }
    
}


extension UpcomingParkingVC:MySpotParkingDetailVCDelegate{
    func didBackButtonPressed() {
        getUpcomingParking(params: self.params)
    }
    
    
}
