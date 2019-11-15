//
//  FindParkingVC.swift
//  PeerParking
//
//  Created by Apple on 14/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GooglePlacesSearchController
import GoogleMaps
import GooglePlaces
import FittedSheets
import HelperClassPod
import SwiftyJSON
import Alamofire


class FindParkingVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
   
    
    //IBOutlets
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var parkings_cells: UIView!
    @IBOutlet weak var search_tf: UITextField!
    
    //Variables
    var estimateWidth=130
    var cellMarginSize=1
    var address = ""
    
    var lat = 0.0
    var longg = 0.0
    
    var parkings:[Any] = []
    
    var locationManager = CLLocationManager()
    var map = GMSMapView()
    
    let GoogleMapsAPIServerKey = Key.Google.placesKey
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Register
        self.myCollectionView.register(UINib(nibName: "homeParkingCell", bundle: nil), forCellWithReuseIdentifier: "homeParkingCell")
        
        
        
        
        parkings_cells.isHidden = true
        
        loadMapView()
        
       
       // search_tf.setLeftPaddingPoints(30)
        
        
        //Setup GridView
        //self.setupGridView()
        
        //get all parking without token
//        get_all_parkings(withToken: false){
//            json in
//
//            self.parkings = [json]
////
////            self.parkings
//            print("JSON=\(json[0]["image_url"].stringValue)")
//            print("JSONCount=\(json.count)")
//            print("JSONtype=\(type(of: json))")
//
//            self.myCollectionView.reloadData()
//        }
//

    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        tab_index = 0
        print("::=willapear")
        
        self.tabBarController!.navigationItem.title = "Find Parking"
        
        
    }
    
    func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
//        // Specify the place data types to return.
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
//            UInt(GMSPlaceField.placeID.rawValue))!
//        autocompleteController.placeFields = fields
//
//        // Specify a filter.
//        let filter = GMSAutocompleteFilter()
//        filter.type = .address
//        autocompleteController.autocompleteFilter = filter
        
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
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        self.lat = (location?.coordinate.latitude)!
        self.longg = (location?.coordinate.longitude)!
