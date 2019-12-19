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
    
    var bargainOffers:[Any] = []
    var auth_value = ""
    var bargainingId:Int!
    
//    var parking_id:Int!
//    var p_title = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        offersTblView.tableFooterView = UIView()
        offersTblView.dataSource = self
        offersTblView.delegate = self
        offersTblView.register(UINib(nibName: "BargainingCell", bundle: nil), forCellReuseIdentifier: "BargainingCell")
        
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
        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func setData(data:NSDictionary){
        
        
        let parking = data["parking"] as! NSDictionary
        
        
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
                    print("parkings.count=\(self.bargainOffers.count)")
                    
                    
                    self.offersTblView.reloadData()
                    //SharedHelper().showToast(message: message, controller: self)
                    
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
    
    
   

}


extension OfferBottomSheetVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = offersTblView.dequeueReusableCell(withIdentifier: "BargainingCell") as! BargainingCell
       
        cell.offer.textAlignment = .right
       
        switch indexPath.row {
        case 0:
            cell.offer.isHidden = true
            cell.leftOffer.isHidden = false
        case 1:
            cell.offer.isHidden = false
            cell.leftOffer.isHidden = true
        case 2:
            cell.offer.isHidden = true
            cell.leftOffer.isHidden = false
            
        default:
            cell.offer.isHidden = false
            cell.leftOffer.isHidden = false
        }
        
        return  cell
    }
    
}

