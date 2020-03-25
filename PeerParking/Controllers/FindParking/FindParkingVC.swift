//
//  FindParkingVC.swift
//  PeerParking
//
//  Created by Apple on 14/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import CoreLocation
//import MapKit
import GooglePlacesSearchController
import GoogleMaps
import GooglePlaces
import FittedSheets
import HelperClassPod
import SwiftyJSON
import Alamofire


class FindParkingVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate{
    
    var isMapLoaded = false
   
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //IBOutlets
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var search_tf: UITextField!
    @IBOutlet weak var filter_btn: UIButton!
    @IBOutlet weak var view_all_btn: UIButton!
    @IBOutlet weak var re_center_btn: UIButton!
    
    @IBOutlet weak var re_center_bottom_cont: NSLayoutConstraint!
    
    //Variables
    var estimateWidth=130
    var cellMarginSize=1
    var address = "abc"
    var autocomp = false
    var lat = 0.0
    var longg = 0.0
    
    var filterLat = 0.0
    var filterLong = 0.0
    
    var parkings:[Parking] = []
    
    var locationManager = CLLocationManager()
    var map = GMSMapView()
    
    var cameraView:GMSCameraPosition!
    
    let GoogleMapsAPIServerKey = Key.Google.placesKey
    
    
    override func loadView() {
        super.loadView()
        
        self.lat = self.appDelegate.currentLocation?.coordinate.latitude ?? 0.0
        self.longg = self.appDelegate.currentLocation?.coordinate.longitude ?? 0.0
        self.address = self.appDelegate.currentLocationAddress ?? ""
        self.cameraView = self.appDelegate.camera
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
        //Register
        self.myCollectionView.register(UINib(nibName: "homeParkingCell", bundle: nil), forCellWithReuseIdentifier: "homeParkingCell")
        
        myCollectionView.isHidden = true
        filter_btn.isHidden = true
        view_all_btn.isHidden = true
        
       

//

    }
    
    func  setMapButton(){
        
        let bottomPadding = UIScreen.main.bounds.height-view_all_btn.frame.origin.y
        print("bottomPadding=\(bottomPadding)")
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
        map.padding = UIEdgeInsets(top: 0, left: 0, bottom: bottomPadding, right: 20)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        
//        Helper().hideSpinner(view: self.view)
        tab_index = 0
        print("::=willapear")
        self.parkings.removeAll()
        self.map.clear()
        self.myCollectionView.reloadData()
        self.tabBarController!.navigationItem.title = "Find Parking"
        self.tabBarController!.navigationItem.rightBarButtonItem = nil
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
        
        if(!autocomp){
            if (!isMapLoaded){
                isMapLoaded = true
                loadMapView()
            }
            
            mapMoveToCurrentLoc()
        }
    }
    
    func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
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
        
        self.map.animate(to: cameraView)

    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        
        self.lat = (location?.coordinate.latitude)!
        self.longg = (location?.coordinate.longitude)!

        self.filterLat = (location?.coordinate.latitude)!
        self.filterLong = (location?.coordinate.longitude)!
        
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
//                self.address = reversedGeoLocation.formattedAddressName
//                // Apple Inc.,
//                // 1 Infinite Loop,
//                // Cupertino, CA 95014
//                // United States
//        })
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(camera.target) { (response, error) in
            guard error == nil else {
            return
            }

            if let result = response?.firstResult() {
                result.coordinate
                let address = result.lines?.first ?? ""
                print("result=\(address)")
                self.address = address
                self.search_tf.text = address
            }
        }
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    @IBAction func textfield_tap(_ sender: UITextField) {
        print("::=hello")
        
        sender.resignFirstResponder()
        self.autocompleteClicked()
       // self.navigationController?.present(placesSearchController, animated: true, completion: nil)
    }
 
