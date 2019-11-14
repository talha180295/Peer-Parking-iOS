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
        
        print("lat==\(location?.coordinate.latitude)")
        print("long==\(location?.coordinate.longitude)")
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 12.0)
        
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
                self.address = reversedGeoLocation.formattedAddress
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeParkingCell", for: indexPath)as!homeParkingCell
        
        //cell.setData(empReqObj: arrModel[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWidth()
        print("width=\(width-100)")
        return CGSize(width: width-100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //let controller = BottomSheetVC()
//        let controller = SheetViewController(controller: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottomSheetVC"), sizes: [.fixed(450), .fixed(300), .fixed(600), .fullScreen])
        
        bottomSheet(storyBoard: "Main",identifier: "BottomSheetVC", sizes: [.fixed(500),.fullScreen],cornerRadius: 0, handleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
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
    
    func map_marker(lat:Double,longg:Double){
        
        // I have taken a pin image which is a custom image
        let markerImage = UIImage(named: "radius_blue")!.withRenderingMode(.alwaysOriginal)
        
        //creating a marker view
        let markerView = UIImageView(image: markerImage)
        
//        //changing the tint color of the image
//        markerView.tintColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 0.4467572774)
        
        
        let position = CLLocationCoordinate2D(latitude: lat, longitude: longg)
        let marker = GMSMarker(position: position)
        marker.title = "marker"
        marker.iconView = markerView
        marker.map = map
        
        
    }
    
    func map_circle(lat:Double,longg:Double){
        
        let position = CLLocationCoordinate2D(latitude: lat, longitude: longg)
        
        let circle = GMSCircle()
        circle.radius = 130 // Meters
        circle.fillColor = #colorLiteral(red: 0.2591760755, green: 0.6798272133, blue: 0.8513383865, alpha: 1)
        circle.position = position // Your CLLocationCoordinate2D  position
        circle.strokeWidth = 5;
        circle.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        circle.map = map; // Add it to the map
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
            
            let camera = GMSCameraPosition.camera(withLatitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude), zoom: 17.0)
            
            print("lat=\(place.coordinate.latitude) long=\(place.coordinate.longitude)")
            
            
            self.map_circle(lat: place.coordinate.latitude, longg: place.coordinate.longitude)
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
        return """
        \(name),
        \(streetNumber) \(streetName),
        \(city), \(state) \(zipCode)
        \(country)
        """
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
