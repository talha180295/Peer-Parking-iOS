//
//  FinishPopup.swift
//  PeerParking
//
//  Created by Apple on 29/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import HelperClassPod
import Alamofire

class FinishPopup: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func finish_btn(_ sender: UIButton) {

        let vehicle_type = GLOBAL_VAR.PARKING_POST_DETAILS["vehicle_type"] as! Int
        let parking_type = GLOBAL_VAR.PARKING_POST_DETAILS["parking_type"] as! Int
        let status = GLOBAL_VAR.PARKING_POST_DETAILS["status"] as! Int
        let initial_price = GLOBAL_VAR.PARKING_POST_DETAILS["initial_price"] as! Double
        let final_price = GLOBAL_VAR.PARKING_POST_DETAILS["final_price"] as! Double
        let start_at = GLOBAL_VAR.PARKING_POST_DETAILS["start_at"] as! String
        let end_at = GLOBAL_VAR.PARKING_POST_DETAILS["end_at"] as! String
        let address = GLOBAL_VAR.PARKING_POST_DETAILS["address"] as! String
        let longitude = GLOBAL_VAR.PARKING_POST_DETAILS["longitude"] as! String
        let latitude = GLOBAL_VAR.PARKING_POST_DETAILS["latitude"] as! String
        let is_negotiable = GLOBAL_VAR.PARKING_POST_DETAILS["is_negotiable"] as! Bool
        let image = GLOBAL_VAR.PARKING_POST_DETAILS["image"] as! UIImage
        let note = GLOBAL_VAR.PARKING_POST_DETAILS["note"] as! String
        let parking_hours_limit = GLOBAL_VAR.PARKING_POST_DETAILS["parking_hours_limit"] as! Double
        let parking_allowed_until = GLOBAL_VAR.PARKING_POST_DETAILS["parking_allowed_until"] as! String
        let parking_extra_fee_unit = GLOBAL_VAR.PARKING_POST_DETAILS["parking_extra_fee_unit"] as! Double
        let is_resident_free = GLOBAL_VAR.PARKING_POST_DETAILS["is_resident_free"] as! Bool
        
        print("abcdef=\(vehicle_type)")
 
        let params:[String:Any] = [
            "vehicle_type": vehicle_type,
            "parking_type": parking_type,
            "status": status,
            "initial_price": initial_price,
            "final_price": final_price,
            "start_at": start_at,
            "end_at": end_at,
            "address": address,
            "longitude": longitude,
            "latitude": latitude,
            "is_negotiable": is_negotiable,
            "note": note,
            "parking_hours_limit": parking_hours_limit,
            "parking_allowed_until": parking_allowed_until,
            "parking_extra_fee_unit": parking_extra_fee_unit,
            "is_resident_free": is_resident_free
        ]
        
        let auth_value =  "Bearer \(UserDefaults.standard.string(forKey: "auth_token")!)"
        let headers: HTTPHeaders = [
            "Authorization" : auth_value
        ]
        print("==0params=\(params)")
        print("==0headers=\(headers)")
        
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customVC")
//        self.present(vc, animated: true, completion: nil)

        
        
        let url = APP_CONSTANT.BASE_URL + APP_CONSTANT.POST_PARKING
        
        print("url--\(url)")
        
        
//        SharedHelper().Request_Api(url: url, methodType: .post, parameters: params, isHeaderIncluded: true, headers: headers)  {
//            response in
//
//            print("response>>>\(response)")
//
//            if response.result.value == nil {
//                print("No response")
//
//                SharedHelper().showToast(message: "Internal Server Error", controller: self)
//                return
//            }
//            else {
//                let responseData = response.result.value as! NSDictionary
//                let status = responseData["success"] as! Bool
//                if(status)
//                {
//                    let message = responseData["message"] as! String
//                    //let uData = responseData["data"] as! NSDictionary
//                    //let userData = uData["user"] as! NSDictionary
//                    //self.saveData(userData: userData)
//                    //                    SharedHelper().hideSpinner(view: self.view)
//                    //                     UserDefaults.standard.set("yes", forKey: "login")
//                    //                    UserDefaults.standard.synchronize()
//                    SharedHelper().showToast(message: message, controller: self)
//
//                    //self.after_signin()
//                }
//                else
//                {
//                    let message = responseData["message"] as! String
//                    SharedHelper().showToast(message: message, controller: self)
//                    //   SharedHelper().hideSpinner(view: self.view)
//                }
//            }
//        }
        
        uploadImage(urlString: url, imageParamKey: "image", image: image, param: params, headers: headers){
            response in
            
            print("response>>>\(response)")
        }
//        SharedHelper().RequestApiSingleImage(url: url, imageParamKey: "image", imageData: image, parameters: params, isHeaderIncluded: true, headers: headers) { response in
//
//            print("response>>>\(response)")
//
//            if response.result.value == nil {
//                print("No response")
//
//                SharedHelper().showToast(message: "Internal Server Error", controller: self)
//                return
//            }
//            else {
//                let responseData = response.result.value as! NSDictionary
//                let status = responseData["success"] as! Bool
//                if(status)
//                {
//                    let message = responseData["message"] as! String
//                    //let uData = responseData["data"] as! NSDictionary
//                    //let userData = uData["user"] as! NSDictionary
//                    //self.saveData(userData: userData)
//                    //                    SharedHelper().hideSpinner(view: self.view)
//                    //                     UserDefaults.standard.set("yes", forKey: "login")
//                    //                    UserDefaults.standard.synchronize()
//                    SharedHelper().showToast(message: message, controller: self)
//
//                    //self.after_signin()
//                }
//                else
//                {
//                    let message = responseData["message"] as! String
//                    SharedHelper().showToast(message: message, controller: self)
//                    //   SharedHelper().hideSpinner(view: self.view)
//                }
//            }
//        }
//
    }
    
    
    func uploadImage(urlString : String ,imageParamKey:String, image : UIImage, param : [String : Any],headers:HTTPHeaders, completionHandler : @escaping ( _ result : Any?) -> ())  {
        
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            multipartFormData.append(imageData,
                                     withName: imageParamKey,
                                     fileName: "image.jpg",
                                     mimeType: "image/jpeg")
        },
                         to: urlString,
                         headers: headers,
                         encodingCompletion: { encodingResult in
                            
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.uploadProgress { progress in
                                }
                                upload.validate()
                                upload.responseJSON { response in
                                    print("succccc")
                                    completionHandler(response.result)
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                completionHandler("er")
                            }
        })
    }
   

}
