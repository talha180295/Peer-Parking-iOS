//
//  TopupVC.swift
//  PeerParking
//
//  Created by talha on 10/07/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import EzPopup

protocol TopupVCDelegate {
    func reloadBlance()
}
class TopupVC: UIViewController,IndicatorInfoProvider {
    
    @IBOutlet weak var topUpCardNumber: UILabel!
    
    var hasCard = false
    var delegate:TopupVCDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        
                        
                        
                        let cards:[Card] = val.card ?? [Card]()
                        for card in cards {
                            
                            switch card.type {
                            
                            case CardType.TOP_UP_CARD:
                                if let cardNo = val.card?.first?.lastFour {
                                    self.topUpCardNumber.text = "**** **** **** \(cardNo)"
                                    self.hasCard = true
                                    //                                    cardBrnd.setText(card.getBrand());
                                }
                                else{
                                    self.topUpCardNumber.text = "Add Card"
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
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        NotificationCenter.default.removeObserver(self)
    //    }
    //
    
    //    @objc func getCard(notification: NSNotification) {
    //
    //        if let dict = notification.userInfo as NSDictionary? {
    //
    //            if let card = dict.value(forKey: "card"){
    //
    //                self.topUpCardNumber.text = card as? String
    //            }
    //        }
    //    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Topup")
//        return IndicatorInfo(title: "Topup", accessibilityLabel: "Topup", image: UIImage(named: "historyUn"), highlightedImage: UIImage(named: "history"), userInfo: nil)
    }
    
    @IBAction func topupBtnClick(_ sender:UIButton){
        
        if !self.hasCard{
            Helper().showToast(message: "Add Card Firt!", controller: self)
            return
        }
        let vc = AmountPopUp.instantiate(fromPeerParkingStoryboard: .Wallet)
        vc.type = .Topup
        vc.delgate = self
        Helper().popUp(controller: vc, view_controller: self, popupWidth: 300, popupHeight: 300)
    }
    
    @IBAction func addCardBtn(_ sender: UIButton) {
        
        //        choosePaymentButtonTapped()
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentView")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension TopupVC:AmountPopUpDelegate{
    func transactionSuccessfully() {
        self.delegate.reloadBlance()
    }
}
