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
import EzPopup
import UIKit
import SystemConfiguration
import Alamofire
import iProgressHUD
import Firebase


class Helper{
    
    let iprogress: iProgressHUD = iProgressHUD()
    
    func getFormatedDate(dateStr:String) -> String{
        
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = APP_CONSTANT.DATE_TIME_FORMAT
        
        let formateDate = dateFormatter.date(from:dateStr)!
        dateFormatter.dateFormat = "dd/MM/yyyy" // Output Formated
        
        //        let date: Date? = dateFormatter.date(from: dateStr)
        
        return dateFormatter.string(from: formateDate)
        
        
    }
    
    func getFormatedServerDateTime(dateStr:String) -> String{
        
        
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM/dd/yyyy h:mm a"
        
        
        
        
        
        let dateFormatterPrint = DateFormatter()
        
        dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatterPrint.timeZone = NSTimeZone(name: "UTC") as TimeZone?
//               dateFormatterPrint.calendar = Calendar(identifier: .iso8601)
//               dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
//               dateFormatterPrint.timeZone = TimeZone(secondsFromGMT: 0)
//        dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date =  dateFormatterGet.date(from: dateStr)!
        
        return dateFormatterPrint.string(from: date)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = APP_CONSTANT.DATE_TIME_FORMAT
//
//        let formateDate = dateFormatter.date(from:dateStr)!
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Output Formated
//
//        //        let date: Date? = dateFormatter.date(from: dateStr)
//
//        return dateFormatter.string(from: formateDate)
    }
    func getFormatedServerTime(dateStr:String) -> String{
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = APP_CONSTANT.DATE_TIME_FORMAT
        
        let formateDate = dateFormatter.date(from:dateStr)!
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "HH:mm:ss" // Output Formated
        
        //        let date: Date? = dateFormatter.date(from: dateStr)
        
        return dateFormatter.string(from: formateDate)
    }
    
    
    func getFormatedDateAndTime(dateStr:String) -> String{
        
        
       
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = APP_CONSTANT.DATE_TIME_FORMAT
            
            let formateDate = dateFormatter.date(from:dateStr) ?? Date()
            dateFormatter.dateFormat = "MM/dd/yyyy h:mm a" // Output Formated
            
            //        let date: Date? = dateFormatter.date(from: dateStr)
            
            return dateFormatter.string(from: formateDate)
        
        
        
        
        
    }
    
    func getFormatedDateAndTimeList(dateStr:String)-> String{
        
        if(dateStr == "")
        {
            return dateStr
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = APP_CONSTANT.DATE_TIME_FORMAT
            
            
            if(dateFormatter.date(from:dateStr) != nil)
            {
                let formateDate = dateFormatter.date(from:dateStr) ?? Date()
                dateFormatter.dateFormat = "MM/dd/yyyy h:mm a" // Output Formated
                
                //        let date: Date? = dateFormatter.date(from: dateStr)
                
                return dateFormatter.string(from: formateDate)
            }
            else
            {
                return dateStr
            }
            
            
        }
        
    }
    
    
    
    
    
    func bottomSheet(controller : UIViewController,sizes:[SheetSize], cornerRadius:CGFloat, handleColor:UIColor,view_controller:UIViewController){
        
        
        //  let controller = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier: identifier) as!  UIViewController
        
        
        
        let sheetController = SheetViewController(controller: controller, sizes: sizes)
        //        // Turn off Handle
        sheetController.handleColor = handleColor
        // Turn off rounded corners
        sheetController.topCornersRadius = cornerRadius
        
        view_controller.present(sheetController, animated: false, completion: nil)
    }
    
    public static func getStatusText(status:Int) -> String{
        switch (status){
        case APP_CONSTANT.STATUS_PARKING_BOOKED:
            return "In Progress";
        case APP_CONSTANT.STATUS_PARKING_AVAILABLE:
            return "Available";
        case APP_CONSTANT.STATUS_PARKING_CANCEL:
            return "Cancel";
        case APP_CONSTANT.STATUS_PARKING_UNAVAILABLE:
            return "Unavaiable";
        case APP_CONSTANT.STATUS_PARKING_NAVIGATING:
            return "Navigating";
        case  APP_CONSTANT.STATUS_PARKING_PARKED:
            return "Completed";
        default:
            return ""
        }
    }
    
