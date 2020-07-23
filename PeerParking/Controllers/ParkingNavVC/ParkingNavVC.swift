//
//  ParkingNavVC.swift
//  PeerParking
//
//  Created by Apple on 23/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import GoogleMaps
//import CoreLocation
import Alamofire
import SwiftyJSON
import HelperClassPod
import SwiftLocation


class ParkingNavVC: UIViewController{
    
    //IBOutlets
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var parking_title: UILabel!
    
    @IBOutlet weak var btnCan: UIButton!
    @IBOutlet weak var cancelHeight: NSLayoutConstraint! ///55
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var altrBtn: UIButton!
    @IBOutlet weak var parkView: UIView!
    
    
    
    var isMapLoaded = false
    var map = GMSMapView()
    var vcName : String!
    var locationManager = CLLocationManager()
    
    var counter = 0
    var bearing = 0.0
    var legs:[Leg]!
    var parking_details:Parking!
    
    //Intent Variables
    var p_title:String = ""
    var p_lat:Double = 0.0
    var p_longg:Double = 0.0
    var alternateRoutes:[Route]!
    var isTracking = false
    
    var p_id:Int!
    var c_lat:Double = 0.0
    var c_longg:Double = 0.0
    
    
    var s_lat:Double = 0.0
    var s_longg:Double = 0.0
    
    var d_lat:Double = 0.0
    var d_longg:Double = 0.0
    
    //For Buyer Tracking//
    
    //Intent Variables
    var parkingModel = Parking()
    
    //Variables
    var buyerLocation:CLLocationCoordinate2D?
    var trackingStart = false
    //For Buyer Tracking//
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        self.lblDistance.text = ""
        self.lblTime.text = ""
        
        print("ParkingNavVC=\(vcName)")
//        loadMapView()
        self.parking_title.text = p_title
        
        if isTracking{
            
            self.parking_title.text = self.parkingModel.address ?? "-"
            self.setLiveLocationReceivingService(parkingId: parkingModel.id ?? -1)
            
        }
        else{
            locationUpdates()
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func locationUpdates(){
        
        let request = LocationManager.shared.locateFromGPS(.continous, accuracy: .city) { data in
          switch data {
            case .failure(let error):
                print("Location error: \(error)")
            case .success(let location):
                
                print("New Locationabc: \(location)")
                self.c_lat =  Double(round(10000*(location.coordinate.latitude))/10000)
                self.c_longg = Double(round(10000*(location.coordinate.longitude))/10000)
                
                if let leg = self.legs{
                    
                  
                    
                    let endLat =  Double(round(10000*(leg[0].steps?[self.counter].endLocation?.lat ?? 0.0))/10000)
                    let endLng =  Double(round(10000*(leg[0].steps?[self.counter].endLocation?.lng ?? 0.0))/10000)
                    
                    print("\(endLat) == \(self.c_lat )  \(endLng)  == \(self.c_longg)")
                    
                    print("\(self.legs[0].steps?.count ?? 0) ===  \(self.counter)")
                    if(endLat == self.c_lat )&&(endLng == self.c_longg){
                        
                        self.counter += 1
                        let target = CLLocationCoordinate2D(latitude: self.c_lat, longitude: self.c_longg)
                        if((self.legs[0].steps?.count ?? 0 > self.counter)){
                            self.bearing = self.calculateBearer()
                        }
                        
                        let camera = GMSCameraPosition.camera(withTarget: target, zoom: 18, bearing: self.bearing, viewingAngle: 180)
                        self.map.animate(to: camera)
                        Helper().showToast(message: "step#\(self.counter) completed", controller: self)
                       
                    }
                }
                
                
                self.drawRouteOnly()
               
          }
        }
        request.dataFrequency = .fixed(minInterval: 40, minDistance: 100)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        loadMapView()
       
//        GMSGeometryIsLocationOnPathTolerance(<#T##point: CLLocationCoordinate2D##CLLocationCoordinate2D#>, <#T##path: GMSPath##GMSPath#>, <#T##geodesic: Bool##Bool#>, <#T##tolerance: CLLocationDistance##CLLocationDistance#>)
        
        if(vcName.elementsEqual("nav"))
        {
            parkView.isHidden = true
            cancelHeight.constant = 55
            btnCan.isHidden = false
        }
        else if (vcName.elementsEqual("track")){
            parkView.isHidden = true
            cancelHeight.constant = 55
            btnCan.isHidden = false
            altrBtn.isHidden = true
        }
        else
        {
            parkView.isHidden = false
            cancelHeight.constant = 0
            btnCan.isHidden = true
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.RemoveOldDrawNewRoute(notification:)), name: NSNotification.Name(rawValue: "NotificationRemoveRoute"), object: nil)
        
       
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.view.layoutIfNeeded()
        
        if (!isMapLoaded){
            isMapLoaded = true
            loadMapView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                     
                let sourcePosition = CLLocationCoordinate2D(latitude: self.s_lat, longitude: self.s_longg)
                let endPosition = CLLocationCoordinate2D(latitude: self.d_lat, longitude: self.d_longg)
                
               
                self.getPolylineRoute(from: sourcePosition, to: endPosition)
                Helper().map_marker(lat: self.c_lat, longg: self.c_longg, map_view: self.map, title: APP_CONSTANT.THIS_IS_ME)
                Helper().map_marker(lat: self.p_lat, longg: self.p_longg, map_view: self.map, title: APP_CONSTANT.THIS_IS_YOUR_DESTINATION)
                       
            }
        }
               
       
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
        map.settings.myLocationButton = true
        map.padding = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 15)
        
        