//        print("lat==\(location?.coordinate.latitude)")
//        print("long==\(location?.coordinate.longitude)")
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 14.0)
        
        self.map.animate(to: camera)
        
        //location.
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location!, completionHandler:
            {
                placemarks, error in
                
                guard let placemark = placemarks?.first else {
                    let errorString = error?.localizedDescription ?? "Unexpected Error"
                    print("Unable to reverse geocode the given location. Error: \(errorString)")
                    return
                }
                
                let reversedGeoLocation = ReversedGeoLocation(with: placemark)
                print("LOC=:\(reversedGeoLocation.formattedAddress)")
                self.address = reversedGeoLocation.formattedAddressName
                // Apple Inc.,
                // 1 Infinite Loop,
                // Cupertino, CA 95014
                // United States
        })
        
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
        
        
        bottomSheet(storyBoard: "Main",identifier: "FilterBottomSheetVC",sizes: [.fixed(550)],cornerRadius: 0, handleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
    }
    
    @IBAction func cal_btn(_ sender: UIButton) {
        
        
         bottomSheet(storyBoard: "Main",identifier: "ScheduleVC",sizes: [.fixed(360)],cornerRadius: 20, handleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
        
    }
    
    @IBAction func arrow_btn(_ sender: UIButton) {
        get_all_parkings()
        print("self.address=\(self.address)")
        self.search_tf.text = self.address
        self.parkings_cells.isHidden = false
        
    }
    
    @IBAction func view_all_btn(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewAllVCNav")
        present(vc!, animated: true, completion: nil)
        //bottomSheet(storyBoard: "Main",identifier: "ViewAllVC",sizes: [.fullScreen],cornerRadius: 0, handleColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parkings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeParkingCell", for: indexPath)as!homeParkingCell
        if(parkings.count>0){
            let dict = parkings[indexPath.row] as! NSDictionary
            print(dict)
            if(dict["address"] is NSNull)
            {
                
            }
            else
            {
            cell.parking_title.text = (dict["address"] as! String)
            }
        //cell.setData(empReqObj: arrModel[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWidth()
        print("width=\(myCollectionView.frame.width)")
        return CGSize(width: myCollectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //let controller = BottomSheetVC()
//        let controller = SheetViewController(controller: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottomSheetVC"), sizes: [.fixed(450), .fixed(300), .fixed(600), .fullScreen])
        
        bottomSheet(storyBoard: "Main",identifier: "BottomSheetVC", sizes: [.fixed(500),.fullScreen],cornerRadius: 0, handleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in myCollectionView.visibleCells {
            let indexPath = myCollectionView.indexPath(for: cell)
            print("indexPath=\(indexPath?.row)")
            
            
            let dict = parkings[(indexPath?.row)!] as! NSDictionary
            
            let lat = Double(dict["latitude"] as! String)
            let long = Double(dict["longitude"] as! String)
            
            let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 15.0)
            self.map.animate(to: camera)
        }
    }
    
    func bottomSheet(storyBoard:String,identifier:String,sizes:[SheetSize], cornerRadius:CGFloat, handleColor:UIColor){
        
        let controller = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        
       
       
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
    
    
    
    func get_all_parkings(){//(withToken:Bool,completion: @escaping (JSON) -> Void){
        
//        var params:[String:Any]!
//
//
//
//
//        if(withToken){
//
////             Helper().alamofireApiWithParams(url: url, method: .get, parameters: params, headers: <#T##HTTPHeaders#>, completion: <#T##(JSON) -> Void#>)
//
//        }
//        else{
//
//            let headers: HTTPHeaders = [
//                "Authorization" : ""
//            ]
//            params = [:]
//
//            let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.GET_PARKING_WITHOUT_TOKEN
//            print("withoutToken_url=\(url)")
//
//            Helper().alamofireApiWithParams(url: url, method: .get, withHeader: withToken,parameters: params, headers: headers) {
//                json in
//
//                if(json["success"].boolValue){
//
//                    completion(json["data"])
//                    let msg = json["message"].stringValue
//                    SharedHelper().showToast(message: msg, controller: self)
//                }
//                else{
//
//                    let msg = json["message"].stringValue
//                    SharedHelper().showToast(message: msg, controller: self)
//                }
//
//
//
//            }
//        }

        
        //var params:[String:Any]!
        let params = [
           
            "latitude": String(self.lat),
            "longitude": String(self.longg)
        
        ]
     //   print(param)
        let headers: HTTPHeaders = [
            "Authorization" : ""
        ]
        let url = APP_CONSTANT.API.STAGING_BASE_URL + APP_CONSTANT.API.GET_PARKING_WITHOUT_TOKEN
        print("staging_url=\(url)")
        SharedHelper().Request_Api(url: url, methodType: .get, parameters: params, isHeaderIncluded: false, headers: headers){
            response in
            print("response=\(response)")
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
                    //                    UserDefaults.standard.set("isSocial", forKey: "yes")
                    //                    UserDefaults.standard.synchronize()
                    
                    
                    
                    let message = responseData["message"] as! String
                    let uData = responseData["data"] as! [Any]
                   
                    Helper().map_circle(data: uData, map_view: self.map)
                    //Helper().map_circle(lat: place.coordinate.latitude, longg: place.coordinate.longitude,map_view: self.map)
                    self.parkings = uData
                    print("parkings.count=\(self.parkings.count)")
                    self.myCollectionView.reloadData()
                    SharedHelper().showToast(message: message, controller: self)
                    self.myCollectionView.isHidden = false
                    
                   
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
    
    
    
 
}


//extension FindParkingVC: GooglePlacesAutocompleteViewControllerDelegate {
//    func viewController(didAutocompleteWith place: PlaceDetails) {
//        print("::=place.description=\(place.description)")
//        placesSearchController.isActive = false
//
//        let camera = GMSCameraPosition.camera(withLatitude: (place.coordinate?.latitude)!, longitude: (place.coordinate?.longitude)!, zoom: 17.0)
//
//        self.map.animate(to: camera)
//    }
//
//}


extension FindParkingVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("formattedAddress=\(place.formattedAddress) long=\(place.coordinate.longitude)")
        
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
        self.search_tf.text = place.name!
        dismiss(animated: true){
            self.parkings_cells.isHidden = false
            
            let camera = GMSCameraPosition.camera(withLatitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude), zoom: 13.0)
            
            print("lat=\(place.coordinate.latitude) long=\(place.coordinate.longitude)")
            
            
            
//            Helper().map_circle(lat: place.coordinate.latitude, longg: place.coordinate.longitude,map_view: self.map)
            //Helper().map_marker(lat: place.coordinate.latitude, longg: place.coordinate.longitude,map_view: self.map)
            self.map.animate(to: camera)
            
            
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
