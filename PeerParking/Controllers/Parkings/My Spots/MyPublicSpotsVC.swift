//
//  MyPublicSpotsVC.swift
//  PeerParking
//
//  Created by Apple on 26/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class MyPublicSpotsVC: UIViewController,IndicatorInfoProvider {
    
   
    //Variables
    var parkingModel = [Parking]()
    var params:[String:Any] = ["my_public_spots":1]
    
    //Outlets
    @IBOutlet weak var publicSpotsParkingTbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        Helper().registerTableCell(tableView: publicSpotsParkingTbl, nibName: "MySpotCell", identifier: "MySpotCell")
       
       
        getMyPublicSpots(params: params)
    }
    
    override func viewWillAppear(_ animated: Bool) {
           
//        NotificationCenter.default.addObserver(self, selector: #selector(self.getFilters(notification:)), name: NSNotification.Name(rawValue: "mode_filter"), object: nil)
    }
       
    override func viewWillDisappear(_ animated: Bool) {
       
//       NotificationCenter.default.removeObserver(self)
    }
    
    
//    @objc func getFilters(notification: NSNotification) {
//
//
//
//        if let dict = notification.userInfo as NSDictionary? {
//
//            if let mode = dict.value(forKey: "mode"){
//
//                self.params.updateValue(mode, forKey: "mood")
////                Helper().showToast(message: "Notify -\(self.params)", controller: self)
//
////                let params:[String:Any] = ["is_mine":1]
//                getMyPublicSpots(params: self.params)
//            }
//
//        }
//    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: "PUBLIC", accessibilityLabel: "PUBLIC", image: UIImage(named: "upcomingUn"), highlightedImage: UIImage(named: "upcoming"), userInfo: nil)
    }
    
    
    func getMyPublicSpots(params:[String:Any]){
        
        self.parkingModel.removeAll()
        self.publicSpotsParkingTbl.reloadData()
        
        APIClient.serverRequest(url: APIRouter.getParkings(params), path: APIRouter.getParkings(params).getPath(), dec: ResponseData<[Parking]>.self) { (response, error) in
            
            if(response != nil){
                if (response?.success) != nil {
//                    Helper().showToast(message: response?.message ?? "-", controller: self)
                    if let val = response?.data {
                    
                        self.parkingModel = val
                        self.publicSpotsParkingTbl.reloadData()
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



extension MyPublicSpotsVC: UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.parkingModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = publicSpotsParkingTbl.dequeueReusableCell(withIdentifier: "MySpotCell") as! MySpotCell

        cell.titleStr.text = self.parkingModel[indexPath.row].title ?? ""
        cell.price.text = "$\(self.parkingModel[indexPath.row].initialPrice ?? 0.0)"
        cell.address.text = self.parkingModel[indexPath.row].address ?? ""


        if let parkingStatus = ParkingStatus(rawValue: self.parkingModel[indexPath.row].status ?? 0){
                 
          cell.status.text = "\(parkingStatus)"
        }

        

        return cell

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}
