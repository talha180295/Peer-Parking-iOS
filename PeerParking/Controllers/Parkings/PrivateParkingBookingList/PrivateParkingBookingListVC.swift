//
//  PrivateParkingBookingListVC.swift
//  PeerParking
//
//  Created by haya on 22/06/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class PrivateParkingBookingListVC: UIViewController {

    //Outlets
    @IBOutlet weak var bookingsTblView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Bookings List"
        bookingsTblView.delegate = self
        bookingsTblView.dataSource = self
        Helper().registerTableCell(tableView: bookingsTblView, nibName: "PrivateBookingsCell", identifier: "PrivateBookingsCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

}


//Network Calls
extension  PrivateParkingBookingListVC {
    
}

extension PrivateParkingBookingListVC:UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivateBookingsCell", for: indexPath) as! PrivateBookingsCell
    
       
        
        
        return cell
    }
    
  
    
    
}