//        //Location Manager code to fetch current location
//        self.locationManager.delegate = self
//        self.locationManager.startUpdatingLocation()
    }
    
    
    
//    //Location Manager delegates
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        let location = locations.last
//        
//        
//        self.c_lat = (location?.coordinate.latitude)!
//        self.c_longg = (location?.coordinate.longitude)!
//        
//        let origin = "\(c_lat),\(c_lat)"
//        
////        let sourcePosition = CLLocationCoordinate2D(latitude: self.c_lat, longitude: self.c_longg)
//        let endPosition = CLLocation(latitude: self.p_lat, longitude: self.p_longg)
//        
//        
//        if self.legs != nil{
//            
//             self.bearer = calculateBearer(legs: self.legs)
//        }
//       
//        
//        
//        
//    }
    

    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }

    func calculateBearer() -> Double {

//        print(self.legs[0].steps?[counter].startLocation)
        print(counter)
        let step = self.legs[0].steps?[counter]
        let point1 = CLLocation(latitude: (step?.startLocation?.lat)!, longitude: (step?.startLocation?.lng)!)
        let point2 = CLLocation(latitude: (step?.endLocation?.lat)!, longitude: (step?.endLocation?.lng)!)
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)

        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansToDegrees(radians: radiansBearing)
    }

    
    func drawRouteOnly(){

        map.clear()
        let origin = "\(c_lat),\(c_longg)"
        let destination = "\(p_lat),\(p_longg)"


        print("origin2=\(origin)")
        print("destination=\(destination)")
        Helper().map_marker(lat: c_lat, longg: c_longg, map_view: self.map, title: APP_CONSTANT.THIS_IS_ME)

        Helper().map_marker(lat: d_lat, longg: d_longg, map_view: self.map, title: APP_CONSTANT.THIS_IS_YOUR_DESTINATION)

        if let alTRoures = self.alternateRoutes,(self.alternateRoutes.count>0)
        {
            let route  =  alTRoures[0]

            //                let route = dict as! NSDictionary
            let routeOverviewPolyline = route.overviewPolyline
            let points = routeOverviewPolyline?.points
            let path = GMSPath.init(fromEncodedPath: points!)
            let polyline = GMSPolyline.init(path: path)
            polyline.strokeWidth = 6.0
            polyline.strokeColor =  #colorLiteral(red: 0, green: 0.5356405973, blue: 0.7853047252, alpha: 1)
            polyline.map = self.map


//            let leg = route["legs"].arrayValue
            let legDict = route.legs?[0]
            let dictanceDict = legDict?.distance
            let distance = dictanceDict?.text
            self.lblDistance.text = distance
            let durationDict = legDict?.duration
            let duration = durationDict?.text
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

    
    
//    func drawRoute(){
//
//       // map.clear()
//        let origin = "\(c_lat),\(c_longg)"
//        let destination = "\(p_lat),\(p_longg)"
//
//
//        print("origin2=\(origin)")
//        print("destination=\(destination)")
//
//
//        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&alternatives=true&key=\(Key.Google.placesKey)"
//
//        print("alter_url=\(url)")
//        Alamofire.request(url).responseJSON { response in
//
//            do {
//                let json = try JSON(data: response.data!)
//                print(json)
//                let routes = json["routes"].arrayValue
//
//                self.alternateRoutes = routes
//
//                print("routes=\(routes.count)")
//
//                if(routes.count>0)
//                {
//                    let route  = routes[0].dictionary
//                    let leg = route!["legs"]?.arrayValue
//                    let legDict = leg![0].dictionary
//                    let dictanceDict = legDict!["distance"]?.dictionary
//                    let distance = dictanceDict?["text"]?.stringValue
//                    self.lblDistance.text = distance
//                    let durationDict = legDict!["duration"]?.dictionary
//                    let duration = durationDict?["text"]?.stringValue
//                    self.lblTime.text = duration
//                    //                let route = dict as! NSDictionary
//                    let routeOverviewPolyline = route!["overview_polyline"]?.dictionary
//                    let points = routeOverviewPolyline?["points"]?.stringValue
//                    let path = GMSPath.init(fromEncodedPath: points!)
//                    let polyline = GMSPolyline.init(path: path)
//                    polyline.strokeWidth = 4
//                    polyline.strokeColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)
//
//
//                    self.map.clear()
//
//                    Helper().map_marker(lat: self.c_lat, longg: self.c_longg, map_view: self.map, title: "This is you")
//
//                    Helper().map_marker(lat: self.p_lat, longg: self.p_longg, map_view: self.map, title: "This is parking")
//
//                    polyline.map = self.map
//                }
//                //                for route in routes
//                //                {
//                //                    let routeOverviewPolyline = route["overview_polyline"].dictionary
//                //                    let points = routeOverviewPolyline?["points"]?.stringValue
//                //                    let path = GMSPath.init(fromEncodedPath: points!)
//                //
//                //                    let polyline = GMSPolyline(path: path)
//                //                    polyline.strokeColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)
//                //                    polyline.strokeWidth = 4.0
//                //                    polyline.map = self.map
//                //
//                //                }
//
//            } catch { print(error) }
//
//
//        }
//
//
//        func cal_distance(lat:Double,long:Double)  {
//            let current_coordinate =  CLLocation(latitude: self.c_lat, longitude: self.c_longg)
//            let coordinate2 = CLLocation(latitude: lat, longitude: long)
//            let distanceInMiles = (current_coordinate.distance(from: coordinate2))/1609.344 //
//            parking_title.text = String(format: "%.02f m", distanceInMiles)
//
//        }
//
//        //        let path = GMSMutablePath()
//        //
//        //        path.add(CLLocationCoordinate2DMake(24.91891891891892, 67.09286075038399))
//        //        path.add(CLLocationCoordinate2DMake(24.936936936936938, 67.10266777344651))
//        //
//        //
//        //        let rectangle = GMSPolyline(path: path)
//        //        rectangle
//        //        rectangle.strokeWidth = 2.0
//        //        rectangle.map = map
//        //
//        //        // Create a rectangular path
//        //        let rect = GMSMutablePath()
//        //        rect.add(CLLocationCoordinate2D(latitude: 24.91891891891892, longitude: 67.09286075038399))
//        //        rect.add(CLLocationCoordinate2D(latitude: 24.936936936936938, longitude: 67.10266777344651))
//        //
//        //
//        //
//        //
//        //        // Create the polygon, and assign it to the map.
//        //        let polygon = GMSPolygon(path: rect)
//        //        polygon.fillColor = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.05);
//        //        polygon.strokeColor = .black
//        //        polygon.strokeWidth = 2
//        //        polygon.map = self.map
//    }
    @IBAction func park_now_btn(_ sender: UIButton) {
        
       
        
        if let id = p_id {
            
            print("p_id==\(id)")
            assign_buyer(p_id: id, status: 30)
            
        }
    }
    
    @IBAction func cancel_btn(_ sender: UIButton) {
        
        //self.dismiss(animated: true, completion: nil)
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func routes_btn(_ sender: UIButton) {
        
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alternateVC") as! AlternateRouteViewController

        vc.alternateRoutes = self.alternateRoutes
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    
    
    @objc func RemoveOldDrawNewRoute(notification : NSNotification){
        
        map.clear()
        let origin = "\(c_lat),\(c_longg)"
        let destination = "\(p_lat),\(p_longg)"
        
        
        print("origin2=\(origin)")
        print("destination=\(destination)")
        Helper().map_marker(lat: s_lat, longg: s_longg, map_view: self.map, title: APP_CONSTANT.THIS_IS_ME)
        
        Helper().map_marker(lat: d_lat, longg: d_longg, map_view: self.map, title: APP_CONSTANT.THIS_IS_YOUR_DESTINATION)
        
        if let userInfo = notification.userInfo as NSDictionary? {
            if let dict = userInfo["dict"] as? Route{
            
//                print(dict.copyrights)
                
                let dictPolyline = dict.overviewPolyline

                let points = dictPolyline?.points

                 self.showPath(polyStr: points!)
            }
        }
        

        
    }
    
    func assign_buyer(p_id:Int,status:Int){
        
//        let status:Int = 30
        
        let params:[String:Any] = [
        
            
            "status" : status
        
        ]
        
        //params.updateValue("hello", forKey: "new_val")
        let auth_value =  "Bearer \(UserDefaults.standard.string(forKey: APP_CONSTANT.ACCESSTOKEN)!)"
        let headers: HTTPHeaders = [
            "Authorization" : auth_value
        ]
        print("==0params=\(params)")
        print("==0headers=\(headers)")
        
        //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customVC")
        //        self.present(vc, animated: true, completion: nil)
        
        
        let url = "\(APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.ASSIGN_BUYER)/\(p_id)"
        
        print("url--\(url)")

        
        Helper().Request_Api(url: url, methodType: .post, parameters: params, isHeaderIncluded: true, headers: headers){ response in

            print("response>>>\(response)")

            if response.result.value == nil {
                print("No response")

                SharedHelper().showToast(message: "Internal Server Error", controller: self)
                return
            }
            else {
                let responseData = response.result.value as! NSDictionary
                let status = responseData["success"] as! Bool
                if(status)
                {
                    let message = responseData["message"] as! String
                    //let uData = responseData["data"] as! NSDictionary
                    //let userData = uData["user"] as! NSDictionary
                    //self.saveData(userData: userData)
                    //                    SharedHelper().hideSpinner(view: self.view)
                    //                     UserDefaults.standard.set("yes", forKey: "login")
                    //                    UserDefaults.standard.synchronize()
                    SharedHelper().showToast(message: message, controller: self)

                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackVC
                    vc.parking_details = self.parking_details
                    vc.p_id = p_id
                    self.present(vc, animated: true, completion: nil)
                    //self.after_signin()
                }
                else
                {
                    let message = responseData["message"] as! String
                    SharedHelper().showToast(message: message, controller: self)
                    //   SharedHelper().hideSpinner(view: self.view)
                }
            }
        }
    }
    
    
    
    
    //New Functions
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){

//        Helper().showSpinner(view: self.view)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving&alternatives=true&key=\(Key.Google.placesKey)")!
               
        print(url)
        
        
      
        Alamofire.request(url).responseJSON { response in
            
             do {
                   //here dataResponse received from a network request
                   if let jsonData = response.data{
                       let response = try JSONDecoder().decode(DirectionAPI.self, from:jsonData) //Decode JSON Response Data
                      
                      
                        let routesArray = response.routes!

                        self.alternateRoutes = routesArray

                        print(self.alternateRoutes)
                        if (routesArray.count > 0) {
                            let route = routesArray[0]
                            let dictPolyline = route.overviewPolyline
                            self.legs = route.legs
                            print("legs==\(route.legs?[0].steps?.count)")
                            
                            let points = dictPolyline?.points

                            self.showPath(polyStr: points!)

                            
//                                Helper().hideSpinner(view: self.view)
                        //                                self.activityIndicator.stopAnimating()

                                let target = CLLocationCoordinate2D(latitude: source.latitude, longitude: source.longitude)
                                self.bearing = self.calculateBearer()
                                let camera = GMSCameraPosition.camera(withTarget: target, zoom: 18, bearing: self.bearing, viewingAngle: 180)
                                self.map.animate(to: camera)

                                print("bearing=\(self.bearing)")
                        //                                let bounds = GMSCoordinateBounds(coordinate: source, coordinate: destination)
                        //                                let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 170, left: 30, bottom: 30, right: 30))
                        //                                self.map.moveCamera(update)
                            
                        }
                        else {
                           

                                Helper().hideSpinner(view: self.view)
                        //                                self.activityIndicator.stopAnimating()
                            
                        }
                   }
               } catch let parsingError {
                   print("Error", parsingError)
                    Helper().hideSpinner(view: self.view)
               }
                                  
            
        }
//        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving&key=\(Key.Google.placesKey)")!

//        let task = session.dataTask(with: url, completionHandler: {
//            (data, response, error) in
//            if error != nil {
//                print(error!.localizedDescription)
//
//                Helper().hideSpinner(view: self.view)
////                self.activityIndicator.stopAnimating()
//            }
//            else {
//                do {
//
//                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
//
//
//                        guard let routes = json["routes"] as? NSArray else {
//                            DispatchQueue.main.async {
//
//                                Helper().hideSpinner(view: self.view)
////                                self.activityIndicator.stopAnimating()
//
//                            }
//                            return
//                        }
//
////                        var json = try JSON(data: data!)
//                        var json = try JSONDecoder().decode(DirectionAPI.self, from:data!)
//                        print(json.routes)
//                        let routesArray = json.routes!
//
//                        self.alternateRoutes = routesArray
//
//                        if (routesArray.count > 0) {
//                            let route = routesArray[0]
//                            let dictPolyline = route.overviewPolyline
//                            self.legs = route.legs
//                            print("legs==\(self.legs!)")
//                            let points = dictPolyline?.points
//
//                            self.showPath(polyStr: points!)
//
//                            DispatchQueue.main.async {
//
//                                Helper().hideSpinner(view: self.view)
////                                self.activityIndicator.stopAnimating()
//
//                                let target = CLLocationCoordinate2D(latitude: source.latitude, longitude: source.longitude)
//                                let camera = GMSCameraPosition.camera(withTarget: target, : 17, bearing: self.bearer, viewingAngle: 90)
//                                self.map.animate(to: camera)
//
//                                print("bearing=\(self.bearer)")
////                                let bounds = GMSCoordinateBounds(coordinate: source, coordinate: destination)
////                                let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 170, left: 30, bottom: 30, right: 30))
////                                self.map.moveCamera(update)
//                            }
//                        }
//                        else {
//                            DispatchQueue.main.async {
//
//                                Helper().hideSpinner(view: self.view)
////                                self.activityIndicator.stopAnimating()
//                            }
//                        }
//                    }
//                }
//                catch {
//                    print("error in JSONSerialization")
//                    DispatchQueue.main.async {
//
//                        Helper().hideSpinner(view: self.view)
////                        self.activityIndicator.stopAnimating()
//                    }
//                }
//            }
//        })
//        task.resume()
    }

    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 6.0
        polyline.strokeColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)
        polyline.map = self.map // Your map view
        
     

    }
    
    
}

