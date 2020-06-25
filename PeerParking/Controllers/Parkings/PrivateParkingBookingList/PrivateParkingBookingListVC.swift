//
//  PrivateParkingBookingListVC.swift
//  PeerParking
//
//  Created by haya on 22/06/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class PrivateParkingBookingListVC: UIViewController {
    
    //Intent Variables
    var bookingList = [Parking]()
    var privateParkingModel:PrivateParkingModel!
    //Outlets
    @IBOutlet weak var bookingsTblView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Bookings List"
        bookingsTblView.delegate = self
        bookingsTblView.dataSource = self
        Helper().registerTableCell(tableView: bookingsTblView, nibName: "PrivateBookingsCell", identifier: "PrivateBookingsCell")
        
        
        let params:[String:Any] = ["private_parking_id" : self.privateParkingModel.id ?? 0]
        self.getPrivateParkingBookings(params: params)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
}


//Network Calls
extension  PrivateParkingBookingListVC {
    
}

extension PrivateParkingBookingListVC:UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivateBookingsCell", for: indexPath) as! PrivateBookingsCell
        let booking = self.bookingList[indexPath.item]
        cell.parkingTitle.text = booking.title
        cell.address.text = booking.address
        cell.availability.text = "From: \(booking.startAt ?? "-") \n To: \(booking.endAt  ?? "-")"
        cell.status.text = Helper.getStatusText(status: booking.status ?? 0)
        cell.price.text = "$\(booking.initialPrice ?? 0.0)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = ParkingBookingDetailsVC.instantiate(fromPeerParkingStoryboard: .ParkingDetails)
        vc.setParingModel(parkingModel: self.bookingList[indexPath.item])
        self.present(vc, animated: true)
        
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
}



//Network Methods
extension PrivateParkingBookingListVC{
    
    func getPrivateParkingBookings(params:[String:Any]){
        
        Helper().showSpinner(view: self.view)
        self.bookingList.removeAll()
        self.bookingsTblView.reloadData()
        
        APIClient.serverRequest(url: APIRouter.getParkings(params),path:APIRouter.getParkings(params).getPath(), dec: ResponseData<[Parking]>.self) { (response, error) in
            
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if (response?.success) != nil {
                    //                    Helper().showToast(message: response?.message ?? "-", controller: self)
                    if let val = response?.data {
                        
                        self.bookingList = val
                        self.bookingsTblView.reloadData()
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
