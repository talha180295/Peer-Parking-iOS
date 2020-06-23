//
//  MyPrivateSpotsVC.swift
//  PeerParking
//
//  Created by Apple on 26/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MyPrivateSpotsVC: UIViewController,IndicatorInfoProvider {
    
   
    //Variables
    var privateSpotModel = [PrivateParkingModel]()
    var params:[String:Any] = ["is_mine":1]
    
    //Outlets
    @IBOutlet weak var privateSpotsParkingTbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        Helper().registerTableCell(tableView: privateSpotsParkingTbl, nibName: "MySpotCell", identifier: "MySpotCell")
       
       
        getMyPrivateSpots(params: params)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.getFilters(notification:)), name: NSNotification.Name(rawValue: "mode_filter"), object: nil)
    }
       
    override func viewWillDisappear(_ animated: Bool) {
       
//       NotificationCenter.default.removeObserver(self)
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: "PRIVATE", accessibilityLabel: "PRIVATE", image: UIImage(named: "upcomingUn"), highlightedImage: UIImage(named: "upcoming"), userInfo: nil)
    }
    
    
    func getMyPrivateSpots(params:[String:Any]){
        
        Helper().showSpinner(view: self.view)
        self.privateSpotModel.removeAll()
        self.privateSpotsParkingTbl.reloadData()
        
        APIClient.serverRequest(url: APIRouter.getPrivateParkings(params), path: APIRouter.getPrivateParkings(params).getPath(), dec: ResponseData<[PrivateParkingModel]>.self) { (response, error) in
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if (response?.success) != nil {
//                    Helper().showToast(message: response?.message ?? "-", controller: self)
                    if let val = response?.data {
                    
                        self.privateSpotModel = val
                        self.privateSpotsParkingTbl.reloadData()
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



extension MyPrivateSpotsVC: UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.privateSpotModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = privateSpotsParkingTbl.dequeueReusableCell(withIdentifier: "MySpotCell") as! MySpotCell

        cell.titleStr.text = self.privateSpotModel[indexPath.row].title ?? ""
        cell.price.text = "$\(self.privateSpotModel[indexPath.row].initialPrice ?? 0.0)"
        cell.address.text = self.privateSpotModel[indexPath.row].address ?? ""
        
      
        if let parkingStatus = ParkingStatus(rawValue: self.privateSpotModel[indexPath.row].status ?? 0){
                   
            cell.status.text = "\(parkingStatus)"
        }


        return cell

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 132
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let vc = MySpotsDetailBS.instantiate(fromPeerParkingStoryboard: .Main)
        vc.privateParkingModel = self.privateSpotModel[indexPath.row]
        vc.navigator = self.navigationController
//        self.navigationController?.pushViewController(vc, animated: true)
        Helper().bottomSheet(controller: vc, sizes: [.fixed(120)], cornerRadius: 0, handleColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), view_controller: self)
    }
}
