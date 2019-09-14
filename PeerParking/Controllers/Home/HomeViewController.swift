//
//  HomeViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 03/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import SideMenuController

class HomeViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{

  
    @IBOutlet weak var tblLocation: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         tabBarItem.image = UIImage(named: "tab_N")?.withRenderingMode(.alwaysOriginal);
        
      //  loadView()
        tabBarItem.selectedImage = UIImage(named: "tab_selected_navigate")?.withRenderingMode(.alwaysOriginal);
       
        tblLocation.dataSource = self
        tblLocation.delegate = self
        tblLocation.isHidden = true
        tblLocation.register(UINib(nibName: "LoacationCell", bundle: nil), forCellReuseIdentifier: "locationCell")
        
     
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return transactionArr.count
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblLocation.dequeueReusableCell(withIdentifier: "locationCell") as! LoacationCell
        
        
        cell.selectionStyle = .none
        return  cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "parkDetailVC") as! ParkingDetailViewController
        vc.strVC = "navigate"
        self.addChild(vc)
        view.addSubview(vc.view)
        tblLocation.isHidden = true
    }
    
 
    
    @IBAction func btnLocation(_ sender: Any) {
          tblLocation.isHidden = false
    }
    @IBAction func btnSearch(_ sender: Any) {
    }
    
    
//    override func loadView() {
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6.
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let map = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        view = map
//        
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = map
//    }
    

    

}
