//
//  RequestVC.swift
//  PeerParking
//
//  Created by Apple on 07/11/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseDatabase
import Firebase
import FirebaseCore
import CodableFirebase




class RequestVC: UIViewController ,UITableViewDataSource,UITableViewDelegate, ViewOfferProtocol {
    func chatButtonSelectListner(index: Int) {
        
        
        
        
        self.getParking( id : self.sellerReuestArray[index].parkingID ?? -1 , buyerId: self.sellerReuestArray[index].buyerID ?? 0)
        
        
        
    }
    
    func acceptButtonSelectListner(index: Int) {
        
        
        
//        if (!RequestVC.isSeller  && amountInWallet <= 0) {
//
//                   Helper().showToast(message: "Insufficient amount in wallet", controller: self)
//
//                   return;
//               }
        
        
        
        Database.database().reference(withPath: "chat/").child(String(self.sellerReuestArray[index].parkingID ?? 0)).observeSingleEvent(of: .value) { (snapshot) in
        
            if(snapshot.exists())
            {
                var buyersList : [String] = []
                
                  let enumerator = snapshot.children
                              
                              
                              
                              while let childSnapShot = enumerator.nextObject() as? DataSnapshot {
                                  
                                  guard let value = childSnapShot.value else { return }
                                  do {
                                      
                                    if (value is Dictionary<AnyHashable,Any>)  {
                                        
                                        buyersList.append(childSnapShot.key)
                                        // obj is a string array. Do something with stringArray
                                    }
                                    else {
                                        // obj is not a string array
                                    }
                                    
                                      
                                      
                                  } catch let error {
                                      print(error)
                                  }
                              }
                
                self.showAcceptOfferConfirmationDialog(firebaseParkingRequestsModel: self.sellerReuestArray[index] , buyersList:   buyersList )
//                showAcceptOfferConfirmationDialog(model,mFirebaseAdapter.getRef(position).getKey(),buyersList);
                
                
                
            }
            
        }
        
        
        
        
        
    }
    
    
    
    
    
  static var isSeller = true
    
    var chatRef : DatabaseReference!
    var parkingBuyerModelReference : DatabaseReference!
    var parkingReference : DatabaseReference!
    var requestReference : DatabaseReference!
    var sellerRequestIndexReference : DatabaseReference!
    var buyerRequestIndexReference : DatabaseReference!
    
    var  amountInWallet = 0.0;
    var requests:[Bargaining] = []
    
    var buyersRequest:[Bargaining] = []
    var sellerRequest:[Bargaining] = []
    
    var sellerReuestArray : [FirebaseRequestModel] = []
    
    var auth_value = ""
    
    var sellerKey : [String] = []
    var sellerVal : [Any] = []
     var dict = [String : Int]()
    @IBOutlet weak var tblNotification: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblNotification.tableFooterView = UIView()
        tblNotification.dataSource = self
        tblNotification.delegate = self
        
