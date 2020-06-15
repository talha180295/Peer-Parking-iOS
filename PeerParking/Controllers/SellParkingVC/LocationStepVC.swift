//
//  LocationStepVC.swift
//  PeerParking
//
//  Created by Apple on 16/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import GooglePlacesSearchController
import GoogleMaps
import GooglePlaces

class LocationStepVC: UIViewController,GMSMapViewDelegate {

    //IBOutlets
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var search_tf: UITextField!
    
    //variables
    var map = GMSMapView()
    var isMapLoaded = false
    var address = "abc"

    
    var parkings:[Parking] = []
    
    var locationManager = CLLocationManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var cameraView:GMSCameraPosition!
    
    let geocoder = GMSGeocoder()
    
    override func loadView() {
        super.loadView()
        
       
        self.address = self.appDelegate.currentLocationAddress ?? ""
        self.cameraView = self.appDelegate.camera
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
//        map.delegate = self
        
//        let camera = GMSCameraPosition.camera(withLatitude: self.lat,
//                                              longitude: self.longg,
//                                              zoom: 17)
//
//        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
//        mapView.delegate = self
//        let imageName = "pinmarker"
//        let image = UIImage(named: imageName)
//        let imageView = UIImageView(image: image!)
//        imageView.frame = CGRect(x: mapView.bounds.width/2 - 15, y: mapView.bounds.height/2 - 20, width: 30, height: 40)
//        mapView.addSubview(imageView)
//        mapView.isMyLocationEnabled = true
//        self.view = mapView
        
        
//        self.mapView.addSubview(mapView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
        
       
        if (!isMapLoaded){
            isMapLoaded = true
            loadMapView()
        }
        
       
    }
    
    func loadMapView(){
          
        print("::=loadMap")

        let camera = GMSCameraPosition.init()

        map = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        map.settings.scrollGestures = true
        map.settings.zoomGestures = true
        map.settings.myLocationButton = false
        map.delegate = self
        
        let imageName = "pinmarker"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: mapView.frame.width/2 - 20, y: mapView.frame.height/2 - 20, width: 40, height: 40)
        map.addSubview(imageView)
        // self.mapView = mapView
//        Helper().map_marker(lat: self.lat, longg: self.longg, map_view: self.map, title: "")
        self.mapView.addSubview(map)


        map.isMyLocationEnabled = false
        

        self.map.animate(to: cameraView)
        
        

    }
    
    @IBAction func textfield_tap(_ sender: UITextField) {
        print("::=hello")
        
        sender.resignFirstResponder()
        self.autocompleteClicked()
       // self.navigationController?.present(placesSearchController, animated: true, completion: nil)
    }

    func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
       
        
    }

    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        geocoder.reverseGeocodeCoordinate(cameraPosition.target) { (response, error) in
            guard error == nil else {
                return
            }
            
            if let result = response?.firstResult() {
                let coordinates = result.coordinate
                let address = result.lines?.first ?? ""
                print("result=\(address)")
                print("result=\(coordinates)")
                self.search_tf.text = address
                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(address, forKey: "address")
                
                GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(address, forKey: "address")
                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(coordinates.latitude, forKey: "latitude")
                GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(coordinates.longitude, forKey: "longitude")
                
                GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(coordinates.latitude, forKey: "latitude")
                GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(coordinates.longitude, forKey: "longitude")
            }
        }
      
    }
 
}


extension LocationStepVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("formattedAddress=\(place.formattedAddress ?? "") long=\(place.coordinate.longitude)")
        
        print("Place name: \(place.name ?? "No Name")")
        print("Place ID: \(place.placeID ?? "")")
//        print("Place attributions: \(place.attributions)")
        self.search_tf.text = place.name!
        dismiss(animated: true){
            
            let camera = GMSCameraPosition.camera(withLatitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude), zoom: 17)
           
            self.map.clear()
//            Helper().map_marker(lat: place.coordinate.latitude, longg: place.coordinate.longitude, map_view: self.map, title: "")

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

extension LocationStepVC:CLLocationManagerDelegate{
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        
     
        
        GLOBAL_VAR.PARKING_POST_DETAILS.updateValue((location?.coordinate.latitude.description)!, forKey: "latitude")
        GLOBAL_VAR.PARKING_POST_DETAILS.updateValue((location?.coordinate.longitude.description)!, forKey: "longitude")
        
        GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue((location?.coordinate.latitude.description)!, forKey: "latitude")
        GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue((location?.coordinate.longitude.description)!, forKey: "longitude")
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 14.0)
        
        self.map.animate(to: camera)
        
        self.geocoder.reverseGeocodeCoordinate(camera.target) { (response, error) in
          guard error == nil else {
            return
          }

          if let result = response?.firstResult() {
            result.coordinate
            let address = result.lines?.first ?? ""
            print("result=\(address)")
            self.search_tf.text = address
            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(address, forKey: "address")
            
            GLOBAL_VAR.PRIVATE_PARKING_MODEL.updateValue(address, forKey: "address")
          }
        }

        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
}