    @IBAction func re_center_btn(_ sender: UIButton) {
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func filter_btn(_ sender: Any) {
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterBottomSheetVC") as? FilterBottomSheetVC
        controller?.delegate = self
        bottomSheet(controller: controller!, sizes: [.fixed(550)],cornerRadius: 0, handleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
    }
    
    @IBAction func cal_btn(_ sender: UIButton) {
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScheduleVC")
        
        bottomSheet(controller: controller, sizes: [.fixed(360)],cornerRadius: 20, handleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
    }
    
    @IBAction func arrow_btn(_ sender: UIButton) {

        mapMoveToCurrentLoc(sender)
    }
    
    func mapMoveToCurrentLoc(_ sender: UIButton){
        
        sender.isHidden = true

        print(" view_all_btn=\(self.view_all_btn.frame)")
        get_all_parkings(lat: self.lat, long: self.longg, date_time: Helper().getCurrentDate(), isHeaderIncluded: Helper().IsUserLogin(), filters: [:]){
            
            sender.isHidden = false

            self.search_tf.text = self.address
          

        }
    }
    func mapMoveToCurrentLoc(){

        print("self.addressabc=\(self.address)")
        print(" view_all_btn=\(self.view_all_btn.frame)")
        self.add_marker(lat: self.lat, longg: self.longg)
        let camera = GMSCameraPosition.camera(withLatitude: self.lat, longitude: self.longg , zoom: 13.7)
        
        get_all_parkings(lat: self.lat, long: self.longg, date_time: Helper().getCurrentDate(), isHeaderIncluded: Helper().IsUserLogin(), filters: [:]){
            
            self.search_tf.text = self.address
            self.map.animate(to: camera)
          
        }
        
    }
    
    @IBAction func view_all_btn(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewAllVC") as! ViewAllVC
        vc.parkings = self.parkings
        vc.lat = self.lat
        vc.longg = self.longg
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parkings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeParkingCell", for: indexPath)as!homeParkingCell
        if(parkings.count>0){
            
            
            let dict = parkings[indexPath.row]
            print(dict)
            
            
            let seller = dict.seller
            let seller_details = seller?.details
          
            let lat = dict.latitude ?? ""
            let long = dict.longitude ?? ""
           
            
            let priceStr = dict.initialPrice ?? 0.0
            
//            let distanceStr = cal_distance(lat: lat, long: long)
            
            let imgUrl = dict.imageURL
            cell.image.sd_setImage(with: URL(string: imgUrl ?? ""),placeholderImage: UIImage.init(named: "placeholder-img") )
            
            cell.parking_title.text = dict.address
            cell.rating_view.rating = seller_details?.averageRating ?? 0.0
            
            cell.vehicle_type.text = dict.vehicleTypeText
            cell.parking_type.text = dict.parkingTypeText

            cell.price.text = "$\(priceStr)"
            
            
//            cell.distance.text = String(format: "%.02f miles away", distanceStr)
        
//            Helper().getTimeDurationBetweenCordinate(s_lat: self.lat, s_longg: self.longg, d_lat: Double(lat) ?? 0.0, d_longg: Double(long) ?? 0.0){ duration in
//
//                cell.time.text = duration
//            }
            
            if(dict.isNegotiable ?? false){
                cell.isNegotiable.text = "Yes"
            }
            else{
                cell.isNegotiable.text = "No"
            }
            
            //cell.barg_count.text = dict["vehicle_type_text"] as? String
        }
        
        return cell
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: myCollectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dict = self.parkings[indexPath.row]
       
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottomSheetVC") as! BottomSheetVC
        controller.parking_details = dict
        
        
        let lat = dict.latitude ?? ""
        let long = dict.longitude ?? ""
        let distanceStr = cal_distance(lat: lat, long: long)
        
        
        
        controller.distanceInMiles = String(format: "%.03f miles from destination", distanceStr)
        bottomSheet(controller: controller, sizes: [.fixed(500),.fullScreen],cornerRadius: 0, handleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in myCollectionView.visibleCells {
            let indexPath = myCollectionView.indexPath(for: cell)
            
            
            let dict = parkings[(indexPath?.row)!]
            
            let lat = Double(dict.latitude ?? "")
            let long = Double(dict.longitude ?? "")
            
            let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 15.0)
            self.map.animate(to: camera)
        }
    }
    
    func bottomSheet(controller : UIViewController,sizes:[SheetSize], cornerRadius:CGFloat, handleColor:UIColor){
        
        
      //  let controller = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier: identifier) as!  UIViewController
    
       
       
        let sheetController = SheetViewController(controller: controller, sizes: sizes)
//        // Turn off Handle
        sheetController.handleColor = handleColor
        // Turn off rounded corners
        sheetController.topCornersRadius = cornerRadius
        
        self.present(sheetController, animated: false, completion: nil)
    }
    
    func calculateWidth() -> CGFloat{
        
        let screenSize=UIScreen.main.bounds
        let screenWidth=screenSize.width
        let estimatedWidth = CGFloat(screenWidth)/1
        let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))
        
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
    
    func get_all_parkings(lat:Double,long:Double,date_time:String,isHeaderIncluded:Bool,filters:[String:String],completion: @escaping () -> Void){//(withToken:Bool,completion: @escaping (JSON) -> Void){
        
        
        parkings = []
        
        var params = [
            
            "latitude": String(lat),
            "longitude": String(long),
            "date_time" : date_time
            
        ]
        
        if(filters.keys.contains("vehicle_type")){
            params.updateValue(filters["vehicle_type"]!, forKey: "vehicle_type")
        }
        if(filters.keys.contains("parking_type")){
            params.updateValue(filters["parking_type"]!, forKey: "parking_type")
        }
        if(filters.keys.contains("orderBy_column")){
            params.updateValue(filters["orderBy_column"]!, forKey: "orderBy_column")
        }
        if(filters.keys.contains("time_margin")){
            params.updateValue(filters["time_margin"]!, forKey: "time_margin")
        }
        if(filters.keys.contains("date_time")){
            params.updateValue(filters["date_time"]!, forKey: "date_time")
        }
        
        
        print("token=\(UserDefaults.standard.string(forKey: "access_token"))")
        print("param123=\(params)")
        
//        var auth_value = ""
//
//        if let value : String = UserDefaults.standard.string(forKey: "auth_token"){
//
//            auth_value = "bearer " + value
//        }
//
        
        
        
        
//        let headers: HTTPHeaders = [
//            "Authorization" : auth_value
//        ]
        
        
        var url:URLRequestConvertible!
        
        if(Helper().IsUserLogin()){
//            url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.GET_PARKING_WITH_TOKEN
            url = APIRouter.getParkings(params)
            
        }
        else{
//            url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.GET_PARKING_WITHOUT_TOKEN
            
            url = APIRouter.getParkingsWithoutToken(params)
        }
        
        
        
//        Helper().Request_Api(url: url, methodType: .get, parameters: params, isHeaderIncluded: isHeaderIncluded, headers: headers){
//            response in
//            print("response=\(response)")
//            if response.result.value == nil {
//                print("No response")
//
//                SharedHelper().showToast(message: "Internal Server Error", controller: self)
//                completion()
//                return
//            }
//            else {
//
//                if let jsonData = response.data{
//
//                    let response = try! JSONDecoder().decode(ResponseData<[Parking]>.self, from: jsonData)
//                    if response.success{
//                        //                    UserDefaults.standard.set("isSocial", forKey: "yes")
//                        //                    UserDefaults.standard.synchronize()
//
//
//
//                        let message = response.message
//                        if let uData = response.data{
//
//                            Helper().map_circle(data: uData, map_view: self.map)
//                            Helper().map_custom_marker(data: uData, map_view: self.map)
//                            //Helper().map_circle(lat: place.coordinate.latitude, longg: place.coordinate.longitude,map_view: self.map)
//                            self.parkings = uData
//
//                        }
//
//                        print("parkings.count=\(self.parkings.count)")
//
//
//                        self.myCollectionView.reloadData()
//
//                        if(self.parkings.count > 0){
//
//                            UIView.animate(withDuration: 0.5, delay: 0.3, options: [],animations: {
//                                self.re_center_bottom_cont.constant = 40
//                            })
//
//                            self.myCollectionView.isHidden = false
//                            self.filter_btn.isHidden = false
//                            self.view_all_btn.isHidden = false
//
//
//                        }
//                        else{
//
//                            UIView.animate(withDuration: 0.5, delay: 0.3, options: [],animations: {
//                                self.re_center_bottom_cont.constant = -143
//                            })
//
//                            self.myCollectionView.isHidden = true
//                            self.filter_btn.isHidden = true
//                            self.view_all_btn.isHidden = true
//
//                            SharedHelper().showToast(message: "No Parkings Available", controller: self)
//
//
//                        }
//
//                        completion()
//
//
//
//                    }
//                    else{
//                        print("Eroor=\(response.message)")
//                        SharedHelper().showToast(message: response.message, controller: self)
//                        //   SharedHelper().hideSpinner(view: self.view)
//                        completion()
//                    }
//                }
//
//            }
//        }
        
        Helper().showSpinner(view: self.view)
        
        APIClient.serverRequest(url: url, dec: ResponseData<[Parking]>.self) { (response,error) in
            
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if let _ = response?.success {
                    
                    let message = response?.message
        
                    if let uData = response?.data{

                        Helper().map_circle(data: uData, map_view: self.map)
                        Helper().map_custom_marker(data: uData, map_view: self.map)
                        //Helper().map_circle(lat: place.coordinate.latitude, longg: place.coordinate.longitude,map_view: self.map)
                        self.parkings = uData

                    }

                    print("parkings.count=\(self.parkings.count)")


                    self.myCollectionView.reloadData()

                    if(self.parkings.count > 0){

                        
                        UIView.animate(withDuration: 0.5, delay: 0.3, options: [],animations: {
                            self.re_center_bottom_cont.constant = 40
                        })

                        self.myCollectionView.isHidden = false
                        self.filter_btn.isHidden = false
                        self.view_all_btn.isHidden = false
                        
//                        Helper().showToast(message: "\(message ?? "-")", controller: self)

                    }
                    else{

                        UIView.animate(withDuration: 0.5, delay: 0.3, options: [],animations: {
                            self.re_center_bottom_cont.constant = -143
                        })

                        self.myCollectionView.isHidden = true
                        self.filter_btn.isHidden = true
                        self.view_all_btn.isHidden = true

                        Helper().showToast(message: "No Parkings Available", controller: self)


                    }

                    completion()

                    
                }
                else{
                    
                    Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                    
                    
                }
            }
            else if(error != nil){
                
                Helper().showToast(message: "\(error?.localizedDescription ?? "" )", controller: self)
            }
            else{
                
                Helper().showToast(message: "Refresh Token Needed", controller: self)
//                Helper().showToast(message: "Nor Response and Error!!", controller: self)
            }
            
        }
        
    }
    
    

    
    func cal_distance(lat:String,long:String)  -> Double{
//
//        print("coordinate1==\(coordinate1)")
//        print("coordinate1==\(coordinate2)")
        
        let current_coordinate =  CLLocation(latitude: self.lat, longitude: self.longg)
        let lat = Double(lat)
        let long = Double(long)
        let coordinate2 = CLLocation(latitude: lat!, longitude: long!)

        let distanceInMiles = current_coordinate.distance(from: coordinate2)/1609.344 // result is in meters
        
        
        print("distanceInMiles=\(distanceInMiles)")
        
        return distanceInMiles
        
    }
    
    func cal_distance2() -> Double{
        
        
        let coordinate1 = CLLocation(latitude: 5.0, longitude: 5.0)
        let coordinate2 = CLLocation(latitude: 5.0, longitude: 3.0)
        
        let distanceInMeters = coordinate1.distance(from: coordinate2) // result is in meters
        
        print("distanceInMeters=\(distanceInMeters)")
        
        return distanceInMeters
        
    }
    
    func add_marker(lat:Double,longg:Double){
        let position = CLLocationCoordinate2D(latitude: lat, longitude: longg)
        let marker = GMSMarker(position: position)
        //        marker.title = "Hello World"
        marker.map = map
    }
    
   
 
}


extension FindParkingVC:FiltersProtocol{
    
