//
//  WithdrawVC.swift
//  PeerParking
//
//  Created by talha on 10/07/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

import XLPagerTabStrip


class WithdrawVC: UIViewController,IndicatorInfoProvider {
    
    @IBOutlet weak var withdrawCardNumber: UILabel!
    var hasCard = false
    var me : Me!
    
    var delegate:TopupVCDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        getCardDetails()
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.getCard(notification:)), name: NSNotification.Name(rawValue: "topUpCard"), object: nil)
        
        getCardDetails()
    }
    
    func getCardDetails(){
        
        Helper().showSpinner(view: self.view)
        
        let url = APIRouter.me
        let decoder = ResponseData<Me>.self
        
        APIClient.serverRequest(url: url, path: url.getPath(), dec: decoder) { (response,error) in
            
            //            print(response?.data)
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if (response?.success) != nil {
                    
                    //                    Helper().showToast(message: "Success=\(success)", controller: self)
                    if let val = response?.data {
                        
                        
                        self.me = val
                        let cards:[Card] = val.card ?? [Card]()
                        for card in cards {
                            
                            switch card.type {
                                
                            case CardType.WITHDRAW_CARD:
                                
                                

                                if let cardNo = card.lastFour {
                                    self.withdrawCardNumber.text = "**** **** **** \(cardNo)"
                                    self.hasCard = true
                                    //                                    cardBrnd.setText(card.getBrand());
                                }
                                else{
                                    self.withdrawCardNumber.text = "Add Card"
                                    self.hasCard = false
                                }
                            default:
                                break
                            }
                            
                        }
                        
                        
                    }
                }
                else{
                    Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                }
            }
            else if(error != nil){
                Helper().showToast(message: "\(error?.localizedDescription ?? "" )", controller: self)
            }
            else{
                Helper().showToast(message: "Nor Response and Error!!", controller: self)
            }
            
        }
        
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: "WITHDRAW")
        //        return IndicatorInfo(title: "Withdraw", accessibilityLabel: "Withdraw", image: UIImage(named: "historyUn"), highlightedImage: UIImage(named: "history"), userInfo: nil)
    }
    
 
    @IBAction func withdrawBtnClick(_ sender:UIButton){
        
        
        if !self.hasCard{
            Helper().showToast(message: "Add Card Firt!", controller: self)
            return
        }
        
        let vc = AmountPopUp.instantiate(fromPeerParkingStoryboard: .Wallet)
        vc.type = .Withdraw
        vc.delgate = self
        vc.me = me
        Helper().popUp(controller: vc, view_controller: self, popupWidth: 300, popupHeight: 300)
    }
    
    @IBAction func addCardBtn(_ sender: UIButton) {
        
        //        choosePaymentButtonTapped()
        
        let vc = PaymentView.instantiate(fromPeerParkingStoryboard: .Main)
        vc.paymentType = .Withdraw
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension WithdrawVC:AmountPopUpDelegate{
    func transactionSuccessfully() {
        self.delegate.reloadBlance()
    }
}
