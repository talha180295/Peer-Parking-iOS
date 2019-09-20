//
//  PlaceViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 17/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import GoogleMaps
class PlaceViewController: UIViewController {

   
    @IBOutlet weak var viewM: UIView!
    //var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let camera = GMSCameraPosition.camera(withLatitude: -33.8713,
                                              longitude: 151.2086,
                                              zoom: 16.0)
        let mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: -33.8685, longitude: 151.2086))
        marker.icon = UIImage.init(named: "pin_radius")
        
        marker.map = mapView
        
        
        let marker1 = GMSMarker(position: CLLocationCoordinate2D(latitude: -33.8757, longitude: 151.2086))
        marker1.icon = UIImage.init(named: "pin_radius")
        
        marker1.map = mapView
        
        
        
        let marker2 = GMSMarker(position: CLLocationCoordinate2D(latitude: -33.8809, longitude: 151.2086))
        marker2.icon = UIImage.init(named: "pin_radius")
        
        marker2.map = mapView
        
        
        
        let marker3 = GMSMarker(position: CLLocationCoordinate2D(latitude: -33.8713, longitude: 151.2086))
        marker3.icon = UIImage.init(named: "pin_radius")
        
        marker3.map = mapView
        
        
        self.viewM.addSubview(mapView)
      
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: Any) {
       // self.dismiss(animated: false, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
