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
    
    //Outlets
    @IBOutlet weak var upComingParkingTbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        Helper().registerTableCell(tableView: upComingParkingTbl, nibName: "HistoryCell", identifier: "HistoryCell")
       
        let params:[String:Any] = ["is_schedule":1]
        getUpcomingParking(params: params)
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: "UPCOMING", accessibilityLabel: "UPCOMING", image: UIImage(named: "upcomingUn"), highlightedImage: UIImage(named: "upcoming"), userInfo: nil)
    }
    
    
    func getUpcomingParking(params:[String:Any]){
        
        APIClient.serverRequest(url: APIRouter.getParkings(params), dec: ResponseData<[Parking]>.self) { (response, error) in
            
            if(response != nil){
                if (response?.success) != nil {
                    Helper().showToast(message: response?.message ?? "-", controller: self)
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

        cell.address.text = self.parkingModel[indexPath.row].address ?? ""
        cell.price.text = String(self.parkingModel[indexPath.row].initialPrice ?? 0.0)
        
        if let parkingStatus = ParkingStatus(rawValue: self.parkingModel[indexPath.row].status ?? 0){
                   
            cell.status.text = "\(parkingStatus)"
        }
              
       
        

        return cell

    }
    
}