        tblNotification.register(UINib(nibName: "RequestCell", bundle: nil), forCellReuseIdentifier: "RequestCell")
        // Do any additional setup after loading the view.
        self.tblNotification.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "headerCell")
        
        
        self.getUpdatedWalletAmount()
        
       initial()
        
    }
    
    

    
    
    
    func initial(){
        
        self.segment.selectedSegmentIndex = RequestVC.isSeller ? 0 : 1
//        RequestVC.isSeller =  true
        
         makeReferences()
        RequestVC.isSeller ? getAllRequest(isSeller: true) :  getAllRequest(isSeller: false)
        
        
    }
    
    
    func getAllRequest(isSeller : Bool) {
        
        
        var ref  : DatabaseReference! = isSeller ? sellerRequestIndexReference : buyerRequestIndexReference
        ref.child(String(Helper().getCurrentUserId())).queryOrderedByValue().observe(.value) { (snapshot) in
           
            self.sellerReuestArray.removeAll()
            self.sellerKey.removeAll()
            self.dict.removeAll()
               
           
                snapshot.children.forEach { (child) in
                    
                    let snap = child as! DataSnapshot
                    
                    
                    print("key \(snap.key) + val \(snap.value)")
                    
                    self.sellerKey.append(snap.key)
                    
                    self.dict[snap.key] = snap.value as! Int
//
//                    self.sellerVal.append(snap.value)
                    
                   
                    
                                      
                    
                }
                
                
           
            
            self.getRequest()
            
        }
       
        
    }
    
    func showAcceptOfferConfirmationDialog(firebaseParkingRequestsModel : FirebaseRequestModel  , buyersList : [String]){
        
        
        if (firebaseParkingRequestsModel.parkingStatus == APP_CONSTANT.STATUS_PARKING_BOOKED) {
            return;
        }
        
        var model : ChatModel = firebaseParkingRequestsModel.lastMessage!
        model.offerStatus = APP_CONSTANT.STATUS_ACCEPTED
        
        let alert = UIAlertController(title: "Alert!", message: "Are you sure you want to accept offer of $ \(firebaseParkingRequestsModel.lastMessage!.offer!)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
            if (firebaseParkingRequestsModel.buyerID == Helper().getCurrentUserId()  && self.amountInWallet <= 0) {
            
                               Helper().showToast(message: "Insufficient amount in wallet", controller: self)
            
                               return;
                           }
            self.assignBuyerApi(model : firebaseParkingRequestsModel ,buyersList : buyersList );
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
            
    }
    
    func assignBuyerApi(model : FirebaseRequestModel,buyersList : [String]){
        
        
        let buyerParkingSendingModel = BuyerTakeOfferModel.init(status: APP_CONSTANT.STATUS_PARKING_BOOKED, buyer_id: model.buyerID ?? -1, final_price: model.lastMessage?.offer ?? -1)
                do{
                    let data = try JSONEncoder().encode(buyerParkingSendingModel)
                    
                    let request = APIRouter.assignBuyer(id: model.parkingID!, data)
                    APIClient.serverRequest(url: request, path: request.getPath(),body: buyerParkingSendingModel.dictionary ?? [:], dec: PostResponseData.self) { (response, error) in
                        
                        if(response != nil){
                            if (response?.success) != nil {
                                
                                
                                Helper().showToast(message: response?.message ?? "-", controller: self)
                                
                                let  firebaseChatReference = Database.database().reference(withPath: "chat/").child(String(model.parkingID!)).child(String(model.buyerID!))
                                
                                var lastMessage = model.lastMessage
                                
                                 let lastMessage_dict = try! FirebaseEncoder().encode(lastMessage)
                                firebaseChatReference.child(lastMessage!.id ?? "" ).setValue(lastMessage_dict);
                                self.requestReference = Database.database().reference(withPath: "requests/").child(String(model.parkingID!) + "-" + String(model.buyerID!))
                                
                                let request_dict = try! FirebaseEncoder().encode(model)
                                
                                 self.requestReference.setValue(request_dict)
                                
                                
                                let  parkingReference = Database.database().reference(withPath: "chat/").child(String(model.parkingID!))
                                
                                parkingReference.child("buyer_id").setValue(model.buyerID!)
                                
                            parkingReference.child("status").setValue(APP_CONSTANT.STATUS_PARKING_BOOKED)
                               
                                
                                var parkingModel : Parking = Parking()
                                parkingModel.id = model.parkingID
                                parkingModel.buyerID = model.buyerID
                                
                                Helper.removeRequestsOfAllOtherBuyers(parkingModel1: parkingModel, buyersList: buyersList)
                                
                                let refId = String(model.parkingID ?? -1) + "-" + String(model.buyerID ?? -1)
                                
                                let actionType = APP_CONSTANT.ACTION_PARKING_REQUEST
                                self.sendNotification(actionType: actionType,message: "You have a parking request.",refId: refId,  model );
                                
                                
                                
//                                var firebaseRequestModel : FirebaseRequestModel = FirebaseRequestModel()
//
//                                model.offerStatus =  APP_CONSTANT.STATUS_ACCEPTED
//                                firebaseRequestModel.parkingID = self.parkingId
//                                firebaseRequestModel.parkingTitle = self.parking_details.title ?? ""
//                                firebaseRequestModel.sellerID = self.parking_details.sellerID
//                                firebaseRequestModel.buyerID = self.buyerId
//                                firebaseRequestModel.lastMessage = model
//                                firebaseRequestModel.parkingLocation = self.parking_details.address
//                                firebaseRequestModel.parkingStatus = APP_CONSTANT.STATUS_PARKING_BOOKED
//
//
//                                let request_dict = try! FirebaseEncoder().encode(firebaseRequestModel)
//
//                                self.requestReference.setValue(request_dict)
//
//        //                        var  messageKey : String = self.chatRef.childByAutoId().key!
//
//                                model.offerStatus = APP_CONSTANT.STATUS_ACCEPTED
//
//                                let dict = try! FirebaseEncoder().encode(model)
//                                //          let object =  try DictionaryDecoder().decode(ChatModel.self, from: chatModel)
//
//
//                                self.chatRef.child(model.id!).setValue(dict)
//
//                                self.parkingReference.child("buyer_id").setValue(self.parking_details.buyerID)
//                                self.parkingReference.child("status").setValue(APP_CONSTANT.STATUS_PARKING_BOOKED
//                                    ,withCompletionBlock:{ (error, ref) -> Void in
//
//                                        if let error = error {
//                                            print(error.localizedDescription)
//                                        }
//                                        else
//                                        {
//
//        //                                    removeRequestsOfAllOtherBuyers(parkingModel1: model, buyersList: [String])
//
//                                        }
//
//
//                                })
                                
                                
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
                catch let parsingError {
                    
                    print("Error", parsingError)
                    
                }
                
        
        
    }
    
    func getRequest(){
        
//        self.sellerReuestArray.removeAll()
        
        let sorted = self.dict.sorted {$0.value > $1.value}
        
        
        sorted.forEach { (id1) in
           
            var ref = requestReference.child(id1.key)
                     
                    
            ref.observeSingleEvent(of : .value) { (snapshot) in
                        
                        
                        
                        do {
                            let model = try FirebaseDecoder().decode(FirebaseRequestModel.self, from: snapshot.value)
                            
                            self.sellerReuestArray.append(model)
                           self.tblNotification.reloadData()
                            
                            
                            
                        } catch let error {
                            print(error)
                        }
                      
                        
            //              let model = try FirebaseDecoder().decode(FirebaseRequestModel.self, from: DataSnapshot.value)
            //
            //
                    }
            
        }
//         self.tblNotification.reloadData()
        
        
       
        
      
        
        
        
    }
    
    
    private func getUpdatedWalletAmount() {
          
          let url = APIRouter.me
          let decoder = ResponseData<Me>.self
          
          Helper().showSpinner(view: self.view)
          APIClient.serverRequest(url: url,path:url.getPath(), dec: decoder) { (response, error) in
              
              Helper().hideSpinner(view: self.view)
              if(response != nil){
                  if (response?.success) != nil {
                      //                    Helper().showToast(message: response?.message ?? "-", controller: self)
                      if let val = response?.data {
                          
                          
                          self.amountInWallet = val.details?.wallet ?? -1.0 //userModel.getUserDetails().getWallet();
                          
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
          
          //        getBaseWebServices(true).postAPIAnyObject(WebServiceConstants.PATH_ME, "", new WebServices.IRequestWebResponseAnyObjectCallBack() {
          //            @Override
          //            public void requestDataResponse(WebResponse<Object> webResponse) {
          //
          //                UserModel userModel = new Gson().fromJson(new Gson().toJson(webResponse.result), UserModel.class);
          //                amountInWallet = userModel.getUserDetails().getWallet();
          //            }
          //
          //            @Override
          //            public void onError(Object object) {
          //
          //            }
          //        });
      }
    
    
    func getParking( id : Int, buyerId : Int){
          
          
          
          
        self.getParkingServer(id: id) { (pModel) in
              
             
              
              if (pModel != nil)
              {
                
                var parkingModel : Parking = Parking(dictionary: pModel.dictionary ??  [:])!
                  
                if(parkingModel.buyerID == nil)
                {
                    
                    parkingModel.buyerID = buyerId
                }
                
                
                
                    self.openChatScreen(model: parkingModel)
              }
             
          }
          
          
          
      }
    
    func openChatScreen(model : Parking){
        
        
        let vc = ChatVC.instantiate(fromPeerParkingStoryboard: .Chat)
               
               vc.modalPresentationStyle = .fullScreen
               
               vc.parking_details = model
               
               self.present(vc, animated: true, completion: nil)
    }
    
    
        func getParkingServer(id : Int   , completion: @escaping (Parking) -> Void){
            
            
             Helper().showSpinner(view: self.view)
            APIClient.serverRequest(url: APIRouter.getParkingsById(id: id), path: APIRouter.getParkingsById(id: id).getPath(), dec:
                ResponseData<Parking>.self) { (response,error) in
                    
                if(response != nil){
                    if (response?.success) != nil {
                        //Helper().showToast(message: "Succes=\(success)", controller: self)
                        if let val = response?.data {
                            
                            
                            //                        print(val)
                            
                            Helper().hideSpinner(view: self.view)
                            completion((response?.data ?? nil)! )
                        }
                         Helper().hideSpinner(view: self.view)
                    }
                  
                        
                    else{
                        Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                        
                          Helper().hideSpinner(view: self.view)
                        completion((response?.data ?? nil)! )
                    }
                }
                else if(error != nil){
                    Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
                      Helper().hideSpinner(view: self.view)
                    completion((response?.data ?? nil)! )
                }
                else{
                    Helper().showToast(message: "Nor Response and Error!!", controller: self)
                      Helper().hideSpinner(view: self.view)
    //                completion((response?.data ?? nil) ?? )
                }
                
            }
            
            
            
        }
    
    private func sendNotification(actionType : String , message : String , refId : String , _ requestModel : FirebaseRequestModel) {
        
        var model:NotificationSendingModel = NotificationSendingModel()
        model.refId = refId
        model.recieverId =  Helper().getCurrentUserId() ==  Int(requestModel.sellerID ?? 0) ?  Int(requestModel.buyerID ?? 0) : Int(requestModel.sellerID ?? 0)
       model.actionType = actionType
        model.message = message
        
        do{
            let data = try JSONEncoder().encode(model)
            Helper.customSendNotification(data: data, controller: self, isDismiss: false)
        }
        catch let parsingError {
            
            print("Parsing Error", parsingError)
            
        }
    }
    
    
   
    
    
    
    
    func makeReferences(){
           
           
          
           
//           chatRef = Database.database().reference(withPath: "chat/").child(String(parkingId)).child(String(buyerId))
//           parkingBuyerModelReference = Database.database().reference(withPath: "buyerModel/").child(String(buyerId))
//           parkingReference = Database.database().reference(withPath: "chat/").child(String(parking_details.id!))
//           requestReference = Database.database().reference(withPath: "requests/").child(String(parkingId) + "-" + String(buyerId))
        
           requestReference = Database.database().reference(withPath: "requests/")
           sellerRequestIndexReference = Database.database().reference(withPath: "sellerRequestsIndex/")
           buyerRequestIndexReference = Database.database().reference(withPath: "buyerRequestsIndex/")
           
           
           
           
           
           
       }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
//
//        get_all_requests(isHeaderIncluded: true, mode: 10){
//
//            self.requests = self.buyersRequest
//            self.tblNotification.reloadData()
//
//
//        }
//
//        get_all_requests(isHeaderIncluded: true, mode: 20){
//
//
//        }
        
        
        
        
        
    }
  
    
    
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    // return the number of rows in the specified section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      

//        return rowCount
        return self.sellerReuestArray.count
    }
    
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40.0
//    }
//    // Header Cell
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCell
//
//        headerCell.month.text = "December"
//
//        return headerCell
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tblNotification.dequeueReusableCell(withIdentifier: "RequestCell") as! RequestCell
        cell.delegate = self
        
        
        
        print("array count is here \(self.sellerReuestArray.count)")
        
        if(self.sellerReuestArray.count > 0){
              cell.setData(requestsModel:  self.sellerReuestArray[indexPath.row], position: indexPath.row)
        }
        
        
      
        
//        if(requests.count>0){
//            
//            let dict = requests[indexPath.row]
////            print("bargaining=\(dict)")
//            
//            cell.setData(data: dict)
//            cell.index = indexPath.row
//            
//        }
          
            
        
        return  cell;
    }
    
    
    @IBAction func tabBar(_ sender: UISegmentedControl) {
        
//        self.requests.removeAll()
        switch sender.selectedSegmentIndex
        {
            case 0:
                self.sellerReuestArray.removeAll()
                self.tblNotification.reloadData()
                self.getAllRequest(isSeller: true)
            RequestVC.isSeller = true
                
        
            case 1:
                self.sellerReuestArray.removeAll()
                 self.tblNotification.reloadData()
                self.getAllRequest(isSeller: false)
             RequestVC.isSeller = false
           
            default:
                break
        }
    }
    

}
