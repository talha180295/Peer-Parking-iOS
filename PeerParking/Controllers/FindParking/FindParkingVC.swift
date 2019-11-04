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
    
    var locationManager = CLLocationManager()
    var map = GMSMapView()
    
    let GoogleMapsAPIServerKey = Key.Google.placesKey
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Register
        self.myCollectionView.register(UINib(nibName: "homeParkingCell", bundle: nil), forCellWithReuseIdentifier: "homeParkingCell")
        
        
        tab_index = 0
        
        parkings_cells.isHidden = true
        
        
        search_tf.setLeftPaddingPoints(30)
        
        
        //Setup GridView
        //self.setupGridView()
        

    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        print("::=willapear")
        loadMapView()
        self.tabBarController!.navigationItem.title = "Find Parking"
//
//        self.tabBarController?.tabBar.isHidden = false
//        self.navigationController?.navigationBar.isHidden = false
    }
    
    func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func loadMapView(){
        
        print("::=loadMap")
        let camera = GMSCameraPosition.camera(withLatitude: 1.285,
                                              longitude: 103.848,
                                              zoom: 12)
        
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
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 12.0)
        
        self.map.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }

    @IBAction func textfield_tap(_ sender: Any) {
        print("::=hello")
        
        self.autocompleteClicked()
       // self.navigationController?.present(placesSearchController, animated: true, completion: nil)
    }
 
    @IBAction func re_center_btn(_ sender: UIButton) {
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func filter_btn(_ sender: Any) {
        
        
        bottomSheet(storyBoard: "Main",identifier: "FilterBottomSheetVC",sizes: [.fixed(500)],cornerRadius: 0)
    }
    
    @IBAction func cal_btn(_ sender: UIButton) {
        
        
         bottomSheet(storyBoard: "Main",identifier: "ScheduleVC",sizes: [.fixed(360)],cornerRadius: 20)
        
    }
    
    @IBAction func arrow_btn(_ sender: UIButton) {
        
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
        
        bottomSheet(storyBoard: "Main",identifier: "BottomSheetVC", sizes: [.fixed(500),.fullScreen],cornerRadius: 0)
    }
    
    func bottomSheet(storyBoard:String,identifier:String,sizes:[SheetSize], cornerRadius:CGFloat){
        
        let controller = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        
       
       
        let sheetController = SheetViewController(controller: controller, sizes: sizes)
//        // Turn off Handle
        sheetController.handleColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
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
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
        self.search_tf.text = place.name!
        dismiss(animated: true){
            self.parkings_cells.isHidden = false
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
