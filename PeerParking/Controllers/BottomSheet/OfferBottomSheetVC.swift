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

    @IBOutlet weak var offersTblView: UITableView!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var parking_title: UILabel!
    
    @IBOutlet weak var rating_view: CosmosView!
    
    @IBOutlet weak var vehicle_type: UILabel!
    
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var barg_count: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    var parking_details:NSDictionary!
    
    @IBOutlet weak var offerTF: UITextField!
    
    var bargainOffers:[Any] = []
    var auth_value = ""
    var bargainingId:Int!
    var parkingId:Int?
    var buyerId:Int?
    var offerPrice:Double?
    var userType = 0  //20==seller
    
//    var parking_id:Int!
//    var p_title = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        offersTblView.tableFooterView = UIView()
        offersTblView.dataSource = self
        offersTblView.delegate = self
        offersTblView.register(UINib(nibName: "BargainingCell", bundle: nil), forCellReuseIdentifier: "BargainingCell")
        
        let parking = parking_details["parking"] as! NSDictionary
        
        self.parkingId = parking["id"] as? Int
        
        
        let buyer = parking_details["buyer"] as! NSDictionary
        
        self.buyerId = buyer["id"] as? Int
        
        
        
        let myId = UserDefaults.standard.integer(forKey: "id")
        
        if(myId == buyerId){
            
            userType = 10
            
        }
        else{
            
            userType = 20
            
        }
        
        setData(data: parking_details)
        
        
//        parking_title.text = p_title
    }
    
    @IBAction func accept_btn_click(_ sender: UIButton) {
        
        print("Accpet")
//        // Get the destination view controller and data store
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let destinationVC = storyboard.instantiateViewController(withIdentifier: "BottomSheetVC") as! BottomSheetVC
//        var destinationDS = destinationVC.offer_btn.setTitle("GO", for: .normal)
        
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
//            let price:String = offerTF.text!
            let offer:[String:Any] = ["offer": self.offerPrice, "direction": direction]
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
        
      
//        self.dismiss(animated: false, completion: nil)
    }
    
    func postBargainingOffer(params:[String:Any]){
        
        Helper().RefreshToken { response in
            
            print(response)
            if response.result.value == nil {
                print("No response")
                
                return
            }
            else{
                
                Alamofire.request(APIRouter.postBargainingOffer(params)).responsePost{ response in
                    
                    switch response.result {
                    case .success:
                        if response.result.value?.success ?? false{
                            
                            print("val=\(response.result.value?.message ?? "-")")
                            
                        }
                        else{
                            print("Server Message=\(response.result.value?.message ?? "-" )")
                            
                        }
                        
                    case .failure(let error):
                        print("ERROR==\(error)")
                    }
                }
                
            }
        }
        
    }
    
    
    func setData(data:NSDictionary){
        
        
        let parking = data["parking"] as! NSDictionary
        
        let id = data["id"] as! Int
        
        if let p_address = parking["address"] as? String{

            self.parking_title.text = p_address
        }
        
        if let initial_price = parking["initial_price"] as? Double{
            
            print("initial_price123=\(initial_price)")
            self.price.text = "$\(initial_price)"
        }
        
        if let vehicle_type_text = parking["vehicle_type_text"] as? String{
            
            self.vehicle_type.text = vehicle_type_text
        }
        
        getAllBargainOffers(id: id, isHeaderIncluded: true){
            
            
        }
        
        
    }
    
    func getAllBargainOffers(id:Int,isHeaderIncluded:Bool,completion: @escaping () -> Void){//(withToken:Bool,completion: @escaping (JSON) -> Void){
        
        
        bargainOffers = []
        
        let params = [
            
            "":""
            
        ]
        
        print("param123=\(params)")
        
        
        
        if let value : String = UserDefaults.standard.string(forKey: "auth_token"){
            
            auth_value = "bearer " + value
        }
        
        
        let headers: HTTPHeaders = [
            "Authorization" : auth_value
        ]
        
        
        let url = "\(APP_CONSTANT.API.BASE_URL + APP_CONSTANT.API.BARGAININGS)/\(id)"
        
        print("BARGAININGS_url=\(url)")
        
        Helper().Request_Api(url: url, methodType: .get, parameters: params, isHeaderIncluded: isHeaderIncluded, headers: headers){
            response in
            //print("response=\(response)")
            if response.result.value == nil {
                print("No response")
                
                Helper().showToast(message: "Internal Server Error", controller: self)
                completion()
                return
            }
            else{
                let responseData = response.result.value as! NSDictionary
                let status = responseData["success"] as! Bool
                if(status){
                    
                    //                    let message = responseData["message"] as! String
                    let data = responseData["data"] as! [Any]
                    
                    self.bargainOffers = data
                    
                    
                    
                    self.offersTblView.reloadData()
//                    Helper().showToast(message: "\(self.bargainOffers.count)", controller: self)
                    
                    completion()
                    
                    
                }
                else
                {
                    let message = responseData["message"] as! String
                    Helper().showToast(message: message, controller: self)
                    //   SharedHelper().hideSpinner(view: self.view)
                    completion()
                }
            }
        }
        
    }
    
    
    
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
        
        //properties
        //            popupVC.backgroundAlpha = 1
        //            popupVC.backgroundColor = .black
        //            popupVC.canTapOutsideToDismiss = true
        //            popupVC.cornerRadius = 10
        //            popupVC.shadowEnabled = true
        
        // show it by call present(_ , animated:) method from a current UIViewController
        
        present(popupVC, animated: true)
    }
    
   

}


extension OfferBottomSheetVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bargainOffers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = offersTblView.dequeueReusableCell(withIdentifier: "BargainingCell") as! BargainingCell
       
        cell.offer.textAlignment = .right
       
        
        let dict = bargainOffers[indexPath.row] as! NSDictionary
       
        
        let direction = dict["direction"] as? Int
        
        let offer = dict["offer"] as? Double
        
        switch self.userType {
        case 10:
            switch direction {
            case 10:
                cell.leftOffer.text = "$ \(offer ?? 0.9)"
                cell.offer.superview?.isHidden = true
                cell.leftOffer.superview?.isHidden = false
            case 20:
                cell.offer.text = "$ \(offer ?? 0.9)"
                cell.offer.superview?.isHidden = false
                cell.leftOffer.superview?.isHidden = true
                
            default:
                break
            }
        case 20:
            switch direction {
            case 20:
                cell.leftOffer.text = "$ \(offer ?? 0.9)"
                cell.offer.superview?.isHidden = true
                cell.leftOffer.superview?.isHidden = false
            case 10:
                cell.offer.text = "$ \(offer ?? 0.9)"
                cell.offer.superview?.isHidden = false
                cell.leftOffer.superview?.isHidden = true
                
            default:
                break
            }
        default:
            break
        }
        
        
        return  cell
    }
    
}