    public static func deleteChatAndRequests(parkingModel1 : Parking) {
        
        var parkingChatReference =  Database.database().reference(withPath: "chat/").child(String(parkingModel1.id!)).child(String(parkingModel1.buyerID!))
        
        
        var parkingRequestsReference =  Database.database().reference(withPath: "requests/").child(String(parkingModel1.id!)).child("\(parkingModel1.id) - \(parkingModel1.buyerID)")
        
        var sellerRequestIndexReference = Database.database().reference(withPath: "sellerRequestsIndex/")
        var buyerRequestIndexReference = Database.database().reference(withPath: "buyerRequestsIndex/")
        
         var refId = String(parkingModel1.id!) + "-" + String(parkingModel1.buyerID!)
        
        
        buyerRequestIndexReference.child(String(parkingModel1.buyerID!)).child(refId).removeValue()
        sellerRequestIndexReference.child(String(parkingModel1.sellerID!)).child(refId).removeValue()
        
        
        parkingRequestsReference.removeValue()
        parkingChatReference.removeValue()
//        DatabaseReference parkingChatReference = FirebaseDatabase.getInstance().getReference("chat/")
//                .child(String.valueOf(parkingModel1.getId())).child(String.valueOf(parkingModel1.getBuyerId()));
//        DatabaseReference parkingRequestsReference = FirebaseDatabase.getInstance().getReference("requests/")
//                .child(parkingModel1.getId() + "-"+parkingModel1.getBuyerId());
//        DatabaseReference sellerRequestsIndexReference = FirebaseDatabase.getInstance().getReference("sellerRequestsIndex/");
//        DatabaseReference buyerRequestsIndexReference = FirebaseDatabase.getInstance().getReference("buyerRequestsIndex/");
//        String refId = parkingModel1.getId()+"-"+parkingModel1.getBuyerId();
//        buyerRequestsIndexReference.child(String.valueOf(parkingModel1.getBuyerId())).child(refId).removeValue();
//        sellerRequestsIndexReference.child(String.valueOf(parkingModel1.getSellerId())).child(refId).removeValue();
//        parkingRequestsReference.removeValue();
//        parkingChatReference.removeValue();

    }

    
    public static func removeRequestsOfAllOtherBuyers(parkingModel1 : Parking , buyersList : [String]){
        
        buyersList.forEach { (buyerId) in
            
            
            if(String(parkingModel1.buyerID!) != buyerId ){
                
                Database.database().reference(withPath: "requests/").child(String(parkingModel1.id!) + "-" + String(buyerId)).removeValue()
            }
            
        }
        
    }
    
    func getCurrentUserId() -> Int{
        
        let myId = UserDefaults.standard.integer(forKey: "id")
        return myId
    }
    
    func getUserWallet() -> Double{
        
        let wallet = UserDefaults.standard.double(forKey: "wallet")
        return wallet
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
    
    func map_circle(data:[Parking], map_view:GMSMapView){
        
        
        for n in 0..<data.count {
            
            let dict = data[n] 
            
            let lat = Double(dict.latitude ?? "")
            let long = Double(dict.longitude  ?? "")
            print("dictABC=\(lat!)")
            print("dictABC=\(long!)")
            //        print("dictABC=\(type(of: lat) )")
            
            
            
            let position = CLLocationCoordinate2D(latitude: lat!-0.001, longitude: long!-0.001)
            
            //        let position = CLLocationCoordinate2D(latitude: 24.9280107, longitude: 67.0957389)
            
            let circle = GMSCircle()
            circle.radius = 500 // Meters
            circle.fillColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 0.7752568493)
            circle.position = position // Your CLLocationCoordinate2D  position
            circle.strokeWidth = 0.5;
            circle.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            //            circle.title = "$15"
            circle.map = map_view; // Add it to the map
            
            
            
        }
    }
    
