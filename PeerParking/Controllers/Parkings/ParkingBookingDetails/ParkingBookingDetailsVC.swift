//
//  ParkingBookingDetailsVC.swift
//  PeerParking
//
//  Created by haya on 18/06/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import Cosmos

class ParkingBookingDetailsVC: UIViewController {
    
//    var viewModel:ParkingBookingDetailsViewModel!
    var parkingModel:Parking = Parking()
    
    //Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var subType: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var userType: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
    
    @IBOutlet weak var btnCardView: CardView!
    @IBOutlet weak var navigateBtn: UIButton!
    @IBOutlet weak var parkNowBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Parking Booking Details"
        self.setData(data: self.parkingModel)
        
        
        self.setLiveLocationReceivingService(parkingId: 611)
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func navigateBtnClick(_sender:UIButton){
        
        let buyerParkingSendingModel = BuyerParkingSendingModel.init(status: 20, endAt: "currentDateandTime")
        print("buyerParkingSendingModel= \(buyerParkingSendingModel.dictionary ?? [:])")
        
        
        
//        var service : LiveLocationReceivingService =  LiveLocationReceivingService(parkingId: String(self.parkingModel.id ?? 0))
        
        
        
        
        if (parkingModel.sellerID == Helper().getCurrentUserId()) {
            
//            self.navigateBtn.setTitle("Track buyer", for: .normal)
            if (parkingModel.status == APP_CONSTANT.STATUS_PARKING_BOOKED) {
                Helper().showToast(message: "Buyer has not started navigation yet", controller: self)
            } else {
                openMapScreen(isTracking: true, isBuyerNavigating: false)
            }
            
            
        } else {
//            self.userType.text = "Seller Information"
//             openMapScreen();
            openMapScreen(isTracking: false, isBuyerNavigating: true)
           
        }
        
        
    }
//    func setParingModel(parkingModel:Parking){
//        self.parkingModel = parkingModel
//    }
    
