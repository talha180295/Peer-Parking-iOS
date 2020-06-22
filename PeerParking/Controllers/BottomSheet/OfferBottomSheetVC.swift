//
//  OfferBottomSheetVC.swift
//  PeerParking
//
//  Created by Apple on 21/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import EzPopup


class OfferBottomSheetVC: UIViewController {

    //Intent Variables
    var bargainingDetails:Bargaining!
    var parkingDetails:Parking!
    
    
    
    @IBOutlet weak var offersTblView: UITableView!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var parking_title: UILabel!
    
    @IBOutlet weak var rating_view: CosmosView!
    
    @IBOutlet weak var vehicle_type: UILabel!
    
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var barg_count: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
  
    
    @IBOutlet weak var offerTF: UITextField!
    
    

    
    //Variables
    var bargainOffers:[Bargaining] = []
    var auth_value = ""
    var buyerId:Int?
    var offerPrice:Double?
    var userType = 0  //20==seller
    var parkingId:Int?
    let myId = UserDefaults.standard.integer(forKey: "id")
    var buyerBargainingCount:Int = 0
    var sellerBargainingCount:Int = 0
    
    var buyerLastOffer:Double?
           
    var sellerLastOffer:Double?
           
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        offersTblView.dataSource = self
//        offersTblView.delegate = self
        offersTblView.register(UINib(nibName: "BargainingCell", bundle: nil), forCellReuseIdentifier: "BargainingCell")
        
       
        
        if let parking = parkingDetails{
            
//            print("parkings=\(parking)")
            
            self.parkingId = parking.id
          
            let buyer = parking.buyer

            self.buyerId = buyer?.id ?? self.myId


            if(myId == buyerId){

                userType = 20

            }
            else{

                userType = 10

            }
           
            setData(data: parking)
            
            
            
        }
        