    func getCurrentDate() -> String{
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = APP_CONSTANT.DATE_TIME_FORMAT
        let result = formatter.string(from: date)
        
        return result
        
    }
    
    func map_marker(lat:Double,longg:Double, map_view:GMSMapView, title:String){
        
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
        let markerImage = UIImage(named: "s_marker")!.withRenderingMode(.alwaysTemplate)
        
        //creating a marker view
        let markerView = UIImageView(image: markerImage)
        
        //changing the tint color of the image
        markerView.tintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: longg)
        
        marker.iconView = markerView
        marker.title = title
        //marker.snippet = "price"
        marker.map = map_view
        
        
        //comment this line if you don't wish to put a callout bubble
        //        map_view.selectedMarker = marker
        
        
    }
    
    func map_custom_marker(data:[Parking], map_view:GMSMapView){
        
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
        
        for n in 0..<data.count {
            
            
            let dict = data[n] //as! NSDictionary
            
            let price = dict.initialPrice ?? 0.0
            let lat = Double(dict.latitude ?? "")
            let long = Double(dict.longitude  ?? "")
            print("dictABC=\(lat!)")
            print("dictABC=\(long!)")
            let marker = GMSMarker()
            
            // I have taken a pin image which is a custom image
            
            
            let markerImage =  drawText(text: "$\(price)" as NSString, inImage: UIImage(named: "price_marker")!.withRenderingMode(.alwaysOriginal))
            
            //creating a marker view
            let markerView = UIImageView(image: markerImage)
            
            //changing the tint color of the image
            //            markerView.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            
            let pos = CLLocationCoordinate2D(latitude: lat!-0.001, longitude: long!-0.001)
            
            
            //            let loc = CLLocationCoordinate2D(latitude: lat!, longitude: longg!)
            //            let newLoc = loc.locationWithBearing(bearing: 90.degreesToRadians, distanceMeters: 500.0, lat: lat!,longg: longg!)
            
            
            let newLoc = pos.shift(byDistance: 500, azimuth: 0) // 100m to North
            
            marker.position = newLoc
            
            marker.iconView = markerView
            //            marker.title = "10$"
            //marker.snippet = "price"
            marker.map = map_view
            
            
            //comment this line if you don't wish to put a callout bubble
            //            map_view.selectedMarker = marker
        }
        
        
    }
    
    func drawText(text:NSString, inImage:UIImage) -> UIImage? {
        
        let font = UIFont.systemFont(ofSize: 11)
        let size = inImage.size
        
        //UIGraphicsBeginImageContext(size)
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        inImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let style : NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        style.alignment = .center
        let attributes:NSDictionary = [ NSAttributedString.Key.font : font, NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.foregroundColor : UIColor.white ]
        
        let textSize = text.size(withAttributes: attributes as? [NSAttributedString.Key : Any])
        let rect = CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height)
        let textRect = CGRect(x: (rect.size.width - textSize.width)/2, y: (rect.size.height - textSize.height)/2 - 2, width: textSize.width, height: textSize.height)
        text.draw(in: textRect.integral, withAttributes: attributes as? [NSAttributedString.Key : Any])
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resultImage
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
    
    /*! @discussion this method is use to check internet availability
     *  @return Bool
     */
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    /** @brief this is a generic method use to validate email
     * @param enteredEmail:String
     * @return Bool
     **/
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    func popUp(controller : UIViewController,view_controller:UIViewController , popupWidth: CGFloat = 320, popupHeight : CGFloat = 365){
        
        
        
        let popupVC = PopupViewController(contentController: controller, popupWidth: popupWidth, popupHeight: popupHeight)
        popupVC.canTapOutsideToDismiss = true
        
        //properties
        //            popupVC.backgroundAlpha = 1
        //            popupVC.backgroundColor = .black
        //            popupVC.canTapOutsideToDismiss = true
        //            popupVC.cornerRadius = 10
        //            popupVC.shadowEnabled = true
        
        // show it by call present(_ , animated:) method from a current UIViewController
        view_controller.present(popupVC, animated: true)
    }
    
    func RefreshToken(completion: @escaping (_ result: DataResponse<Any>) -> Void) {
        
        var auth_value : String = UserDefaults.standard.string(forKey: APP_CONSTANT.ACCESSTOKEN)!
        auth_value = "bearer " + auth_value
        
        
        let headers: HTTPHeaders = [
            "Authorization" : auth_value
        ]
        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.REFRESH_TOKEN
        Alamofire.request(url, method: .post, parameters: nil, headers:headers).validate(contentType: ["application/json","text/html"]).responseJSON
            { response in
                
                switch response.result {
                case .success:
                    print(response)
                    let responseData = response.result.value as! NSDictionary
                    let status = responseData["success"] as! Bool
                    if(status)
                    {
                        let uData = responseData["data"] as! NSDictionary
                        let userData = uData["user"] as! NSDictionary
                        
                        let auth_token = userData[APP_CONSTANT.ACCESSTOKEN] as! String
                        UserDefaults.standard.set(auth_token, forKey: APP_CONSTANT.ACCESSTOKEN)
                        UserDefaults.standard.synchronize()
                    }
                    completion(response)
                    break
                case .failure(let error):
                    print(error)
                    completion(response)
                }
                
        }
    }
    
    
    
    
    func SignUpProfileRequest(url:String, profileImg:Data, parameters:Parameters, completion: @escaping (_ result: DataResponse<Any>) -> Void) {
        Alamofire.upload(multipartFormData:
            {
                (multipartFormData) in
                
                
                multipartFormData.append(profileImg, withName: "image", fileName: "file.jpeg", mimeType: "image/jpeg")
                for (key, value) in parameters
                {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                //}, to:url!,headers:nil)
        }, to:url)
            
            
        { (result) in
            switch result {
            case .success(let upload,_,_ ):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print(progress)
                    
                    
                })
                //To check and verify server error
                upload.responseString(completionHandler: { (response) in
                    print(response)
                    print (response.result)
                })
                upload.responseJSON
                    { response in
                        
                        switch response.result {
                        case .success:
                            print(response)
                            completion(response)
                            break
                        case .failure(let error):
                            print(error)
                            completion(response)
                        }
                        
                        
                }
                
            case .failure(_):
                print(result)
                // completion(responds)
            }
            
            
            
        }
    }
    func UpateProfileRequestPut(url:String, profileImg:Data, parameters:Parameters, completion: @escaping (_ result: DataResponse<Any>) -> Void) {
        
        RefreshToken( completion:{
            response in
            print(response)
            if response.result.value == nil {
                print("No response")
                
                return
            }
            else {
                
                let responseData = response.result.value as! NSDictionary
                let status = responseData["success"] as! Bool
                if(status)
                {
                    let uData = responseData["data"] as! NSDictionary
                    let userData = uData["user"] as! NSDictionary
                    
                    
                    let auth_token = userData[APP_CONSTANT.ACCESSTOKEN] as! String
                    UserDefaults.standard.set(auth_token, forKey: APP_CONSTANT.ACCESSTOKEN)
                    UserDefaults.standard.synchronize()
                    
                    var auth_value : String = UserDefaults.standard.string(forKey: APP_CONSTANT.ACCESSTOKEN)!
                    auth_value = "bearer " + auth_value
                    
                    let headers: HTTPHeaders = [
                        "Authorization" : auth_value,
                        "Accept" : "application/json"
                    ]
                    
                    print(headers)
                    Alamofire.upload(multipartFormData:
                        {
                            (multipartFormData) in
                            
                            
                            multipartFormData.append(profileImg, withName: "image", fileName: "file.jpeg", mimeType: "image/jpeg")
                            for (key, value) in parameters
                            {
                                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                            }
                            //}, to:url!,headers:nil)
                    }, to:url,headers:headers)
                        
                        
                    { (result) in
                        switch result {
                        case .success(let upload,_,_ ):
                            upload.uploadProgress(closure: { (progress) in
                                //Print progress
                                print(progress)
                                
                                
                            })
                            //To check and verify server error
                            upload.responseString(completionHandler: { (response) in
                                print(response)
                                print (response.result)
                            })
                            upload.responseJSON
                                { response in
                                    
                                    switch response.result {
                                    case .success:
                                        print(response)
                                        completion(response)
                                        break
                                    case .failure(let error):
                                        print(error)
                                        completion(response)
                                    }
                                    
                                    
                            }
                            
                        case .failure(_):
                            print(result)
                            // completion(responds)
                        }
                    }
                    
                }
                
            }
        });
        
    }
    
    
    public func Request_Api(url:String, methodType : HTTPMethod,parameters:Parameters,isHeaderIncluded:Bool, headers:HTTPHeaders, completion: @escaping (_ result: DataResponse<Any>) -> Void) {
        
        
        if(isHeaderIncluded)
        {
            RefreshToken(completion:{
                response in
                print(response)
                if response.result.value == nil {
                    print("No response")
                    completion(response)
                    return
                }
                else {
                    let responseData = response.result.value as! NSDictionary
                    let status = responseData["success"] as! Bool
                    if(status)
                    {
                        let uData = responseData["data"] as! NSDictionary
                        
                        let userData = uData["user"] as! NSDictionary
                        
                        let auth_token = userData[APP_CONSTANT.ACCESSTOKEN] as! String
                        UserDefaults.standard.set(auth_token, forKey: APP_CONSTANT.ACCESSTOKEN)
                        UserDefaults.standard.synchronize()
                        
                        var auth_value : String = UserDefaults.standard.string(forKey: APP_CONSTANT.ACCESSTOKEN)!
                        auth_value = "bearer " + auth_value
                        
                        let headers1: HTTPHeaders = [
                            "Authorization" : auth_value,
                            "Accept" : "application/json"
                        ]
                        
                        Alamofire.request(url, method: methodType, parameters: parameters, headers:headers1).validate(contentType: ["application/json","text/html"]).responseJSON
                            { response in
                                
                                switch response.result {
                                case .success:
                                    print(response)
                                    completion(response)
                                    break
                                case .failure(let error):
                                    print(error)
                                    completion(response)
                                }
                                
                        }.responseString { response in
                            print(response.result.value as Any)
                            switch(response.result) {
                            case .success(_):
                                if let data = response.result.value{
                                    print(data)
                                }
                                
                            case .failure(_):
                                print(response.result.error as Any)
                                break
                            }
                        }
                    }
                }
                
                
            });
        }
        else
        {
            Alamofire.request(url, method: methodType, parameters: parameters).validate(contentType: ["application/json","text/html"]).responseJSON
                { response in
                    
                    switch response.result {
                    case .success:
                        print(response)
                        completion(response)
                        break
                    case .failure(let error):
                        print(error)
                        completion(response)
                    }
                    
            }
        }
    }
    public func Request_Api_noHeaders(url:String, methodType : HTTPMethod,parameters:Parameters,isHeaderIncluded:Bool, headers:HTTPHeaders, completion: @escaping (_ result: DataResponse<Any>) -> Void) {
        
        
        if(isHeaderIncluded)
        {
            RefreshToken(completion:{
                response in
                print(response)
                if response.result.value == nil {
                    print("No response")
                    completion(response)
                    return
                }
                else {
                    let responseData = response.result.value as! NSDictionary
                    let status = responseData["success"] as! Bool
                    if(status)
                    {
                        let uData = responseData["data"] as! NSDictionary
                        
                        let userData = uData["user"] as! NSDictionary
                        
                        let auth_token = userData[APP_CONSTANT.ACCESSTOKEN] as! String
                        UserDefaults.standard.set(auth_token, forKey: APP_CONSTANT.ACCESSTOKEN)
                        UserDefaults.standard.synchronize()
                        
                        var auth_value : String = UserDefaults.standard.string(forKey: APP_CONSTANT.ACCESSTOKEN)!
                        auth_value = "bearer " + auth_value
                        
                        let headers1: HTTPHeaders = [
                            "Authorization" : auth_value,
                            "Accept" : "application/json"
                        ]
                        
                        Alamofire.request(url, method: methodType, parameters: parameters, headers:headers1).validate(contentType: ["application/json","text/html"]).responseJSON
                            { response in
                                
                                switch response.result {
                                case .success:
                                    print(response)
                                    completion(response)
                                    break
                                case .failure(let error):
                                    print(error)
                                    completion(response)
                                }
                                
                        }.responseString { response in
                            print(response.result.value as Any)
                            switch(response.result) {
                            case .success(_):
                                if let data = response.result.value{
                                    print(data)
                                }
                                
                            case .failure(_):
                                print(response.result.error as Any)
                                break
                            }
                        }
                    }
                }
                
                
            });
        }
        else
        {
            Alamofire.request(url, method: methodType, parameters: parameters).validate(contentType: ["application/json","text/html"]).responseJSON
                { response in
                    
                    switch response.result {
                    case .success:
                        print(response)
                        completion(response)
                        break
                    case .failure(let error):
                        print(error)
                        completion(response)
                    }
                    
            }
        }
    }
    
    
    func getTimeDurationBetweenCordinate(s_lat:Double, s_longg:Double, d_lat:Double, d_longg:Double, completion: @escaping (String)->Void){
        
        var duration = ""
        
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(s_lat),\(s_longg)&destination=\(d_lat),\(d_longg)&sensor=true&mode=driving&alternatives=true&key=\(Key.Google.placesKey)")!
        
        print(url)
        
        Alamofire.request(url).responseJSON { response in
            
            do{
                if let jsonData = response.data{
                    let response = try JSONDecoder().decode(DirectionAPI.self, from:jsonData) //Decode JSON Response Data
                    
                    
                    let routes = response.routes!
                    
                    duration = routes[0].legs?[0].duration?.text ?? ""
                    
                    completion(duration)
                    
                }
            } catch let parsingError {
                print("Error", parsingError)
                //                      Helper().hideSpinner(view: self.view)
            }
            
            
        }
        
        
        
        
    }
    
    /**
     * @brief this is a generic method use to show toast with generic message
     * @param message: String
     * @param controller: UIViewController
     **/
    public func showToast(message: String, controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.gray
        toastContainer.alpha = 0.7
        toastContainer.layer.cornerRadius = 10;
        toastContainer.clipsToBounds  =  true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])
        
        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)
        controller.view.addConstraints([c1, c2, c3])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 0.7
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 3.0, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    
    
    func presentOnMainScreens(controller: UIViewController,index:Int){
        
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customVC")
        tab_index = index
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .fullScreen
//        controller.present(vc, animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let newRoot = storyboard.instantiateInitialViewController() else {
            return // This shouldn't happen
        }
        UIApplication.shared.delegate?.window??.rootViewController = newRoot