    func openMapScreen(isTracking:Bool,isBuyerNavigating:Bool){
        let vc = ParkingNavVC.instantiate(fromPeerParkingStoryboard: .Main)
        
        vc.modalPresentationStyle = .fullScreen
        vc.isTracking = isTracking
        vc.isBuyerNavigating = isBuyerNavigating
        vc.parkingModel = self.parkingModel
        vc.vcName = "track"
//        vc.p_title = ""
//        vc.d_lat = Double(parkingModel.latitude ?? "0.0") ?? 0.0
//        vc.d_longg = Double(parkingModel.longitude ?? "0.0") ?? 0.0
//        vc.s_lat = self.lat
//        vc.s_longg = self.longg
        
//        vc.p_lat = d_lat
//        vc.p_longg = d_longg
       
//        vc.alternateRoutes = alternateRoutes
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func parkNowBtnClick(_sender:UIButton){
        
        let alert = UIAlertController(title: "Alert!", message: "Do you really want to park?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
            self.setParkingStatus(status: APP_CONSTANT.STATUS_PARKING_PARKED)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        //        btnParkNow.setOnClickListener(new View.OnClickListener() {
        //            @Override
        //            public void onClick(View v) {
        //
        //                new AlertDialog.Builder(getContext()).
        //                setTitle("Alert").
        //                setMessage("Do you really want to park?").
        //                setPositiveButton("Yes", new DialogInterface.OnClickListener() {
        //                    @Override
        //                    public void onClick(DialogInterface dialog, int which) {
        //
        //                        dialog.dismiss();
        //                        setParkingStatus(AppConstants.STATUS_PARKING_PARKED);
        //
        //                    }
        //                }).setNegativeButton("No", new DialogInterface.OnClickListener() {
        //                    @Override
        //                    public void onClick(DialogInterface dialog, int which) {
        //                        dialog.dismiss();
        //
        //
        //                    }
        //                }).setCancelable(false).show();
        //
        //            }
        //
        //        });
    }
    @IBAction func chatBtnClick(_sender:UIButton){
        openChatScreen(model:parkingModel)
        
        
    }
    @IBAction func cancelBtnClick(_sender:UIButton){
        showCancelParkingConfirmationDialog()
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
        
    }
    
    func openChatScreen(model : Parking){
           
           
           let vc = ChatVC.instantiate(fromPeerParkingStoryboard: .Chat)
                  
                  vc.modalPresentationStyle = .fullScreen
                  
                  vc.parking_details = model
                  
                  self.present(vc, animated: true, completion: nil)
       }
    
    
}

//Data Methods
extension ParkingBookingDetailsVC{
    
    func setData(data:Parking){
        
        let imgUrl = data.imageURL
        
        self.image.sd_setImage(with: URL(string: imgUrl ?? ""),placeholderImage: UIImage.init(named: "placeholder-img") )
        self.address.text = data.address ?? "-"
        self.ratingView.rating = data.seller?.details?.averageRating ?? 0.0
        self.subType.text = data.vehicleTypeText ?? "-"
        self.price.text = "$\(data.finalPrice ?? 0.0)"
        
        
        if (data.status == APP_CONSTANT.STATUS_PARKING_PARKED ||
            data.status == APP_CONSTANT.STATUS_PARKING_CANCEL ) {
            
            self.btnCardView.isHidden = true
            self.navigateBtn.isHidden = true
            self.cancelBtn.isHidden = true
            self.chatBtn.isHidden = true
            self.parkNowBtn.isHidden = true
            //            btnNavigate.setVisibility(View.GONE);
            //            btnCancel.setVisibility(View.GONE);
            //            btnChat.setVisibility(View.GONE);
            //            btnParkNow.setVisibility(View.GONE);
        }
        if (data.sellerID == Helper().getCurrentUserId()) {
            
            self.navigateBtn.setTitle("Track buyer", for: .normal)
            self.parkNowBtn.isHidden = true
            self.userType.text = "Buyer's Information"
            
            if(data.buyer != nil)
            {
                self.name.text = data.buyer?.details?.fullName ?? "-"
                self.number.text = data.buyer?.details?.phone == "string" ? "-" : data.buyer?.details?.phone ?? "-"
            print("phone number is \(data.buyer?.details?.phone)")
            }
            
            
            //          btnNavigate.setText("Track buyer");
            //          btnParkNow.setVisibility(View.GONE);
            //          infoTxtView.setText("Buyer Information");
            //            if (data.buyer != nil) {
            //                self.name.text = data.buyer?.details?.fullName ?? "-"
            //                self.number.text = data.buyer?.details?.phone ?? "-"
            //                //              txtViewBuyerName.setText(parkingModel1.getBuyerMdoel().getDetails().getFullName());
            //                //              txtViewBuyerNumber.setText(parkingModel1.getBuyerMdoel().getDetails().getPhone());
            //            }
        } else {
            self.userType.text = "Seller Information"
            //          infoTxtView.setText("Seller Information");
            if (data.seller != nil) {
                self.name.text = data.seller?.details?.fullName ?? "-"
                self.number.text = data.seller?.details?.phone == "string" ? "-" : data.seller?.details?.phone ?? "-"
                //              txtViewBuyerName.setText(parkingModel1.getSellerMdoel().getDetails().getFullName());
                //              txtViewBuyerNumber.setText(parkingModel1.getSellerMdoel().getDetails().getPhone());
            }
        }
        
    }
    
    
    private func showCancelParkingConfirmationDialog() {
        
        let alert = UIAlertController(title: "Alert!", message: "Do you really want to cancel?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
            self.cancelBuyerParking()
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    public func cancelBuyerParking() {
        
        if (self.parkingModel == nil) {
            
            return
        }
        var request:APIRouter!
        
        if (isSeller()) {
            request = APIRouter.cancelSellerParking(id: self.parkingModel.id ?? -1)
        } else {
            request = APIRouter.cancelBuyerParking(id: self.parkingModel.id ?? -1)
        }
        
        Helper().showSpinner(view: self.view)
        
        APIClient.serverRequest(url: request, path: request.getPath(),body:nil, dec: PostResponseData.self) { (response, error) in
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if (response?.success) != nil {
                    Helper().showToast(message: response?.message ?? "-", controller: self)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        Helper().presentOnMainScreens(controller: self, index: 0)
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
        
        
//        getBaseWebServices(true).postAPIAnyObject(cancelUrl + parkingModel1.getId(), "", new WebServices.IRequestWebResponseAnyObjectCallBack() {
//            @Override
//            public void requestDataResponse(WebResponse<Object> webResponse) {
//                if (webResponse.isSuccess()) {
//                    FirebaseUtils.deleteChatAndRequests(parkingModel1);
//                    getHomeActivity().setBackPressedListener(null);
//                    Toast.makeText(getContext(), webResponse.message, Toast.LENGTH_LONG).show();
//                    getHomeActivity().popStackTill(1);
//                }
//
//            }
//
//            @Override
//            public void onError(Object object) {
//
//            }
//        });
    }
    
    private func isSeller() -> Bool{
        return self.parkingModel != nil && self.parkingModel.sellerID == Helper().getCurrentUserId()
    }
    private func setParkingStatus(status:Int) {
        
        //        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
        //
        //        String currentDateandTime = sdf.format(new Date());
        //
        let currentDateandTime = Date().description(with: .current)
        let buyerParkingSendingModel = BuyerParkingSendingModel.init(status: status, endAt: currentDateandTime)
        do{
            let data = try JSONEncoder().encode(buyerParkingSendingModel)
            
            let request = APIRouter.assignBuyer(id: self.parkingModel.id!, data)
            APIClient.serverRequest(url: request, path: request.getPath(),body: buyerParkingSendingModel.dictionary ?? [:], dec: PostResponseData.self) { (response, error) in
                
                if(response != nil){
                    if (response?.success) != nil {
                        
                        
                        Helper().showToast(message: response?.message ?? "-", controller: self)
                        
                        Helper.deleteChatAndRequests(parkingModel1: self.parkingModel)
                        
                        //FirebaseUtils.deleteChatAndRequests(parkingModel1);
                        if (status == APP_CONSTANT.STATUS_PARKING_PARKED) {
                            self.parkingModel.status = APP_CONSTANT.STATUS_PARKING_NAVIGATING
                            //((HomeActivity) getActivity()).popStackTill(1);
                            let vc = FeedbackVC.instantiate(fromPeerParkingStoryboard: .Main)
                            vc.parking_details = self.parkingModel
                            vc.p_id = self.parkingModel.id
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true)
                            
                            self.sendNotification(actionType: APP_CONSTANT.BUYER_REACHED, message: APP_CONSTANT.BUYER_REACHED_MESSAGE, refId: String(self.parkingModel.id ?? -1))
                            
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
        catch let parsingError {
            
            print("Error", parsingError)
            
        }
    }
    
    private func sendNotification(actionType : String , message : String , refId : String) {
        
        var model:NotificationSendingModel = NotificationSendingModel()
        model.refId = refId
        model.recieverId = Int(self.parkingModel.sellerID ?? -1)
        model.actionType = actionType
        model.message = message
 
        do{
            let data = try JSONEncoder().encode(model)
            Helper.customSendNotification(data: data, controller: self,isDismiss: false)
        }
        catch let parsingError {
            
            print("Parsing Error", parsingError)
            
        }
    }
}


//Buyer Location Reciever
extension ParkingBookingDetailsVC:LiveLocationReceivingServiceDeleegate{
    
    //Callback
    func updateLocation(latitude: Double?, longitude: Double?) {
        print("latititude \(latitude ?? 0.0)")
        print("longitude \(longitude ?? 0.0)")
    }
    
    //Start Service
    func setLiveLocationReceivingService(parkingId:Int){
        // replace 611 to origional parking id
        
        let service : LiveLocationReceivingService =  LiveLocationReceivingService(parkingId: String(parkingId))
        service.delegate = self
        
    }
    
    func setLiveLocationSendingService(parkingId:Int){
        
        //        var sendingservice : LiveLocationSendingService =  LiveLocationSendingService(parkingId: String(612))
        //
        //        // replace lat long wit clllocation manager and pass current actual location
        //
        //        sendingservice.setBuyerCurrentLocation(lat: 24.9472804, long: 67.1057191) { parking  in
        //
        //            print("sending latititude \(parking.latitude)")
        //            print("sending longitude \(parking.longitude)")
        //
        //        }
    }
    
}


