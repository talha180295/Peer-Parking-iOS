//
//  FeedbackVC.swift
//  PeerParking
//
//  Created by Apple on 24/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import Cosmos
import EzPopup
import Alamofire
import HelperClassPod

class FeedbackVC: UIViewController {
    
    @IBOutlet weak var emoji: UIImageView!
    @IBOutlet weak var rating_bar: CosmosView!
    @IBOutlet weak var label: UILabel!
    
    var parking_details:Parking!
    var p_id:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Called when user finishes changing the rating by lifting the finger from the view.
        // This may be a good place to save the rating in the database or send to the server.
        rating_bar.didFinishTouchingCosmos = { rating in
            
            print("Rating=\(rating)")
            if(rating >= 3.0){
                self.emoji.image = UIImage(named: "happy")
                self.label.text = "Ok Ok!"
            }
            else{
                self.emoji.image = UIImage(named: "sad")
                self.label.text = "No No!"
            }
        }
    }
    
    @IBAction func share_btn(_ sender: UIButton) {
        
        
        //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "parkedVC")
        //
        //        self.show(vc, sender: sender)
        
        if let id = p_id {
            
            print("p_id==\(id)")
            post_rating(p_id: p_id, rating: rating_bar.rating){
                
                if(self.parking_details.parkingType == ParkingType.PARKING_TYPE_PRIVATE){
                    Helper().presentOnMainScreens(controller: self, index: 0)
                    return;
                }
                self.parkingExist { (pakingAvailable) in
                    switch pakingAvailable {
                    case true:
                        Helper().presentOnMainScreens(controller: self, index: 0)
                        return
                    case false:
                       self.wantToSellParking()
                    }
                }
                
            }
            
        }
        
        
        
    }
    
    public func postFeedback()
    {
        //        ReviewSendingModel reviewSendingModel = new ReviewSendingModel();
        //        reviewSendingModel.setParking_id(parkingModel1.getId());
        //        reviewSendingModel.setRating(ratingBar.getRating());
        //
        //        Toast.makeText(getContext(),String.valueOf(ratingBar.getRating()),Toast.LENGTH_LONG).show();
        
        //        getBaseWebServices(true).postMultipartAPI(WebServiceConstants. REVIEW, null, reviewSendingModel.toString(), new WebServices.IRequestWebResponseAnyObjectCallBack() {
        //            @Override
        //            public void requestDataResponse(WebResponse<Object> webResponse) {
        //                checkAlreadySold();
        //
        //            }
        //
        //            @Override
        //            public void onError(Object object) {
        //                UIHelper.showToast(getContext(), "There was an error sending feedback");
        //                checkAlreadySold();
        //            }
        //        });
        
    }
    
    func wantToSellParking(){
        
        //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Sell_parking_popup") as! Sell_parking_popup
        let vc = ResellParkingPopUp.instantiate(fromPeerParkingStoryboard: .SellParking)
        vc.parking_details = self.parking_details
        Helper().popUp(controller: vc, view_controller: self, popupHeight: 400)
    }
    
    
    private func checkAlreadySold() {
        //        if(parkingModel1.getParkingType()== ParkingType.PARKING_TYPE_PRIVATE){
        //            getBaseActivity().popStackTill(1);
        //            return;
        //        }
        //        Map<String, Object> queryMap = new HashMap<>();
        //        queryMap.put("my_public_spots",1);
        //        getBaseWebServices(true).getAPIAnyObject(WebServiceConstants.PATH_PARKING, queryMap, new WebServices.IRequestWebResponseAnyObjectCallBack() {
        //            @Override
        //            public void requestDataResponse(WebResponse<Object> webResponse) {
        //
        //                if(webResponse.isSuccess())
        //                {
        //                    Type type = new TypeToken<ArrayList<ParkingModel1>>() {
        //                    }.getType();
        //                    ArrayList<ParkingModel1>  arrayList = GsonFactory.getSimpleGson()
        //                            .fromJson(GsonFactory.getSimpleGson().toJson(webResponse.result)
        //                                    , type);
        //                    boolean isPublicParkingSold=false;
        //                    if(arrayList.size() > 0)
        //                    {
        //                        for (ParkingModel1 model :arrayList) {
        //                            if(model.getParkingType()== ParkingType.PARKING_TYPE_PUBLIC && (model.getStatus()== AppConstants.STATUS_PARKING_AVAILABLE || model.getStatus()==AppConstants.STATUS_PARKING_UNAVAILABLE)){
        //                                isPublicParkingSold=true;
        //                                break;
        //                            }
        //                        }
        //                    }
        //                    if(!isPublicParkingSold){
        //                        showOptionToResaleParking();
        //                    }else{
        //                        getBaseActivity().popStackTill(1);
        //                    }
        //
        //                }
        //            }
        //
        //            @Override
        //            public void onError(Object object) {
        //
        //            }
        //        });
    }
    
    func post_rating(p_id:Int,rating:Double,completion: @escaping () -> Void){
        
        
        
        let params:[String:Any] = [
            
            "parking_id": p_id,
            "rating": rating
            
        ]
        
        //params.updateValue("hello", forKey: "new_val")
        let auth_value =  "Bearer \(UserDefaults.standard.string(forKey: APP_CONSTANT.ACCESSTOKEN)!)"
        let headers: HTTPHeaders = [
            "Authorization" : auth_value
        ]
        print("==0params=\(params)")
        print("==0headers=\(headers)")
        
        //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customVC")
        //        self.present(vc, animated: true, completion: nil)
        
        
        let url = APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.REVIEWS
        
        print("url--\(url)")
        
        
        Helper().Request_Api(url: url, methodType: .post, parameters: params, isHeaderIncluded: true, headers: headers){ response in
            
            print("response>>>123\(response)")
            
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
                    let message = responseData["message"] as! String
                    //let uData = responseData["data"] as! NSDictionary
                    //let userData = uData["user"] as! NSDictionary
                    //self.saveData(userData: userData)
                    //                    SharedHelper().hideSpinner(view: self.view)
                    //                     UserDefaults.standard.set("yes", forKey: "login")
                    //                    UserDefaults.standard.synchronize()
                    SharedHelper().showToast(message: message, controller: self)
                    
                    completion()
                    //self.after_signin()
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
    
    func parkingExist(completion:@escaping (Bool)->Void){
        
        //        let params = [
        //            "is_schedule" : 1,
        //            "mood" : 10
        //        ]
        //
        let params =  ["my_public_spots":1]
        
        print("param123=\(params)")
        
        
        let url_r = APIRouter.getParkings(params)
        let decoder = ResponseData<[Parking]>.self
        Helper().showSpinner(view: self.view)
        APIClient.serverRequest(url: url_r, path: url_r.getPath(), dec: decoder) { (response, error) in
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if let _ = response?.success {
                    if let val = response?.data {
                        
                        if(val.count>0){
                            completion(true)
                        }
                        else{
                            completion(false)
                        }
                    }
                }
                else{
                    
                }
            }
            else if(error != nil){
            }
            else{
                
            }
        }
    }
    
}