        if let bargaining = bargainingDetails{

            self.parkingId = bargaining.parkingID
             
            self.buyerId = bargaining.buyerID


            if(myId == buyerId){

              userType = 20

            }
            else{

              userType = 10

            }
            
            setData(data: bargaining)

        }
        
        
//        if let parking = bargaining_details{
//
//            self.parkingId = parking.id
//
//
//            let buyer = bargaining_details.buyer
//
//            self.buyerId = buyer?.id
//
//
//
//            let myId = UserDefaults.standard.integer(forKey: "id")
//
//            if(myId == buyerId){
//
//                userType = 10
//
//            }
//            else{
//
//                userType = 20
//
//            }
//
//            setData(data: bargaining_details)
//
//        }
        
    }
    
    @IBAction func accept_btn_click(_ sender: UIButton) {
        
        print("Accpet")
        
        NotificationCenter.default.post(name: Notification.Name("accept_offer"), object: nil)
            
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func send_offer(_ sender: UIButton) {
        
        let myId = UserDefaults.standard.integer(forKey: "id")
        var direction = 0
        if(myId == buyerId){
            direction = 20
        }
        else{
            direction = 10
        }
        
        if(offerTF.hasText){
            
            let offer = Bargaining(id: nil, parkingID: nil, buyerID: nil, status: nil, offer: self.offerPrice ?? 0.0, direction: direction, createdAt: nil, updatedAt: nil, deletedAt: nil, statusText: nil, buyer: nil, seller: nil, parking: nil)
            bargainOffers.append(offer)
            
            offersTblView.reloadData()
            
            offerTF.text = ""
            offerTF.placeholder = "Enter Your Offer"
            
            let params:[String:Any] = [
                "parking_id": self.parkingId ?? 0,
                "buyer_id": self.buyerId ?? 0,
                "status": 30,
                "offer": self.offerPrice ?? 0.0,
                "direction": direction
            ]


            print(params)
            postBargainingOffer(params: params)
            
        }
        
    }
    
    func postBargainingOffer(params:[String:Any]){
        
        APIClient.serverRequest(url: APIRouter.postBargainingOffer(params), path: "", dec: PostResponseData.self) { (response,error) in
            
            if(response != nil){
                Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
            }
            else if(error != nil){
                Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
            }
            else{
                Helper().showToast(message: "Nor Response and Error!!", controller: self)
            }
            
        }
       
        
    }
    
    
    func setData(data:Bargaining){
        
        let parking = data.parking
        
        let id = data.id ?? 0
        
        self.parking_title.text = parking?.address ?? "-"
    
        self.price.text = "\(parking?.initialPrice ?? 0.0)"
        
        self.vehicle_type.text = parking?.vehicleTypeText
        
        getAllBargainOffers(id: id){
         

            print(self.bargainOffers.count)
            
             for bargaining in self.bargainOffers {
                 self.updateLimitsCount(bargainingModel: bargaining)
             }
             print(APP_CONSTANT.DIRECTION.BUYER_TO_SELLER)
             print(self.userType)
             print(self.buyerBargainingCount)
             print(self.sellerBargainingCount)
            
            if(self.userType == APP_CONSTANT.DIRECTION.BUYER_TO_SELLER){
                 self.barg_count.text = "\(self.buyerBargainingCount)/3"
            }
            else{
                self.barg_count.text = "\(self.sellerBargainingCount)/3"
            }
           

        }
        
        getAllBargainOffersByParkingID(id: id){
         

            print(self.bargainOffers.count)
            
             for bargaining in self.bargainOffers {
                 self.updateLimitsCount(bargainingModel: bargaining)
             }
             
             print(self.sellerBargainingCount)
             print(self.sellerBargainingCount)

        }
    }
    
    func setData(data:Parking){

        let id = data.id ?? 0
        
        self.parking_title.text = data.address ?? "-"
    
        self.price.text = "\(data.initialPrice ?? 0.0)"
        
        self.vehicle_type.text = data.vehicleTypeText
        

        
    }
    
    func updateLimitsCount(bargainingModel:Bargaining) {
        
        if (bargainingModel.direction == APP_CONSTANT.DIRECTION.BUYER_TO_SELLER) {
            self.buyerBargainingCount+=1
            buyerLastOffer = bargainingModel.offer
        }
        else if (bargainingModel.direction == APP_CONSTANT.DIRECTION.SELLER_TO_BUYER) {
            self.sellerBargainingCount+=1
            sellerLastOffer = bargainingModel.offer
        }

    }
    
    func getAllBargainOffersByParkingID(id:Int, completion: @escaping () -> Void){
        
        let params:[String:Any] = ["parking_id":id]
        APIClient.serverRequest(url: APIRouter.getBargainings(params), path: "", dec: ResponseData<[Bargaining]>.self) { (response,error) in
            
            
            if(response != nil){
                if (response?.success) != nil {
                    //Helper().showToast(message: "Succes=\(success)", controller: self)
                    if let val = response?.data {
                    
//                        print(val)
                        self.bargainOffers = val
                        self.offersTblView.reloadData()
                        completion()
                    }
                }
                else{
                    Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                }
            }
            else if(error != nil){
                Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
            }
            else{
                Helper().showToast(message: "Nor Response and Error!!", controller: self)
            }
            
        }
    }
    
    func getAllBargainOffers(id:Int, completion: @escaping () -> Void){
        
        
        print(id)
        
        APIClient.serverRequest(url: APIRouter.getBargainingsById(id: id), path: "", dec: ResponseData<[Bargaining]>.self) { (response,error) in
            
            if(response != nil){
                if (response?.success) != nil {
                    //Helper().showToast(message: "Succes=\(success)", controller: self)
                    if let val = response?.data {
                    
//                        print(val)
                        self.bargainOffers = val
                        self.offersTblView.reloadData()
                        completion()
                    }
                }
                else{
                    Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                }
            }
            else if(error != nil){
                Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
            }
            else{
                Helper().showToast(message: "Nor Response and Error!!", controller: self)
            }
            
        }
    }
    
//    func getAllBargainOffers2(id:Int,isHeaderIncluded:Bool,completion: @escaping () -> Void){
//
//        bargainOffers = []
//
//        let params = [
//
//            "":""
//
//        ]
//
//        print("param123=\(params)")
//
//
//
//        if let value : String = UserDefaults.standard.string(forKey: "auth_token"){
//
//            auth_value = "bearer " + value
//        }
//
//
//        let headers: HTTPHeaders = [
//            "Authorization" : auth_value
//        ]
//
//
//        let url = "\(APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.BARGAININGS)/\(id)"
//
//        print("BARGAININGS_url=\(url)")
//
//        Helper().Request_Api(url: url, methodType: .get, parameters: params, isHeaderIncluded: isHeaderIncluded, headers: headers){
//            response in
//            //print("response=\(response)")
//            if response.result.value == nil {
//                print("No response")
//
//                Helper().showToast(message: "Internal Server Error", controller: self)
//                completion()
//                return
//            }
//            else{
//                let responseData = response.result.value as! NSDictionary
//                let status = responseData["success"] as! Bool
//                if(status){
//
//                    //                    let message = responseData["message"] as! String
//                    let data = responseData["data"] as! [Any]
//
////                    self.bargainOffers = data
//
//
//
//                    self.offersTblView.reloadData()
////                    Helper().showToast(message: "\(self.bargainOffers.count)", controller: self)
//
//                    completion()
//
//
//                }
//                else
//                {
//                    let message = responseData["message"] as! String
//                    Helper().showToast(message: message, controller: self)
//                    //   SharedHelper().hideSpinner(view: self.view)
//                    completion()
//                }
//            }
//        }
//
//    }
    
    
    
    @IBAction func editText(_ sender: UITextField) {
        
        sender.resignFirstResponder()
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PricePicker") as! PricePicker
        
        vc.completionBlock = {(dataReturned) -> ()in
            //Data is returned **Do anything with it **
            print(dataReturned)
            sender.text = "$\(dataReturned)"
            self.offerPrice = Double(dataReturned)
//            GLOBAL_VAR.PARKING_POST_DETAILS.updateValue(Double(dataReturned)!, forKey: "parking_extra_fee")
        }
        let popupVC = PopupViewController(contentController: vc, popupWidth: 300, popupHeight: 300)
        popupVC.canTapOutsideToDismiss = true
        
        present(popupVC, animated: true)
    }
    
   

}


