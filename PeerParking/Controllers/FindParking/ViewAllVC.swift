//
//  ViewAllVC.swift
//  PeerParking
//
//  Created by Apple on 06/11/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import CoreLocation

class ViewAllVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var parkings:[Parking] = []
    
    var lat = 0.0
    var longg = 0.0
    
    @IBOutlet weak var my_table_view: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        my_table_view.register(UINib(nibName: "Parking_table_cell", bundle: nil), forCellReuseIdentifier: "Parking_table_cell")
        
//        let dict = parkings[0] as! NSDictionary
//        print("viewall=\(dict)")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return transactionArr.count
        return parkings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = my_table_view.dequeueReusableCell(withIdentifier: "Parking_table_cell") as! Parking_table_cell
       
        if(parkings.count>0){
            
            
            let dict = parkings[indexPath.row]
            print(dict)
            
            
            let seller = dict.seller
            let seller_details = seller?.details
            
            let lat = dict.latitude ?? ""
            let long = dict.longitude ?? ""
            
            
            let priceStr = dict.initialPrice ?? 0
            
            
            let imgUrl = dict.imageURL ?? ""
            cell.img.sd_setImage(with: URL(string: imgUrl),placeholderImage: UIImage.init(named: "placeholder-img") )
            
            
            cell.parking_title.text = dict.address ?? "-"
            
            cell.vehicle_type.text = dict.vehicleTypeText
            
            cell.rating_view.rating = seller_details?.averageRating ?? 0.0
            
            cell.price.text = "$" + String(priceStr)
            
            cell.vehicle_type.text = dict.vehicleTypeText
            
            if(dict.parkingType == 10){
                cell.parking_type.text = "Public Parking"
            }
            else if(dict.parkingType == 20){
                cell.parking_type.text = "Private Parking"
            }
            
            
            
            cell.price.text = "$\(priceStr)"
            
            
            //            cell.distance.text = String(format: "%.02f miles away", distanceStr)
            
            //            Helper().getTimeDurationBetweenCordinate(s_lat: self.lat, s_longg: self.longg, d_lat: Double(lat) ?? 0.0, d_longg: Double(long) ?? 0.0){ duration in
            //
            //                cell.time.text = duration
            //            }
            
            if(dict.isNegotiable ?? false){
                cell.isNegotiable.text = "Yes"
            }
            else{
                cell.isNegotiable.text = "No"
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.navigationController?.popViewController(animated: true)
        
        parkingDetails(indexPath: indexPath)
        
    }
    
    func parkingDetails(indexPath: IndexPath){
        
         let dict = self.parkings[indexPath.row]
                
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottomSheetVC") as! BottomSheetVC
                controller.parking_details = dict
                
                let lat = dict.latitude ?? "0.0"
                let long = dict.longitude ?? "0.0"
        
        
                
                controller.lat = Double(lat)
                controller.longg = Double(long)
        
                let distanceStr = cal_distance(lat: lat, long: long)
                
                
                
        //        controller.distanceInMiles = String(format: "%.03f miles from destination", distanceStr)
        Helper().bottomSheet(controller: controller, sizes: [.fixed(500),.fullScreen],cornerRadius: 0, handleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), view_controller: self)
        
        
//        let dict = self.parkings[indexPath.row]
//
//        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottomSheetVC") as! BottomSheetVC
//        controller.parking_details = dict
//
//
//        let lat = dict.latitude ?? "0.0"
//        let long = dict.longitude ?? "0.0"
//        let distanceStr = cal_distance(lat: lat, long: long)
//
//
////        controller.distanceInMiles = String(format: "%.03f miles away", distanceStr)
//        Helper().bottomSheet(controller: controller, sizes: [.fixed(500),.fullScreen],cornerRadius: 0, handleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), view_controller: self)
    }
    
    func cal_distance(lat:String,long:String)  -> Double{
        //
        //        print("coordinate1==\(coordinate1)")
        //        print("coordinate1==\(coordinate2)")
        
        let current_coordinate =  CLLocation(latitude: self.lat, longitude: self.longg)
        let lat = Double(lat)
        let long = Double(long)
        let coordinate2 = CLLocation(latitude: lat!, longitude: long!)
        
        let distanceInMiles = current_coordinate.distance(from: coordinate2)/1609.344 // result is in meters
        
        
        print("distanceInMiles=\(distanceInMiles)")
        
        return distanceInMiles
        
    }
    
  
    @IBAction func back_btn(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    
}