    func applyFilters(filters: [String : String]) {
        print("filters2=\(filters)")
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        self.get_all_parkings(lat: self.filterLat, long: self.filterLong, date_time: Helper().getCurrentDate(), isHeaderIncluded: Helper().IsUserLogin(), filters: filters){
            
//           Helper().hideSpinner(view: self.view)
        }
       
    }
    
}

extension FindParkingVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("formattedAddress=\(place.formattedAddress ?? "") long=\(place.coordinate.longitude)")
        
        print("Place name: \(place.name ?? "No Name")")
        print("Place ID: \(place.placeID ?? "")")
//        print("Place attributions: \(place.attributions)")
        self.search_tf.text = place.name!
        self.autocomp = true
        
        dismiss(animated: true){
            self.myCollectionView.isHidden = false
            self.filter_btn.isHidden = false
            self.view_all_btn.isHidden = false
            self.map.clear()
            self.parkings.removeAll()
            self.myCollectionView.reloadData()
            
            let camera = GMSCameraPosition.camera(withLatitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude), zoom: 13.7)
            
            print("lat=\(place.coordinate.latitude) long=\(place.coordinate.longitude)")
            
            self.add_marker(lat: place.coordinate.latitude, longg: place.coordinate.longitude)
            
            self.filterLat = place.coordinate.latitude
            self.filterLong = place.coordinate.longitude
            
           
            self.get_all_parkings(lat: place.coordinate.latitude, long: place.coordinate.longitude, date_time: Helper().getCurrentDate(), isHeaderIncluded: Helper().IsUserLogin(),filters: [:]){
                
//                Helper().hideSpinner(view: self.view)
                self.map.animate(to: camera)
                self.autocomp = false

            }
            
  
            
            
        }
        
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}



struct ReversedGeoLocation {
    let name: String            // eg. Apple Inc.
    let streetName: String      // eg. Infinite Loop
    let streetNumber: String    // eg. 1
    let city: String            // eg. Cupertino
    let state: String           // eg. CA
    let zipCode: String         // eg. 95014
    let country: String         // eg. United States
    let isoCountryCode: String  // eg. US
    
    var formattedAddress: String {
        return "\(name) \(streetNumber),\(city), \(state) \(zipCode)\(country)"
    }
    var formattedAddressName: String {
        return "\(name)"
    }
    
    // Handle optionals as needed
    init(with placemark: CLPlacemark) {
        self.name           = placemark.name ?? ""
        self.streetName     = placemark.thoroughfare ?? ""
        self.streetNumber   = placemark.subThoroughfare ?? ""
        self.city           = placemark.locality ?? ""
        self.state          = placemark.administrativeArea ?? ""
        self.zipCode        = placemark.postalCode ?? ""
        self.country        = placemark.country ?? ""
        self.isoCountryCode = placemark.isoCountryCode ?? ""
    }
}