//        self.window?.rootViewController = newRoot
    
    }
    
    
    
    
    
    
    
    
    
    /*! @discussion this method is use to add spinner
     
     *  @param view : UIView
     */
    func showSpinner(view : UIView) {
        
        
        iprogress.isShowModal = true
        iprogress.isShowCaption = false
        iprogress.isTouchDismiss = false
        iprogress.indicatorStyle = .circleStrokeSpin
        iprogress.indicatorColor = .white
        iprogress.boxColor = .gray
        iprogress.iprogressStyle = .vertical
        iprogress.indicatorStyle = .ballRotateChase
        iprogress.indicatorSize = 50
        iprogress.boxSize = 20
        
        iprogress.indicatorView.startAnimating()
        
        iprogress.attachProgress(toView: view)
        view.showProgress()
        
    }
    func hideSpinner(view : UIView) {
        iprogress.indicatorView.stopAnimating()
        view.dismissProgress()
    }
    
    func registerTableCell(tableView:UITableView,nibName:String,identifier:String){
        
        tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: identifier)
        tableView.tableFooterView = UIView()
        
    }
    func registerCollectionCell(collectionView:UICollectionView,nibName:String,identifier:String){
        
        collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: identifier)
        
    }
    
    func getViewController(storyBoard:String, withIdentifier:String) ->UIViewController{
        
        let controller = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier: withIdentifier)
        return controller
    }
    
    func popScreen(controller: UIViewController){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            controller.dismiss(animated: true, completion: nil)
        })
    }
    
}


