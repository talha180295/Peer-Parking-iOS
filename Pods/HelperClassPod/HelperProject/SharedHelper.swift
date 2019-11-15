//
//  SharedHelper.swift
//  HelperProject
//
//  Created by Munzareen Atique on 11/1/19.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import Alamofire


public class SharedHelper: UIViewController {

    var isLogin :String!
   
    override public  func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    /**
     * @brief this method is use to check internet availability
     *  @return Bool
     */
    public func isInternetAvailable() -> Bool
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
   
    /**
     * @brief this is a generic method use to validate email
     * @param enteredEmail:String
     * @return Bool
     **/
    public func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
    /**
     * @brief this is a generic method use to show toast with generic message
     * @param message: String
     * @param controller: UIViewController
     **/
    public func showToast(message: String, controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black
        toastContainer.alpha = 0.0
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
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 3.0, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    
    /**
     * @brief this is a generic method use to convert hexadecimal string into UIColor
     * @param hex:String
     * @return UIColor
     **/
    public func ConvertHexColorToUIColor (hex:String) -> UIColor {
        
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
   
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    
    /**
     * @brief this is a generic method use to format date string into MMM dd, hh:mm a format
     * @param dateStr : String
     * @return String
     **/
    public func getPastTime(dateStr : String,dateFormat : String) -> String {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat //"yyyy-mm-dd hh:mm:ss"
        let date1 = dateFormatter.date(from: dateStr)
        
        var secondsAgo = Int(Date().timeIntervalSince(date1!))
        if secondsAgo < 0 {
            secondsAgo = secondsAgo * (-1)
        }
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo > week {
            let day = secondsAgo/day
            if day == 1{
                return "\(day) day ago"
            }else{
                return "\(day) days ago"
            }
        }
        else if secondsAgo > day {
            let hr = secondsAgo/hour
            if hr == 1{
                return "\(hr) hr ago"
            } else {
                return "\(hr) hrs ago"
            }
        }
            
        else if secondsAgo > hour {
            let min = secondsAgo/minute
            if min == 1{
                return "\(min) min ago"
            }else{
                return "\(min) mins ago"
            }
        }
        else if secondsAgo > minute  {
            if secondsAgo < 2{
                return "just now"
            }else{
                return "\(secondsAgo) secs ago"
            }
        }
        else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd, hh:mm a"
            formatter.locale = Locale(identifier: "en_US")
            let strDate: String = formatter.string(from: date1!)
            return strDate
        }
    }
    
    
    /**
     * @brief this is a generic method use to format date into specific format
     * @param strDate: String
     * @param currentFomat:String
     * @param expectedFromat: String
     * @return String
     **/
    public func getFormattedDate(strDate: String , currentFomat:String, expectedFromat: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var date : Date
        
        date = dateFormatterGet.date(from: strDate)!
        
        dateFormatterGet.dateFormat = "MMM dd,yyyy"
        let strDate = dateFormatterGet.string(from: date)
        
        return strDate
    }
    
    /**
     * @brief this is a generic method use to validate password
     * @param passwordStr:String
     * @return Bool
     **/
    public func isValidPassword(passwordStr:String?) -> Bool {
        guard passwordStr != nil else { return false }
        
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: passwordStr)
    }
    
    
    
    /**
     * @brief this is a generic method use to hit API call
     * @param url : String
     * @param methodType : HTTPMethod
     * @param  parameters:Parameters
     * @param isHeaderIncluded : Bool
     * @param headers : HTTPHeaders
     * @return completion block which return data dictionary
     **/
    
