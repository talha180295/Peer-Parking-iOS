//
//  WalletContentView.swift
//  PeerParking
//
//  Created by talha on 10/07/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import XLPagerTabStrip


protocol TopupVCDelegate {
    func reloadBlance()
}

class WalletContentVC:  ButtonBarPagerTabStripViewController{
    
    
    
    @IBOutlet weak var balance: UILabel!
    //Child ViewConrtrollers
    let child_1 = WithdrawVC.instantiate(fromPeerParkingStoryboard: .Wallet)
    let child_2 = TopupVC.instantiate(fromPeerParkingStoryboard: .Wallet)
    
    
    
    //    let blueInstagramColor = UIColor(red: 37/255.0, green: 111/255.0, blue: 206/255.0, alpha: 1.0)
    let blueInstagramColor = UIColor(named: "themeBlue")
    
    override func viewDidLoad() {
        
        setupTopBar()
        
        super.viewDidLoad()
        
        child_2.delegate = self
        child_1.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCardDetails()
    }
    
    
    func setupTopBar(){
        
        // change selected bar color
        
        settings.style.buttonBarBackgroundColor = .lightGray
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = blueInstagramColor!
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = self?.blueInstagramColor
        }
        
    }
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        return [self.child_1, self.child_2]
    }
    
    
    
    
    @IBAction func onTap(_ sender:UIButton){
        
        let vc = TransactionViewController.instantiate(fromPeerParkingStoryboard: .Main)
        Helper().bottomSheet(controller: vc, sizes: [.fullScreen], cornerRadius: 0, handleColor: .clear, view_controller: self)
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
                        
                        self.balance.text = "$ \(val.details?.wallet ?? 0.0)"
//                        if let cardNo = val.card?.first?.lastFour {
//                            self.topUpCard = "**** **** **** \(cardNo)"
//                        }
//                        else{
//                            self.topUpCard = "Add Card"
//                        }
                        
//                        let cards:[Card] = val.card ?? [Card]()
//                        for card in cards {
//
//                            switch card.type {
//                            case CardType.WITHDRAW_CARD:
//                                if let cardNo = val.card?.first?.lastFour {
//                                    self.withdarwCard = "**** **** **** \(cardNo)"
//                                    //                                  cardBrnd.setText(card.getBrand());
//                                }
//                                else{
//                                    self.withdarwCard = "Add Card"
//                                }
//                            case CardType.TOP_UP_CARD:
//                                if let cardNo = val.card?.first?.lastFour {
//                                    self.topUpCard = "**** **** **** \(cardNo)"
//                                    //                                    cardBrnd.setText(card.getBrand());
//                                }
//                                else{
//                                    self.topUpCard = "Add Card"
//                                }
//                            default:
//                                break
//                            }
//
//                        }
                        
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
    
}

extension WalletContentVC:TopupVCDelegate{
    func reloadBlance() {
        getCardDetails()
    }
    
    
}