//extension OfferBottomSheetVC: UITableViewDelegate, UITableViewDataSource{
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return bargainOffers.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = offersTblView.dequeueReusableCell(withIdentifier: "BargainingCell") as! BargainingCell
//       
//        cell.offer.textAlignment = .right
//        
//        
//        let dict = bargainOffers[indexPath.row]
//       
//        
//        let direction = dict.direction ?? 0
//        
//        let offer = dict.offer ?? 0.0
//        
//        switch self.userType {
//        case 10:
//            switch direction {
//            case 10:
//                cell.leftOffer.text = "$ \(offer)"
//                cell.offer.superview?.isHidden = true
//                cell.leftOffer.superview?.isHidden = false
//            case 20:
//                cell.offer.text = "$ \(offer )"
//                cell.offer.superview?.isHidden = false
//                cell.leftOffer.superview?.isHidden = true
//                
//            default:
//                break
//            }
//        case 20:
//            switch direction {
//            case 20:
//                cell.leftOffer.text = "$ \(offer)"
//                cell.offer.superview?.isHidden = true
//                cell.leftOffer.superview?.isHidden = false
//            case 10:
//                cell.offer.text = "$ \(offer)"
//                cell.offer.superview?.isHidden = false
//                cell.leftOffer.superview?.isHidden = true
//                
//            default:
//                break
//            }
//        default:
//            break
//        }
//        
//        
//        return  cell
//    }
//    
//}