    public func Request_Api(url:String, methodType : HTTPMethod,parameters:[String:Any],isHeaderIncluded:Bool, headers:HTTPHeaders, completion: @escaping (_ result: DataResponse<Any>) -> Void) {
        
        
        if(isHeaderIncluded)
        {
            Alamofire.request(url, method: methodType, parameters: parameters, headers:headers).validate(contentType: ["application/json","text/html"]).responseJSON
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
    
    
    
    
    /**
     * @brief this is a generic method use to Post method API call
     * @param url : String
     * @param methodType : HTTPMethod
     * @param  parameters:Parameters
     * @param isHeaderIncluded : Bool
     * @param headers : HTTPHeaders
     * @return completion block which return data dictionary
     **/
    
    public func Request_Api_Raw_Data(url:String, methodType : HTTPMethod,parameters:Parameters,isHeaderIncluded:Bool, headers:HTTPHeaders, completion: @escaping (_ result: DataResponse<Any>) -> Void) {
        
        
        if(isHeaderIncluded)
        {
            Alamofire.request(url, method: methodType, parameters: parameters,encoding: URLEncoding.httpBody, headers:headers).responseJSON
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
        else
        {
            Alamofire.request(url, method: methodType, parameters: parameters,encoding: URLEncoding.httpBody).responseJSON
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
    
    
    
    
    
    /**
     * @brief this is a generic method use to Post method API call uploading single image with multipart
     * @param url : String
     * @param imageParamKey:String
     * @param profileImg:Data
     * @param  parameters:Parameters
     * @param isHeaderIncluded : Bool
     * @param headers : HTTPHeaders
     * @return completion block which return data dictionary
     **/
    
    
    public func RequestApiSingleImage(url:String, imageParamKey:String,imageData:Data, parameters:[String:Any],isHeaderIncluded:Bool, headers:HTTPHeaders, completion: @escaping (_ result: DataResponse<Any>) -> Void) {
        
        if(isHeaderIncluded)
        {
            Alamofire.upload(multipartFormData:
                {
                    (multipartFormData) in
                    
                    
                    multipartFormData.append(imageData, withName: imageParamKey, fileName: "file.jpeg", mimeType: "image/jpeg")
                    
                    
                    
                    for (key, value) in parameters
                    {
                        //multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                         multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    //}, to:url!,headers:nil)
            }, to:url , headers : headers)
            {
                (result) in
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
        else
        {
        Alamofire.upload(multipartFormData:
            {
                (multipartFormData) in
                
                
                multipartFormData.append(imageData, withName: imageParamKey, fileName: "file.jpeg", mimeType: "image/jpeg")
                
                
                
                for (key, value) in parameters
                {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                //}, to:url!,headers:nil)
        }, to:url)
        {
            (result) in
            switch result {
            case .success(let upload,_,_ ):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print(progress)
                    
                    
                })
                //To check and verify server error
                /*upload.responseString(completionHandler: { (response) in
                 print(response)
                 print (response.result)
                 })*/
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
    
   
    /**
     * @brief this is a generic method use to Post method API call uploading multiple images array with multipart
     * @param url : String
     * @param arrayImageData:NSMutableArray
     * @param imageParamKey:String
     * @param  parameters:Parameters
     * @param isHeaderIncluded : Bool
     * @param headers : HTTPHeaders
     * @return completion block which return data dictionary
     **/
   
    
    public func RequestApiMultipleImages(url:String,imageParamKey:String, arrayImageData:NSMutableArray, parameters:Parameters,isHeaderIncluded:Bool, headers:HTTPHeaders, completion: @escaping (_ result: DataResponse<Any>) -> Void) {
        
       if(isHeaderIncluded)
       {
        Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            for imageData in arrayImageData {
                
                multipartFormData.append(imageData  as! Data, withName: imageParamKey+"[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                
            }
           
            for (key, value) in parameters
            {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:url,headers:headers)
        {
            (result) in
            switch result {
            case .success(let upload,_,_ ):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print(progress)
                    
                    
                })
                //To check and verify server error
                /*upload.responseString(completionHandler: { (response) in
                 print(response)
                 print (response.result)
                 })*/
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
        else
       {
        Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            for imageData in arrayImageData {
                
                multipartFormData.append(imageData  as! Data, withName: imageParamKey+"[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                
            }
            
            for (key, value) in parameters
            {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:url)
        {
            (result) in
            switch result {
            case .success(let upload,_,_ ):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print(progress)
                    
                    
                })
                //To check and verify server error
                /*upload.responseString(completionHandler: { (response) in
                 print(response)
                 print (response.result)
                 })*/
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
    
    /**
     * @brief this is a generic method use to convert image into data
     * @param image : UIImage
     * @return Data
     **/
    
    public func ConvertImageIntoData(image : UIImage) -> Data {
        
         let data = image.jpegData(compressionQuality: 0.6)
        
        return data!
    }
    
    
    /**
     * @brief this is a generic method use to convert data into image
     * @param data : data
     * @return UIImage
     **/
    
    public func ConvertDataIntoImage(data : Data) -> UIImage {
        let image = UIImage(data: data)
        return image!
        
    }
    
    /**
     * @brief this is a generic method use to encode image into base64 String
     * @param image : UIImage
     * @return String
     **/
    
    public func ImageEncodingBase64(image : UIImage) -> String {
        
        let imageData = image.pngData()
        let base64String = imageData?.base64EncodedString()
        
        return base64String!

    }
    
    /**
     * @brief this is a generic method use to decode base64 string into base64 UIImage
     * @param baseStr : String
     * @return UIImage
     **/
    
    public func ImageDecodingBase64(baseStr : String) -> UIImage {
        let imageData = Data.init(base64Encoded: baseStr, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
        
    }
    
    
    /**
     * @brief this is a generic method use to share text or link through other apps
     * @param link : String
     * @param msg : String
     * @param vc: UIViewController
     **/
    
    public func shareLinkToAllApps(link : String, msg : String, vc: UIViewController)  {
      
        if let myWebsite = NSURL(string: link) {
            let objectsToShare = [msg, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            vc.present(activityVC, animated: true, completion: nil)
        }
    }
    
    /**
     * @brief this is a generic method use to get device UUID
     * @return String
     **/
    
    public func getUUID() -> String {
        
        let uuid = NSUUID().uuidString.lowercased()
        
        return uuid
    }
   
    
    /**
     * @brief this is a generic method use to get app version number
     * @return String
     **/
    
    public func getAppVersion() -> String {
        let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String

        return versionNumber
    }
   
    /**
     * @brief this is a generic method use to get app build number
     * @return String
     **/
    
    public func getAppBuildNumber() -> String {
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        
        return buildNumber
    }
    
    
    /**
     * @brief this is a generic method use to get screen height or width
     * @param isWidth : Bool
     * @param isHeight : Bool
     * @return CGFloat
     **/
    
    public func getScreenSize(isWidth : Bool, isHeight : Bool) -> CGFloat
    {
        let screenSize: CGRect = UIScreen.main.bounds
        if(isWidth)
        {
            return screenSize.width
        }
        else if(isHeight)
        {
            return screenSize.height
        }
        
        return 0.0
    }
    
    
    /**
     * @brief this is a generic method use to get textview height
     * @param textview : UITextView
     * @return CGFloat
     **/
    
    public func getTextViewHeight(textview : UITextView) -> CGFloat
    {
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.isScrollEnabled = false
        textview.sizeToFit()
        return textview.contentSize.height
        
    }
    
    /**
     * @brief this is a generic method use to get UIView height or width
     * @param isWidth : Bool
     * @param isHeight : Bool
     * @param view : UIView
     * @return CGFloat
     **/
    
    public func getUIViewHeightWidth(isWidth : Bool, isHeight : Bool,view : UIView) -> CGFloat {
        
        
        if(isWidth)
        {
            return view.bounds.size.width
        }
        else if(isHeight)
        {
            return view.bounds.size.height
        }
        
        return 0.0
        
    }
    
    /**
     * @brief this is a generic method use to encode string into base64
     * @param str : String
     * @return String
     **/
    
    public func StringfromBase64(str : String) -> String? {
        guard let data = Data(base64Encoded: str) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    
    /**
     * @brief this is a generic method use to decode string from base64
     * @param str : String
     * @return String
     **/
    
    public func StringtoBase64(str : String) -> String {
        return Data(str.utf8).base64EncodedString()
    }
    
    /**
     * @brief this is a generic method use to show Alert with custom title and message and button title
     * @param title : String
     * @param msg:String
     * @param btnTitle : String
     * @param vc : UIViewController
     **/
    
    public func showAlertMessage(title : String, msg:String,btnTitle : String,vc : UIViewController)  {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: btnTitle, style: .default, handler: { action in
            
        alert.dismiss(animated: true, completion: nil)
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
   
    
    

}