//Buyer Location Reciever
extension ParkingNavVC:LiveLocationReceivingServiceDeleegate{
    
    //Callback
    func updateLocation(latitude: Double?, longitude: Double?) {
        print("latititude \(latitude ?? 0.0)")
        print("longitude \(longitude ?? 0.0)")
        
        self.buyerLocation = CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
        self.trackBuyer()
    }
    
    //Start Service
    func setLiveLocationReceivingService(parkingId:Int){
        // replace 611 to origional parking id
        
        let service : LiveLocationReceivingService =  LiveLocationReceivingService(parkingId: String(parkingId))
        service.delegate = self
        
    }
    
    func trackBuyer(){
        
        self.map.clear()
        let sourcePosition =  buyerLocation ?? CLLocationCoordinate2D()
        let endPosition = CLLocationCoordinate2D(latitude: Double(parkingModel.latitude ?? "0.0")!, longitude: Double(parkingModel.longitude ?? "0.0")!)
        
        //            self.getPolylineRoute(from: sourcePosition, to: endPosition)
        
        let target = sourcePosition
        
        let camera = GMSCameraPosition.camera(withTarget: target, zoom: 18, bearing: self.bearing, viewingAngle: 180)
         self.map.animate(to: camera)
        
        if !trackingStart{
            Helper().calculateTimeAndDistance(s_lat: sourcePosition.latitude, s_longg: sourcePosition.longitude, d_lat: Double(self.parkingModel.latitude ?? "0.0")!, d_longg: Double(self.parkingModel.longitude ?? "0.0")!) { (distance,duration) in
                self.lblDistance.text = distance
                self.lblTime.text = duration
                self.getPolylineRoute(from: sourcePosition , to: endPosition)
            }
        }

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            Helper().calculateTimeAndDistance(s_lat: sourcePosition.latitude, s_longg: sourcePosition.longitude, d_lat: Double(self.parkingModel.latitude ?? "0.0")!, d_longg: Double(self.parkingModel.longitude ?? "0.0")!) { (distance,duration) in
                self.lblDistance.text = distance
                self.lblTime.text = duration
                self.getPolylineRoute(from: sourcePosition , to: endPosition)
            }
            
        }
        
        
        Helper().map_marker(lat: sourcePosition.latitude , longg: sourcePosition.longitude, map_view: self.map, title: APP_CONSTANT.THIS_IS_BUYER,image: "carMarker")
        Helper().map_marker(lat: Double(parkingModel.latitude ?? "0.0")!, longg: Double(parkingModel.longitude ?? "0.0")!, map_view: self.map, title: APP_CONSTANT.THIS_IS_PARKING_SPOT)
    }
    
    
    func setLiveLocationSendingService(parkingId:Int){
        
        //        var sendingservice : LiveLocationSendingService =  LiveLocationSendingService(parkingId: String(612))
        //
        //        // replace lat long wit clllocation manager and pass current actual location
        //
        //        sendingservice.setBuyerCurrentLocation(lat: 24.9472804, long: 67.1057191) { parking  in
        //
        //            print("sending latititude \(parking.latitude)")
        //            print("sending longitude \(parking.longitude)")
        //
        //        }
    }
    
}



