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
import FittedSheets

class FindParkingVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    
    //IBOutlets
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    //Variables
    var estimateWidth=130
    var cellMarginSize=1
    
    let GoogleMapsAPIServerKey = Key.Google.placesKey
    lazy var placesSearchController: GooglePlacesSearchController = {
        let controller = GooglePlacesSearchController(delegate: self,
                                                      apiKey: GoogleMapsAPIServerKey,
                                                      placeType: .address,
                                                      strictBounds: true
            // Optional: coordinate: CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423),
            // Optional: radius: 10,
            // Optional: strictBounds: true,
            // Optional: searchBarPlaceholder: "Start typing..."
        )
        //Optional: controller.searchBar.isTranslucent = false
        //Optional: controller.searchBar.barStyle = .black
        //Optional: controller.searchBar.tintColor = .white
        //Optional: controller.searchBar.barTintColor = .black
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Register
        self.myCollectionView.register(UINib(nibName: "homeParkingCell", bundle: nil), forCellWithReuseIdentifier: "homeParkingCell")
        
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
    
    
    func loadMapView(){
        
        print("::=loadMap")
        let camera = GMSCameraPosition.camera(withLatitude: 1.285,
                                              longitude: 103.848,
                                              zoom: 12)
        
        let mapView = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.myLocationButton = false
       // self.mapView = mapView
        self.mapView.addSubview(mapView)
    }
    

    @IBAction func textfield_tap(_ sender: Any) {
        print("::=hello")
        self.navigationController?.present(placesSearchController, animated: true, completion: nil)
    }
    @IBAction func calender_btn(_ sender: Any) {
      
        
    }
    
    @IBAction func filter_btn(_ sender: Any) {
        
        
        bottomSheet(storyBoard: "Main",identifier: "FilterBottomSheetVC",sizes: [.fixed(500)])
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
        
        bottomSheet(storyBoard: "Main",identifier: "BottomSheetVC", sizes: [.fixed(500),.fullScreen])
    }
    
    func bottomSheet(storyBoard:String,identifier:String,sizes:[SheetSize]){
        
        let controller = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        
       
       
        let sheetController = SheetViewController(controller: controller, sizes: sizes)
//        // Turn off Handle
        sheetController.handleColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        // Turn off rounded corners
        sheetController.topCornersRadius = 0
        
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


extension FindParkingVC: GooglePlacesAutocompleteViewControllerDelegate {
    func viewController(didAutocompleteWith place: PlaceDetails) {
        print("::=place.description=\(place.description)")
        placesSearchController.isActive = false
    }
    
}

