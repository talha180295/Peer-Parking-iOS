//
//  ParkingNavVC.swift
//  PeerParking
//
//  Created by Apple on 23/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire
import SwiftyJSON

class ParkingNavVC: UIViewController, CLLocationManagerDelegate{

    //IBOutlets
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var parking_title: UILabel!
    
    var map = GMSMapView()
    
    var locationManager = CLLocationManager()
    
    var p_title:String = ""
    var p_lat:Double = 0.0
    var p_longg:Double = 0.0
    
    var alternateRoutes:[JSON]!
    var c_lat:Double = 0.0
    var c_longg:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parking_title.text = p_title
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        loadMapView()
        
     
        
    }
    
    
    

    func loadMapView(){
        
        print("::=loadMap")
        
        let camera = GMSCameraPosition.init()
        
        map = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        map.settings.scrollGestures = true
        map.settings.zoomGestures = true
        map.settings.myLocationButton = false
        // self.mapView = mapView
        self.mapView.addSubview(map)
        
        map.isMyLocationEnabled = true
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        
        self.c_lat = (location?.coordinate.latitude)!
        self.c_longg = (location?.coordinate.longitude)!
        
        let origin = "\(c_lat),\(c_lat)"
       
        
        
        print("origin1=\(origin)")
        
        drawRoute()
        //        print("lat==\(location?.coordinate.latitude)")
        //        print("long==\(location?.coordinate.longitude)")
        
//        self.filterLat = (location?.coordinate.latitude)!
//        self.filterLong = (location?.coordinate.longitude)!
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 14.0)
        
        self.map.animate(to: camera)
        
        //location.
        
//        let geoCoder = CLGeocoder()
//
//        geoCoder.reverseGeocodeLocation(location!, completionHandler:
//            {
//                placemarks, error in
//
//                guard let placemark = placemarks?.first else {
//                    let errorString = error?.localizedDescription ?? "Unexpected Error"
//                    print("Unable to reverse geocode the given location. Error: \(errorString)")
//                    return
//                }
//
//                let reversedGeoLocation = ReversedGeoLocation(with: placemark)
//                print("LOC=:\(reversedGeoLocation.formattedAddress)")
////                self.address = reversedGeoLocation.formattedAddressName
//                // Apple Inc.,
//                // 1 Infinite Loop,
//                // Cupertino, CA 95014
//                // United States
//        })
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func drawRoute(){
        
        let origin = "\(c_lat),\(c_longg)"
        let destination = "\(p_lat),\(p_longg)"
        
        
        print("origin2=\(origin)")
        print("destination=\(destination)")
        Helper().map_marker(lat: c_lat, longg: c_longg, map_view: self.map)
        
        Helper().map_marker(lat: p_lat, longg: p_longg, map_view: self.map)
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&alternatives=true&key=\(Key.Google.placesKey)"
        
        print("alter_url=\(url)")
        Alamofire.request(url).responseJSON { response in
            
            do {
                let json = try JSON(data: response.data!)
                
                let routes = json["routes"].arrayValue
                
                self.alternateRoutes = routes
                
                print("routes=\(routes.count)")
                
                
                let route  = routes[0]
                
//                let route = dict as! NSDictionary
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)
                polyline.map = self.map
                
//                for route in routes
//                {
//                    let routeOverviewPolyline = route["overview_polyline"].dictionary
//                    let points = routeOverviewPolyline?["points"]?.stringValue
//                    let path = GMSPath.init(fromEncodedPath: points!)
//
//                    let polyline = GMSPolyline(path: path)
//                    polyline.strokeColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)
//                    polyline.strokeWidth = 4.0
//                    polyline.map = self.map
//
//                }
                
            } catch { print(error) }
            
            
        }
        
//        let path = GMSMutablePath()
//
//        path.add(CLLocationCoordinate2DMake(24.91891891891892, 67.09286075038399))
//        path.add(CLLocationCoordinate2DMake(24.936936936936938, 67.10266777344651))
//
//
//        let rectangle = GMSPolyline(path: path)
//        rectangle
//        rectangle.strokeWidth = 2.0
//        rectangle.map = map
//
//        // Create a rectangular path
//        let rect = GMSMutablePath()
//        rect.add(CLLocationCoordinate2D(latitude: 24.91891891891892, longitude: 67.09286075038399))
//        rect.add(CLLocationCoordinate2D(latitude: 24.936936936936938, longitude: 67.10266777344651))
//
//
//
//
//        // Create the polygon, and assign it to the map.
//        let polygon = GMSPolygon(path: rect)
//        polygon.fillColor = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.05);
//        polygon.strokeColor = .black
//        polygon.strokeWidth = 2
//        polygon.map = self.map
    }
    @IBAction func park_now_btn(_ sender: UIButton) {
    }
    @IBAction func cancel_btn(_ sender: UIButton) {
        
        //self.dismiss(animated: true, completion: nil)
       
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func routes_btn(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlternateRouteVCNav") 
        
        //vc?.alternateRoutes = self.alternateRoutes
        
        
        self.present(vc, animated: true, completion: nil)
    }
}
