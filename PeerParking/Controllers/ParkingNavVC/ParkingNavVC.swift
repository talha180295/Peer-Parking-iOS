//
//  ParkingNavVC.swift
//  PeerParking
//
//  Created by Apple on 23/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import GoogleMaps

class ParkingNavVC: UIViewController {

    //IBOutlets
    @IBOutlet weak var mapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        loadMapView()
    }
    
    func loadMapView(){
        
        print("::=loadMap")
        let camera = GMSCameraPosition.camera(withLatitude: 1.285,
                                              longitude: 103.848,
                                              zoom: 12)
        
        let mapView = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.myLocationButton = false
        // self.mapView = mapView
        self.mapView.addSubview(mapView)
    }

    @IBAction func park_now_btn(_ sender: UIButton) {
    }
    @IBAction func cancel_btn(_ sender: UIButton) {
        
        //self.dismiss(animated: true, completion: nil)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