extension FloatingPoint
{
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

//extension CLLocationCoordinate2D
//{
//    // NOTE: bearing is in radians
//    func locationWithBearing(bearing: Double, distanceMeters: Double,lat:Double,longg:Double) -> CLLocationCoordinate2D
//    {
//        let distRadians = distanceMeters / (6372797.6) // earth radius in meters
//
//        let origLat = lat
//        let origLon = longg
//
//        let newLat = asin(sin(origLat) * cos(distRadians) + cos(origLat) * sin(distRadians) * cos(bearing))
//        let newLon = origLon + atan2(sin(bearing) * sin(distRadians) * cos(origLat), cos(distRadians) - sin(origLat) * sin(newLat))
//
//        return CLLocationCoordinate2D(latitude: newLat.radiansToDegrees, longitude: newLon.radiansToDegrees)
//    }
//}


extension CLLocationCoordinate2D {
    
    /// Get coordinate moved from current to `distanceMeters` meters with azimuth `azimuth` [0, Double.pi)
    ///
    /// - Parameters:
    ///   - distanceMeters: the distance in meters
    ///   - azimuth: the azimuth (bearing)
    /// - Returns: new coordinate
    func shift(byDistance distanceMeters: Double, azimuth: Double) -> CLLocationCoordinate2D {
        let bearing = azimuth
        let origin = self
        let distRadians = distanceMeters / (6372797.6) // earth radius in meters
        
        let lat1 = origin.latitude * Double.pi / 180
        let lon1 = origin.longitude * Double.pi / 180
        
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
    
    
    
    
    
}

//Sending Push Notifications
extension Helper{
    
