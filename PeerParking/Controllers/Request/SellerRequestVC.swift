//
//  SellerRequestVC.swift
//  PeerParking
//
//  Created by APPLE on 7/1/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import FirebaseDatabase
import Firebase
import FirebaseCore
import CodableFirebase
class SellerRequestVC: UIViewController ,IndicatorInfoProvider ,  ViewOfferProtocol ,UITableViewDataSource,UITableViewDelegate  {
    
    
    @IBOutlet weak var sellerRequestTbl: UITableView!
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        sellerRequestTbl.register(UINib(nibName: "RequestCell", bundle: nil), forCellReuseIdentifier: "RequestCell")
          print("did load print")
        
        self.getUpdatedWalletAmount()
        
        initial()
        
        
    }
    
    
    
    
    func initial(){
        
        
        //        RequestVC.isSeller =  true
        
        makeReferences()
        getAllRequest()
        
        
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
    
    func getAllRequest() {
        
        
        var ref  : DatabaseReference! =  sellerRequestIndexReference
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
    
    func getRequest(){
        
        //        self.sellerReuestArray.removeAll()
        
        let sorted = self.dict.sorted {$0.value > $1.value}
        
        
        sorted.forEach { (id1) in
            
            var ref = requestReference.child(id1.key)
            
            
            ref.observeSingleEvent(of : .value) { (snapshot) in
                
                
                
                do {
                    let model = try FirebaseDecoder().decode(FirebaseRequestModel.self, from: snapshot.value)
                    
                    self.sellerReuestArray.append(model)
                    self.sellerRequestTbl.reloadData()
                    
                    
                    
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
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.sellerRequestTbl.reloadData()
        //
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.getFilters(notification:)), name: NSNotification.Name(rawValue: "mode_filter"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //       NotificationCenter.default.removeObserver(self)
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: "SELLER", accessibilityLabel: "SELLER", image: UIImage(named: "upcomingUn"), highlightedImage: UIImage(named: "upcoming"), userInfo: nil)
    }
    
    
    //    func getMyPrivateSpots(params:[String:Any]){
    //
    //        Helper().showSpinner(view: self.view)
    //        self.privateSpotModel.removeAll()
    //        self.privateSpotsParkingTbl.reloadData()
    //
    //        APIClient.serverRequest(url: APIRouter.getPrivateParkings(params), path: APIRouter.getPrivateParkings(params).getPath(), dec: ResponseData<[PrivateParkingModel]>.self) { (response, error) in
    //            Helper().hideSpinner(view: self.view)
    //            if(response != nil){
    //                if (response?.success) != nil {
    ////                    Helper().showToast(message: response?.message ?? "-", controller: self)
    //                    if let val = response?.data {
    //
    //                        self.privateSpotModel = val
    //                        self.privateSpotsParkingTbl.reloadData()
    //                    }
    //                }
    //                else{
    //                    Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
    //                }
    //            }
    //            else if(error != nil){
    //                Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
    //            }
    //            else{
    //                Helper().showToast(message: "Nor Response and Error!!", controller: self)
    //            }
    //
    //
    //        }
    //    }
    
    
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
                        
                        var  firebaseChatReference = Database.database().reference(withPath: "chat/").child(String(model.parkingID!)).child(String(model.buyerID!))
                        
                        var lastMessage = model.lastMessage
                        
                        let lastMessage_dict = try! FirebaseEncoder().encode(lastMessage)
                        firebaseChatReference.child(lastMessage!.id ?? "" ).setValue(lastMessage_dict);
                        self.requestReference = Database.database().reference(withPath: "requests/").child(String(model.parkingID!) + "-" + String(model.buyerID!))
                        
                        let request_dict = try! FirebaseEncoder().encode(model)
                        
                        self.requestReference.setValue(request_dict)
                        
                        
                        var  parkingReference = Database.database().reference(withPath: "chat/").child(String(model.parkingID!))
                        
                        parkingReference.child("buyer_id").setValue(model.buyerID!)
                        
                        parkingReference.child("status").setValue(APP_CONSTANT.STATUS_PARKING_BOOKED)
                        
                        
                        var parkingModel : Parking = Parking()
                        parkingModel.id = model.parkingID
                        parkingModel.buyerID = model.buyerID
                        
                        self.sellerRequestTbl.reloadData()
                        
                        Helper.removeRequestsOfAllOtherBuyers(parkingModel1: parkingModel, buyersList: buyersList)
                        
                        let refId = String(model.parkingID ?? -1) + "-" + String(model.buyerID ?? -1)
                        
                        let actionType = APP_CONSTANT.ACTION_PARKING_REQUEST
                        self.sendNotification(actionType: actionType,message: "You have a parking request.",refId: refId,  model );
                        
                        
                        
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
    
    private func sendNotification(actionType : String , message : String , refId : String , _ requestModel : FirebaseRequestModel) {
        
        var model:NotificationSendingModel = NotificationSendingModel()
        model.refId = refId
        model.recieverId =  Helper().getCurrentUserId() ==  Int(requestModel.sellerID ?? 0) ?  Int(requestModel.buyerID ?? 0) : Int(requestModel.sellerID ?? 0)
        model.actionType = actionType
        model.message = message
        
        do{
            let data = try JSONEncoder().encode(model)
            Helper.customSendNotification(data: data, controller: self)
        }
        catch let parsingError {
            
            print("Parsing Error", parsingError)
            
        }
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        //        return rowCount
        return self.sellerReuestArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = sellerRequestTbl.dequeueReusableCell(withIdentifier: "RequestCell") as! RequestCell
        cell.delegate = self
        
        
        
        print("array count is here \(self.sellerReuestArray.count)")
        
        if(self.sellerReuestArray.count > 0){
            cell.setData(requestsModel:  self.sellerReuestArray[indexPath.row], position: indexPath.row)
        }
        
        
        
        
        return  cell;
    }
    
    
    
}




