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
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var parkNowBtn: UIButton!
    @IBOutlet weak var cancelHeight: NSLayoutConstraint! ///55
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var altrBtn: UIButton!
//    @IBOutlet weak var parkView: UIView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    
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
    
    var isNavigating = false
    var isTracking = false
    var isBuyerNavigating = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
    
    var curentMarker = GMSMarker()
    var parkingMarker = GMSMarker()
    var navigationStart = false
    var parkingPosition:CLLocationCoordinate2D!
    var polyline:GMSPolyline!
    var sourcePosition: CLLocationCoordinate2D!
    
    var sendingService : LiveLocationSendingService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let c_lat = self.appDelegate.currentLocation?.coordinate.latitude ?? 0.0
        let c_long = self.appDelegate.currentLocation?.coordinate.longitude ?? 0.0
        
        sourcePosition = CLLocationCoordinate2D(latitude: c_lat, longitude: c_long)
        
        self.lblDistance.text = ""
        self.lblTime.text = ""
        self.parkNowBtn.isHidden = true
        print("ParkingNavVC=\(vcName)")
        //        loadMapView()
        self.parking_title.text = p_title
        
        if isTracking{
            goBtn.isHidden = true
            self.navItem.title = "Track Buyer"
            self.parking_title.text = self.parkingModel.address ?? "-"
            self.parkingPosition = CLLocationCoordinate2D(latitude: Double(self.parkingModel.latitude ?? "0.0")!, longitude: Double(self.parkingModel.longitude ?? "0.0")!)
            //            self.setParkingMaker(position: parkingPosition, title: APP_CONSTANT.THIS_IS_PARKING_SPOT)
            self.setLiveLocationReceivingService(parkingId: parkingModel.id ?? -1)
            
        }
        else if isBuyerNavigating{
            
            self.navItem.title = "Navigation"
            self.parking_title.text = self.parkingModel.address ?? "-"
            self.parkingPosition = CLLocationCoordinate2D(latitude: Double(self.parkingModel.latitude ?? "0.0")!, longitude: Double(self.parkingModel.longitude ?? "0.0")!)
            self.setParkingMaker(position: parkingPosition, title: APP_CONSTANT.THIS_IS_PARKING_SPOT)
            self.setCurrentMaker(position: sourcePosition, title: APP_CONSTANT.THIS_IS_ME)
            
            if self.parkingModel.status == APP_CONSTANT.STATUS_PARKING_NAVIGATING{
                buyerNavigationStart()
            }
            //            navigationStart = UserDefaults.standard.bool(forKey: "startNavigation")
            //
            //            if navigationStart{
            //                buyerNavigationStart()
            //            }
            //            let bounds = GMSCoordinateBounds(coordinate: sourcePosition, coordinate: parkingPosition)
            //            let camera: GMSCameraUpdate = GMSCameraUpdate.fit(bounds)
            //            self.map.animate(with: camera)
            //            let camera = GMSCameraPosition.camera(withTarget: sourcePosition, zoom: 18)
            //            self.map.animate(to: camera)
            
            //            sendingService = LiveLocationSendingService(parkingId: String(self.parkingModel.id!))
            
            //            buyerLocationUpdates()
            //            locationUpdates()
        }
        else if isNavigating{
            //            sendingService = LiveLocationSendingService(parkingId: String(self.parkingModel.id!))
            //            sellerLocationUpdates()
            self.navItem.title = "Navigation"
            self.navigationStart = true
            locationUpdates()
        }
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //        loadMapView()
        
        //        GMSGeometryIsLocationOnPathTolerance(<#T##point: CLLocationCoordinate2D##CLLocationCoordinate2D#>, <#T##path: GMSPath##GMSPath#>, <#T##geodesic: Bool##Bool#>, <#T##tolerance: CLLocationDistance##CLLocationDistance#>)
        
        if(vcName.elementsEqual("nav"))
        {
//            parkView.isHidden = true
            cancelHeight.constant = 55
            btnCan.isHidden = false
            goBtn.isHidden = true
        }
        else if (vcName.elementsEqual("track")){
//            parkView.isHidden = true
            cancelHeight.constant = 55
            btnCan.isHidden = false
            altrBtn.isHidden = true
        }
        else
        {
//            parkView.isHidden = false
            cancelHeight.constant = 0
            btnCan.isHidden = true
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.RemoveOldDrawNewRoute(notification:)), name: NSNotification.Name(rawValue: "NotificationRemoveRoute"), object: nil)
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.view.layoutIfNeeded()
        if isBuyerNavigating{
            loadMapViewForNav()
        }
        else if isNavigating{
            if (!isMapLoaded){
                isMapLoaded = true
                loadMapView()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                    let sourcePosition = CLLocationCoordinate2D(latitude: self.s_lat, longitude: self.s_longg)
                    let endPosition = CLLocationCoordinate2D(latitude: self.d_lat, longitude: self.d_longg)
                    
                    
                    self.getPolylineRouteForNavigationOnly(from: sourcePosition, to: endPosition)
                   
                    self.setCurrentMaker(position: sourcePosition, title: APP_CONSTANT.THIS_IS_ME)
                    self.setParkingMaker(position: endPosition, title: APP_CONSTANT.THIS_IS_YOUR_DESTINATION)
                   
                    
                }
            }
        }
        
        
        //        else if isTracking{
        //            loadMapViewForTrack()
        //        }
        
        
        //        }
        //
        
    }
    func getPolylineRouteForNavigationOnly(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
//        Helper().showSpinner(view: self.view)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving&alternatives=true&key=\(Key.Google.placesKey)")!
        
        print(url)
        
        
        self.setCurrentMaker(position: source, title: APP_CONSTANT.THIS_IS_ME)
        self.setParkingMaker(position: destination, title: APP_CONSTANT.THIS_IS_YOUR_DESTINATION)
        
        Alamofire.request(url).responseJSON { response in
            
            do {
                //here dataResponse received from a network request
                if let jsonData = response.data{
                    let response = try JSONDecoder().decode(DirectionAPI.self, from:jsonData) //Decode JSON Response Data
                    
                    
                    let routesArray = response.routes!
                    
                    self.alternateRoutes = routesArray
                    
                    if (routesArray.count > 0) {
                        let route = routesArray[0]
                        let dictPolyline = route.overviewPolyline
                        self.legs = route.legs
                        
                        let points = dictPolyline?.points
                        
                        self.showPath(polyStr: points!)
                        
                        
                        Helper().hideSpinner(view: self.view)
                        //                                self.activityIndicator.stopAnimating()
                        
                        let target = CLLocationCoordinate2D(latitude: source.latitude, longitude: source.longitude)
                        self.bearing = self.calculateBearer(legs: self.legs)
                        let camera = GMSCameraPosition.camera(withTarget: target, zoom: 18, bearing: self.bearing, viewingAngle: 180)
                        self.map.animate(to: camera)
                        
                    }
                    else {
                        
                        
                        Helper().hideSpinner(view: self.view)
                        
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
    
    func loadMapViewForNav(){
        
        print("::=loadMap")
        
        let midPointLat = (sourcePosition.latitude + parkingPosition.latitude) / 2
        let midPointLong = (sourcePosition.longitude + parkingPosition.longitude) / 2
        
        let midPosition = CLLocationCoordinate2D.init(latitude: midPointLat, longitude: midPointLong)
        //        let camera = GMSCameraPosition.init()
        let camera = GMSCameraPosition.camera(withTarget: midPosition, zoom: 14)
        map = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        map.settings.scrollGestures = true
        map.settings.zoomGestures = true
        map.settings.myLocationButton = false
        // self.mapView = mapView
        self.mapView.addSubview(map)
        
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
        map.padding = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 15)
        
        
        self.getPolylineRoute2(from: sourcePosition , to: self.parkingPosition)
        
        
        self.setParkingMaker(position: parkingPosition, title: APP_CONSTANT.THIS_IS_PARKING_SPOT)
        self.setCurrentMaker(position: sourcePosition, title: APP_CONSTANT.THIS_IS_ME)
        
    }
    
    func loadMapViewForTrack(){
        
        print("::=loadMap")
        
        let midPointLat = (sourcePosition.latitude + parkingPosition.latitude) / 2
        let midPointLong = (sourcePosition.longitude + parkingPosition.longitude) / 2
        
        let midPosition = CLLocationCoordinate2D.init(latitude: midPointLat, longitude: midPointLong)
        //        let camera = GMSCameraPosition.init()
        let camera = GMSCameraPosition.camera(withTarget: midPosition, zoom: 14)
        map = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        map.settings.scrollGestures = true
        map.settings.zoomGestures = true
        map.settings.myLocationButton = false
        // self.mapView = mapView
        self.mapView.addSubview(map)
        
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
        map.padding = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 15)
        
        
        self.getPolylineRoute2(from: sourcePosition , to: self.parkingPosition)
        
        
        self.setParkingMaker(position: parkingPosition, title: APP_CONSTANT.THIS_IS_PARKING_SPOT)
        self.setCurrentMaker(position: sourcePosition, title: APP_CONSTANT.THIS_IS_BUYER)
        
    }
    
    func locationUpdates(){
        
//        let request = LocationManager.shared.locateFromGPS(.continous, accuracy: .city) { data in
//            switch data {
//            case .failure(let error):
//                print("Location error: \(error)")
//            case .success(let location):
//
//                print("New Locationabc: \(location)")
//                self.c_lat =  Double(round(10000*(location.coordinate.latitude))/10000)
//                self.c_longg = Double(round(10000*(location.coordinate.longitude))/10000)
//
//                if let leg = self.legs{
//
//
//
//                    let endLat =  Double(round(10000*(leg[0].steps?[self.counter].endLocation?.lat ?? 0.0))/10000)
//                    let endLng =  Double(round(10000*(leg[0].steps?[self.counter].endLocation?.lng ?? 0.0))/10000)
//
//                    print("\(endLat) == \(self.c_lat )  \(endLng)  == \(self.c_longg)")
//
//                    print("\(self.legs[0].steps?.count ?? 0) ===  \(self.counter)")
//                    if(endLat == self.c_lat )&&(endLng == self.c_longg){
//
//                        self.counter += 1
//                        let target = CLLocationCoordinate2D(latitude: self.c_lat, longitude: self.c_longg)
//                        if((self.legs[0].steps?.count ?? 0 > self.counter)){
//                            self.bearing = self.calculateBearer(legs: self.legs)
//                        }
//
//                        let camera = GMSCameraPosition.camera(withTarget: target, zoom: 18, bearing: self.bearing, viewingAngle: 180)
//                        self.map.animate(to: camera)
//                        Helper().showToast(message: "step#\(self.counter) completed", controller: self)
//
//                    }
//                }
//                let sourcePosition = CLLocationCoordinate2D(latitude: self.c_lat, longitude: self.c_longg)
//                let endPosition = CLLocationCoordinate2D(latitude: self.d_lat, longitude: self.d_longg)
//
//                self.getPolylineRouteForNavigationOnly(from: sourcePosition, to: endPosition)
////                self.drawRouteOnly()
//
//            }
//        }
//        request.dataFrequency = .fixed(minInterval: 40, minDistance: 100)
//
        let request = LocationManager.shared.locateFromGPS(.continous, accuracy: .city, distance: 1) { data in
            switch data {
            case .failure(let error):
                print("Location error: \(error)")
            case .success(let location):
                
                
                print("New Locationabc: \(location)")
                let clat =  Double(round(10000000*(location.coordinate.latitude))/10000000)
                let cLong = Double(round(10000000*(location.coordinate.longitude))/10000000)
                
                let sourcePosition =  CLLocationCoordinate2D(latitude: clat, longitude: cLong)
                let endPosition = CLLocationCoordinate2D(latitude: self.d_lat, longitude: self.d_longg)
                self.setParkingMaker(position: endPosition, title: APP_CONSTANT.THIS_IS_PARKING_SPOT)
                self.setCurrentMaker(position: sourcePosition, title: APP_CONSTANT.THIS_IS_ME)
//
//                if self.isBuyerNavigating{
//                    self.sendingService.setBuyerCurrentLocation(lat: clat, long: cLong){_ in }
//                }
                
                if let leg = self.legs{
                    
                    let endLat =  Double(round(10000*(leg[0].steps?[self.counter].endLocation?.lat ?? 0.0))/10000)
                    let endLng =  Double(round(10000*(leg[0].steps?[self.counter].endLocation?.lng ?? 0.0))/10000)
                    
                    
                    
                    if(endLat == clat )&&(endLng == cLong){
                        
                        self.counter += 1
                        let target = CLLocationCoordinate2D(latitude: clat, longitude: cLong)
                        if((self.legs[0].steps?.count ?? 0 > self.counter)){
                            self.bearing = self.calculateBearer(legs: self.legs)
                        }
                        
                        let camera = GMSCameraPosition.camera(withTarget: target, zoom: 18, bearing: self.bearing, viewingAngle: 180)
                        self.map.animate(to: camera)
                        //                        Helper().showToast(message: "step#\(self.counter) completed", controller: self)
                        
                    }
                }
                else{
                    
                    self.getPolylineRoute2(from: sourcePosition , to: endPosition)
                    
                }
                
                
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    //                    self.map.clear()
                    self.getPolylineRoute2(from: sourcePosition , to: endPosition)
                    //                    self.drawRouteOnly()
                    Helper().calculateTimeAndDistance(s_lat: sourcePosition.latitude, s_longg: sourcePosition.longitude, d_lat: endPosition.latitude, d_longg: endPosition.longitude) { (distance,duration) in
                        self.lblDistance.text = distance
                        self.lblTime.text = duration
                        //                        self.getPolylineRoute(from: sourcePosition , to: endPosition)
                    }
                    
                }
                
                //                self.getPolylineRoute(from: sourcePosition, to: endPosition)
                
                
                
                
            }
        }
        request.dataFrequency = .fixed(minInterval: 40, minDistance: 100)
        
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func calculateBearer(legs:[Leg]) -> Double {
        
        //        print(self.legs[0].steps?[counter].startLocation)
        print(counter)
        let step = legs[0].steps?[counter]
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
        
        //        map.clear()
        let origin = "\(c_lat),\(c_longg)"
        let destination = "\(p_lat),\(p_longg)"
        
        
        print("origin2=\(origin)")
        print("destination=\(destination)")
        
        let sourcePosition = CLLocationCoordinate2D(latitude: self.c_lat, longitude: self.c_longg)
        let endPosition = CLLocationCoordinate2D(latitude: self.d_lat, longitude: self.d_longg)
        
        self.setCurrentMaker(position: sourcePosition, title: APP_CONSTANT.THIS_IS_ME)
        self.setParkingMaker(position: endPosition, title: APP_CONSTANT.THIS_IS_YOUR_DESTINATION)
        
        
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
        
        
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func parkNowBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert!", message: "Do you really want to park?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
            self.setParkingStatus(status: APP_CONSTANT.STATUS_PARKING_PARKED)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancel_btn(_ sender: UIButton) {
        
        
        if isNavigating{
            self.dismiss(animated: true, completion: nil)
        }
        else{
            self.showCancelParkingConfirmationDialog()
        }
        
        //        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goBtn(_ sender: UIButton) {
        
        
        buyerNavigationStart()
        //        UserDefaults.standard.set(true, forKey: "startNavigation")
        
        
        parkingModel.status = APP_CONSTANT.STATUS_PARKING_NAVIGATING
        
        
        setParkingStatus(status:APP_CONSTANT.STATUS_PARKING_NAVIGATING);
        
    }
    
    
    private func showCancelParkingConfirmationDialog() {
        let alert = UIAlertController(title: "Alert!", message: "Do you really want to Cancel?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
            self.cancelBuyerParking()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    public func cancelBuyerParking() {
        
        if (parkingPosition==nil) {
            
            return;
        }
        
        var request : APIRouter!
        if (checkMeAsASeller()) {
            request = APIRouter.cancelSellerParking(id: self.parkingModel.id ?? -1)
        } else {
            request = APIRouter.cancelBuyerParking(id: self.parkingModel.id ?? -1)
        }
        
        
        APIClient.serverRequest(url: request, path: request.getPath(), dec: PostResponseData.self) { (response, error) in
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if (response?.success) != nil {
                    Helper().showToast(message: response?.message ?? "-", controller: self)
                    
                    Helper.deleteChatAndRequests(parkingModel1: self.parkingModel)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        //                        self.dismiss(animated: true)
                        Helper().presentOnMainScreens(controller: self, index: 0)
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
    
    
    func checkMeAsASeller() -> Bool{
        
        
        let UID :Int = UserDefaults.standard.integer(forKey: "id")
        
        
        let id = self.parkingModel.sellerID
        //        let id = 60
        return UID == id ? true :  false
        
        
    }
    public func setParkingStatus(status:Int){
        assign_buyer(p_id: self.parkingModel.id ?? -2, status: status)
    }
    
    
    func buyerNavigationStart(){
        goBtn.isHidden = true
        self.parkNowBtn.isHidden = false
        sendingService = LiveLocationSendingService(parkingId: String(self.parkingModel.id!))
        
        self.navigationStart = true
        buyerLocationUpdates()
    }
    
    
    @IBAction func routes_btn(_ sender: UIButton) {
        
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alternateVC") as! AlternateRouteViewController
        
        vc.alternateRoutes = self.alternateRoutes
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    
    
    @objc func RemoveOldDrawNewRoute(notification : NSNotification){
        
        //        map.clear()
        let origin = "\(c_lat),\(c_longg)"
        let destination = "\(p_lat),\(p_longg)"
        
        
        print("origin2=\(origin)")
        print("destination=\(destination)")
        
        let sourcePosition = CLLocationCoordinate2D(latitude: self.c_lat, longitude: self.c_longg)
        let endPosition = CLLocationCoordinate2D(latitude: self.d_lat, longitude: self.d_longg)
        
        
        self.setCurrentMaker(position: sourcePosition, title: APP_CONSTANT.THIS_IS_ME)
        self.setParkingMaker(position: endPosition, title: APP_CONSTANT.THIS_IS_YOUR_DESTINATION)
        
  
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
                    let data = responseData["data"] as? [String:Any]
                    let model = Parking.init(dictionary: data ?? [:])
                    
                    if model?.status == APP_CONSTANT.STATUS_PARKING_PARKED{
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackVC
                        vc.parking_details = model
                        vc.p_id = p_id
                        self.present(vc, animated: true, completion: nil)
                    }
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
    
    
    
    
    
    
    func showPath(polyStr :String){
        
        let path = GMSPath(fromEncodedPath: polyStr)
        
        if self.polyline != nil {
            //remove existing the gmspoly line from your map
            self.polyline.map = nil
        }
        self.polyline = GMSPolyline(path: path)
        self.polyline.strokeWidth = 6.0
        self.polyline.strokeColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)
        self.polyline.map = self.map // Your map view
        
    }
    func removePolyLine(){
        
        self.polyline = nil
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
        
        self.sourcePosition = self.buyerLocation!
        
        if !trackingStart{
            
            loadMapViewForTrack()
            trackingStart = true
            self.getPolylineRoute2(from: self.sourcePosition! , to: self.parkingPosition)
        }
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            self.getPolylineRoute2(from: self.sourcePosition! , to: self.parkingPosition)
            
            
        }
        
        self.setParkingMaker(position: self.parkingPosition, title: APP_CONSTANT.THIS_IS_PARKING_SPOT)
        self.setCurrentMaker(position: sourcePosition, title: APP_CONSTANT.THIS_IS_BUYER)
        
    }
    
    
    
    
}





//Buyer Location Sender
extension ParkingNavVC{
    
    
    
    func buyerLocationUpdates(){
        
        
        
        let request = LocationManager.shared.locateFromGPS(.continous, accuracy: .city, distance: 1) { data in
            switch data {
            case .failure(let error):
                print("Location error: \(error)")
            case .success(let location):
                
                
                print("New Locationabc: \(location)")
                let clat =  Double(round(10000000*(location.coordinate.latitude))/10000000)
                let cLong = Double(round(10000000*(location.coordinate.longitude))/10000000)
                
                let sourcePosition =  CLLocationCoordinate2D(latitude: clat, longitude: cLong)
                
                self.setParkingMaker(position: self.parkingPosition, title: APP_CONSTANT.THIS_IS_PARKING_SPOT)
                self.setCurrentMaker(position: sourcePosition, title: APP_CONSTANT.THIS_IS_ME)
                
                
                self.sendingService.setBuyerCurrentLocation(lat: clat, long: cLong){_ in }
                
                
                if let leg = self.legs{
                    
                    let endLat =  Double(round(10000*(leg[0].steps?[self.counter].endLocation?.lat ?? 0.0))/10000)
                    let endLng =  Double(round(10000*(leg[0].steps?[self.counter].endLocation?.lng ?? 0.0))/10000)
                    
                    
                    
                    if(endLat == clat )&&(endLng == cLong){
                        
                        self.counter += 1
                        let target = CLLocationCoordinate2D(latitude: clat, longitude: cLong)
                        if((self.legs[0].steps?.count ?? 0 > self.counter)){
                            self.bearing = self.calculateBearer(legs: self.legs)
                        }
                        
                        let camera = GMSCameraPosition.camera(withTarget: target, zoom: 18, bearing: self.bearing, viewingAngle: 180)
                        self.map.animate(to: camera)
                        //                        Helper().showToast(message: "step#\(self.counter) completed", controller: self)
                        
                    }
                }
                else{
                    
                    self.getPolylineRoute2(from: sourcePosition , to: self.parkingPosition)
                    
                }
                
                
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    //                    self.map.clear()
                    self.getPolylineRoute2(from: sourcePosition , to: self.parkingPosition)
                    //                    self.drawRouteOnly()
                    Helper().calculateTimeAndDistance(s_lat: sourcePosition.latitude, s_longg: sourcePosition.longitude, d_lat: Double(self.parkingModel.latitude ?? "0.0")!, d_longg: Double(self.parkingModel.longitude ?? "0.0")!) { (distance,duration) in
                        self.lblDistance.text = distance
                        self.lblTime.text = duration
                        //                        self.getPolylineRoute(from: sourcePosition , to: endPosition)
                    }
                    
                }
                
                //                self.getPolylineRoute(from: sourcePosition, to: endPosition)
                
                
                
                
            }
        }
        request.dataFrequency = .fixed(minInterval: 40, minDistance: 100)
    }
    
    func setLiveLocationSendingService(parkingId:Int, lat:Double, longg:Double){
        
        let sendingservice : LiveLocationSendingService =  LiveLocationSendingService(parkingId: String(parkingId))
        
        // replace lat long wit clllocation manager and pass current actual location
        
        sendingservice.setBuyerCurrentLocation(lat: lat, long: longg) { parking  in
        }
    }
    
    func setCurrentMaker(position:CLLocationCoordinate2D, title:String){
        
        
        // I have taken a pin image which is a custom image
        let markerImage = UIImage(named: "s_marker")!.withRenderingMode(.alwaysTemplate)
        
        //creating a marker view
        let markerView = UIImageView(image: markerImage)
        
        //changing the tint color of the image
        markerView.tintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        
        curentMarker.position = position //CLLocationCoordinate2D(latitude: lat, longitude: longg)
        
        curentMarker.iconView = markerView
        curentMarker.title = title
        //marker.snippet = "price"
        curentMarker.map = self.map
    }
    
    func setParkingMaker(position:CLLocationCoordinate2D, title:String){
        
        
        // I have taken a pin image which is a custom image
        let markerImage = UIImage(named: "s_marker")!.withRenderingMode(.alwaysTemplate)
        
        //creating a marker view
        let markerView = UIImageView(image: markerImage)
        
        //changing the tint color of the image
        markerView.tintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        
        parkingMarker.position = position //CLLocationCoordinate2D(latitude: lat, longitude: longg)
        
        parkingMarker.iconView = markerView
        parkingMarker.title = title
        //marker.snippet = "price"
        parkingMarker.map = self.map
    }
    
    //    func changeCurrentMarkerPosition(position:CLLocationCoordinate2D){
    //        curentMarker.position = position
    //    }
    
    
    func getPolylineRoute2(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        //        let config = URLSessionConfiguration.default
        //        let session = URLSession(configuration: config)
        
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving&alternatives=true&key=\(Key.Google.placesKey)")!
        
        
        Alamofire.request(url).responseJSON { response in
            
            do {
                //here dataResponse received from a network request
                if let jsonData = response.data{
                    let response = try JSONDecoder().decode(DirectionAPI.self, from:jsonData) //Decode JSON Response Data
                    
                    
                    let routesArray = response.routes!
                    
                    self.alternateRoutes = routesArray
                    
                    //                    print(self.alternateRoutes)
                    if (routesArray.count > 0) {
                        
                        let route = routesArray[0]
                        let dictPolyline = route.overviewPolyline
                        self.legs = route.legs
                        //                        print("legs==\(route.legs?[0].steps?.count)")
                        
                        let points = dictPolyline?.points
                        
                        self.showPath(polyStr: points!)
                        
                        if self.navigationStart{
                            let target = CLLocationCoordinate2D(latitude: source.latitude, longitude: source.longitude)
                            self.bearing = self.calculateBearer(legs: self.legs)
                            let camera = GMSCameraPosition.camera(withTarget: target, zoom: 18, bearing: self.bearing, viewingAngle: 180)
                            self.map.animate(to: camera)
                        }
                        
                        var val : Int;
                        var val2 : String
                        
                        val = route.legs?[0].distance?.value ?? 0 // in meter
                        val2 = route.legs?[0].duration?.text ?? ""
                        var valDouble = 0.0
                        
                        
                        // converting in miles
                        valDouble = Double(val) / 1609.344
                        let distance = String(format: "%.2f", valDouble) + " mile"
                        
                        let duration = String(val2)
                        
                        self.lblDistance.text = distance
                        self.lblTime.text = duration
                        
                    }
                    else {
                        Helper().hideSpinner(view: self.view)
                        
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
                Helper().hideSpinner(view: self.view)
            }
            
        }
    }
}




