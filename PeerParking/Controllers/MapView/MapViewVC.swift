//
//  MapViewVC.swift
//
//
//  Created by Apple on 03/03/2020.
//

import UIKit
import GoogleMaps

class MapViewVC: UIViewController {

    //IBOutlets
    @IBOutlet weak var mapView: UIView!
    
    
    //Intent Variables
    var parkingDetails:[Parking]!
    
    //Variables
    var map = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
        loadMapView()
    }

    func loadMapView(){

        print("::=loadMap")

        let lat:Double = Double(parkingDetails[0].latitude ?? "0")!
        let longg:Double = Double(parkingDetails[0].longitude ?? "0")!

        print(lat)
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: longg, zoom: 14.0)

        

        map = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        map.settings.scrollGestures = true
        map.settings.zoomGestures = true
        map.settings.myLocationButton = true
        // self.mapView = mapView
        self.mapView.addSubview(map)

        map.isMyLocationEnabled = true

        self.map.animate(to: camera)
        
        Helper().map_circle(data: parkingDetails, map_view: self.map)
        Helper().map_custom_marker(data: parkingDetails, map_view: self.map)

    }
    
    //IBAction
    @IBAction func backBtn(_ sender:UIButton){
        
        self.dismiss(animated: true, completion: nil)
    }

}