    public static func customSendNotification(data:Data, controller:UIViewController ,  isDismiss : Bool = true) {
        
        let request = APIRouter.sendNotification(data)
        
        //        Helper().showSpinner(view: controller.view)
        
        APIClient.serverRequest(url: request, path: request.getPath(),body: data.dictionary ?? [:], dec: PostResponseData.self) { (response, error) in
            //            Helper().hideSpinner(view: controller.view)
            if(response != nil){
                if (response?.success) != nil {
                    
                    //                    Helper().showToast(message: response?.message ?? "-", controller: controller)
                    
                    if(isDismiss){
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            
                            controller.dismiss(animated: true){
                                
                            }
                        }
                    }
                    
                    
                    
                    
                }
                else{
                    //                    Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: controller)
                }
            }
            else if(error != nil){
                //                Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: controller)
            }
            else{
                //                Helper().showToast(message: "Nor Response and Error!!", controller: controller)
            }
            
            
        }
    }
    
}


//User Defaults
extension Helper{
    
    static func saveUserDefaultData<T:Codable>(data:T, title:String){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            
            UserDefaults.standard.set(encoded, forKey: title)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func deleteUserDefaultData(title:String){
        
        UserDefaults.standard.removeObject(forKey: title)
        UserDefaults.standard.synchronize()
        
    }
    
    static func getUserDefaultData<T:Decodable>(dec:T.Type, title:String) -> T?{
        
        guard let data = UserDefaults.standard.object(forKey: title) as? Data
            else{ return nil}
        
        let decoder = JSONDecoder()
        
        guard let val = try? decoder.decode(dec.self, from: data)
            else{ return nil}
        
        return val
        
    }
}
