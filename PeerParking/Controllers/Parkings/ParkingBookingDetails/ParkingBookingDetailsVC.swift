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
    private var parkingModel:Parking!
    
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
    }
    
    @IBAction func navigateBtnClick(_sender:UIButton){
        
        let buyerParkingSendingModel = BuyerParkingSendingModel.init(status: 20, endAt: "currentDateandTime")
        print("buyerParkingSendingModel= \(buyerParkingSendingModel.dictionary ?? [:])")
        //        if (parkingModel1.getSellerId() == getCurrentUser().getId()) {
        //            if (parkingModel1.getStatus() == AppConstants.STATUS_PARKING_BOOKED) {
        //                Toast.makeText(getContext(), "Buyer has not started navigation yet", Toast.LENGTH_LONG).show();
        //            } else {
        //                openMapScreen();
        //            }
        //        } else {
        //            openMapScreen();
        //        }
        
    }
    func setParingModel(parkingModel:Parking){
        self.parkingModel = parkingModel
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
            self.name.text = data.buyer?.details?.fullName ?? "-"
            self.number.text = data.buyer?.details?.phone ?? "-"
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
                self.number.text = data.seller?.details?.phone ?? "-"
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
                        //FirebaseUtils.deleteChatAndRequests(parkingModel1);
                        if (status == APP_CONSTANT.STATUS_PARKING_PARKED) {
                            self.parkingModel.status = APP_CONSTANT.STATUS_PARKING_NAVIGATING
                            //((HomeActivity) getActivity()).popStackTill(1);
                            let vc = FeedbackVC.instantiate(fromPeerParkingStoryboard: .Main)
                            vc.parking_details = self.parkingModel
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
            Helper.customSendNotification(data: data, controller: self)
        }
        catch let parsingError {
            
            print("Parsing Error", parsingError)
            
        }
    }
}
