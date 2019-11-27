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
    
    @IBOutlet weak var btnCan: UIButton!
    @IBOutlet weak var cancelHeight: NSLayoutConstraint! ///55
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    var map = GMSMapView()
    var vcName : String!
    @IBOutlet weak var parkView: UIView!
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
        
        
        if(vcName.elementsEqual("nav"))
        {
            parkView.isHidden = true
            cancelHeight.constant = 55
            btnCan.isHidden = false
        }
        else
        {
            parkView.isHidden = false
            cancelHeight.constant = 0
            btnCan.isHidden = true
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.RemoveOldDrawRoute(notification:)), name:
            NSNotification.Name(rawValue: "NotificationName"), object: nil)
     
        
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
        
         if(vcName.elementsEqual("nav"))
         {
              drawRouteOnly()
         }
           else
           {
               drawRoute()
           }
        //        print("lat==\(location?.coordinate.latitude)")
        //        print("long==\(location?.coordinate.longitude)")
        
//        self.filterLat = (location?.coordinate.latitude)!
//        self.filterLong = (location?.coordinate.longitude)!
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 14.0)
        
        self.map.animate(to: camera)
        
       
        self.locationManager.stopUpdatingLocation()
        
    }
    
     func drawRouteOnly(){
            
            let origin = "\(c_lat),\(c_longg)"
            let destination = "\(p_lat),\(p_longg)"
            
            
            print("origin2=\(origin)")
            print("destination=\(destination)")
            Helper().map_marker(lat: c_lat, longg: c_longg, map_view: self.map)
            
            Helper().map_marker(lat: p_lat, longg: p_longg, map_view: self.map)
            
            
//            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&alternatives=true&key=\(Key.Google.placesKey)"
//
//            print("alter_url=\(url)")
//            Alamofire.request(url).responseJSON { response in
//
//                do {
//                    let json = try JSON(data: response.data!)
//                    print(json)
//                    let routes = json["routes"].arrayValue
                    
//                    self.alternateRoutes = routes
//
//                    print("routes=\(routes.count)")
                    
                    if(self.alternateRoutes.count>0)
                    {
                    let route  = self.alternateRoutes[0]
                    
    //                let route = dict as! NSDictionary
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor =  #colorLiteral(red: 0, green: 0.5356405973, blue: 0.7853047252, alpha: 1)
                    polyline.map = self.map
                        
                   
                   let leg = route["legs"].arrayValue
                   let legDict = leg[0].dictionary
                        let dictanceDict = legDict!["distance"]?.dictionary
                   let distance = dictanceDict?["text"]?.stringValue
                   self.lblDistance.text = distance
                   let durationDict = legDict!["duration"]?.dictionary
                   let duration = durationDict?["text"]?.stringValue
                   self.lblTime.text = duration
                        
                        
                    }
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
                print(json)
                let routes = json["routes"].arrayValue
                
                self.alternateRoutes = routes
                
                print("routes=\(routes.count)")
                
                if(routes.count>0)
                {
                    let route  = routes[0].dictionary
                let leg = route!["legs"]?.arrayValue
                let legDict = leg![0].dictionary
                let dictanceDict = legDict!["distance"]?.dictionary
                let distance = dictanceDict?["text"]?.stringValue
                self.lblDistance.text = distance
                let durationDict = legDict!["duration"]?.dictionary
                let duration = durationDict?["text"]?.stringValue
                self.lblTime.text = duration
//                let route = dict as! NSDictionary
                    let routeOverviewPolyline = route!["overview_polyline"]?.dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)
                polyline.map = self.map
                }
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
        
        
        func cal_distance(lat:Double,long:Double)  {
          let current_coordinate =  CLLocation(latitude: self.c_lat, longitude: self.c_longg)
          let coordinate2 = CLLocation(latitude: lat, longitude: long)
          let distanceInMiles = (current_coordinate.distance(from: coordinate2))/1609.344 //
            parking_title.text = String(format: "%.02f m", distanceInMiles)
                   
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
        
        
          let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alternateVC") as! AlternateRouteViewController
//
//
        vc.alternateRoutes = self.alternateRoutes
       
        self.present(vc, animated: true, completion: nil)
        
       
    }
    
    
    
    @objc func RemoveOldDrawRoute(notification : NSNotification){
        
        map.clear()
        let origin = "\(c_lat),\(c_longg)"
        let destination = "\(p_lat),\(p_longg)"
        
        
        print("origin2=\(origin)")
        print("destination=\(destination)")
        Helper().map_marker(lat: c_lat, longg: c_longg, map_view: self.map)
        
        Helper().map_marker(lat: p_lat, longg: p_longg, map_view: self.map)
        
        
        
        let json = try JSON(notification.userInfo as Any)
                      
        //let routes = json["routes"].arrayValue
        
     
        let route  = json
       // let route  = notification.userInfo as! JSON
        

        let routeOverviewPolyline = route["overview_polyline"].dictionary
        let points = routeOverviewPolyline?["points"]?.stringValue
        let path = GMSPath.init(fromEncodedPath: points!)
        let polyline = GMSPolyline.init(path: path)
        polyline.strokeWidth = 4
        polyline.strokeColor =  #colorLiteral(red: 0, green: 0.5356405973, blue: 0.7853047252, alpha: 1)
        polyline.map = self.map
            
       
        let leg = route["legs"].arrayValue
       let legDict = leg[0].dictionary
            let dictanceDict = legDict!["distance"]?.dictionary
       let distance = dictanceDict?["text"]?.stringValue
       self.lblDistance.text = distance
       let durationDict = legDict!["duration"]?.dictionary
       let duration = durationDict?["text"]?.stringValue
       self.lblTime.text = duration
                    
                    
                
       
                    
                }
}
