//
//  Helper.swift
//  PeerParking
//
//  Created by Apple on 07/11/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import Foundation
import FittedSheets
import GoogleMaps
import SwiftyJSON
import Alamofire

class Helper{
    
    func bottomSheet(storyBoard:String,identifier:String,sizes:[SheetSize], cornerRadius:CGFloat, handleColor:UIColor,view_controller:UIViewController){
        
        let controller = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        
        
        
        let sheetController = SheetViewController(controller: controller, sizes: sizes)
        //        // Turn off Handle
        sheetController.handleColor = handleColor
        // Turn off rounded corners
        sheetController.topCornersRadius = cornerRadius
        
        view_controller.present(sheetController, animated: false, completion: nil)
    }
    
    
    func IsUserLogin() -> Bool {
        if ((UserDefaults.standard.object(forKey: "login")) == nil) {
            return false
        }
        else
        {
            let isLogin = UserDefaults.standard.string(forKey: "login")!
            if(isLogin.elementsEqual("yes"))
            {
                return true
            }
            else
            {
                return false
            }
        }
    }
    
    func map_circle(data:[Any], map_view:GMSMapView){
        
        
        for n in 0..<data.count {
            
            let dict = data[n] as! NSDictionary
            
            
            
            let lat = Double(dict["latitude"] as! String)
            let long = Double(dict["longitude"] as! String)
            print("dictABC=\(lat!)")
            print("dictABC=\(long!)")
            //        print("dictABC=\(type(of: lat) )")
            
            
            
            let position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            
            //        let position = CLLocationCoordinate2D(latitude: 24.9280107, longitude: 67.0957389)
            
            let circle = GMSCircle()
            circle.radius = 500 // Meters
            circle.fillColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 0.7752568493)
            circle.position = position // Your CLLocationCoordinate2D  position
            circle.strokeWidth = 5;
            circle.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            circle.title = "$15"
            circle.map = map_view; // Add it to the map
        }
    }
    
    func map_marker(lat:Double,longg:Double, map_view:GMSMapView){
        
//        // I have taken a pin image which is a custom image
//        let markerImage = UIImage(named: "radius_blue")!.withRenderingMode(.alwaysOriginal)
//
//        //creating a marker view
//        let markerView = UIImageView(image: markerImage)
//
//        //        //changing the tint color of the image
//        //        markerView.tintColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 0.4467572774)
//
//
//        let position = CLLocationCoordinate2D(latitude: lat, longitude: longg)
//        let marker = GMSMarker(position: position)
//        marker.title = "marker"
//        marker.iconView = markerView
//        marker.map = map_view
        
        
        let marker = GMSMarker()
        
        // I have taken a pin image which is a custom image
        let markerImage = UIImage(named: "icon_pinGrey")!.withRenderingMode(.alwaysTemplate)
        
        //creating a marker view
        let markerView = UIImageView(image: markerImage)
        
        //changing the tint color of the image
        markerView.tintColor = #colorLiteral(red: 0.2591760755, green: 0.6798272133, blue: 0.8513383865, alpha: 1)
        
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: longg)
        
        marker.iconView = markerView
        marker.title = "10$"
        //marker.snippet = "price"
        marker.map = map_view
        
        
        //comment this line if you don't wish to put a callout bubble
        map_view.selectedMarker = marker
        
        
    }
    
    
    func alamofireApiWithParams(url:String,method:HTTPMethod,withHeader:Bool,parameters: [String : Any],headers:HTTPHeaders,completion: @escaping (JSON) -> Void){
        
        var json:JSON!
        var error:JSON = ["error" : "server down"]
        
        
        
        if(withHeader){
            
            Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers:headers).validate(contentType: ["application/json","text/html"])
                .responseJSON { response in
                    
                    
//                    switch response.result {
//                    case .success:
//                        print(response)
//                        completion(response)
//                        break
//                    case .failure(let error):
//                        print(error)
//                        completion(response)
//                    }
                    
                    
                    if response.data != nil {
                        
                        do{
                            json = try JSON(data: response.data!)
                            completion(json!)
                        }catch{
                            
                            print("error in frontend")
                            
                        }
                        
                        
                    }
                    else{
                        error = ["errorelse" : "server down"]
                        completion(error)
                        
                    }
                    
            }
        }
        else{
            
            Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding(destination: .queryString)).validate(contentType: ["application/json","text/html"])
                .responseJSON { response in
                    
                    if response.data != nil {
                        
                        do{
                            json = try JSON(data: response.data!)
                            completion(json!)
                        }catch{
                            
                            print("error in frontend")
                        }
                        
                        
                    }
                    else{
                        error = ["errorelse" : "server down"]
                        completion(error)
                        
                    }
                    
            }
        }
        
        
    }
    
}
