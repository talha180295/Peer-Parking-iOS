//
//  WalletViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 06/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import NotificationCenter
import Stripe



class WalletViewController: UIViewController {
    

   // @IBOutlet weak var someView: UIView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var balance: UILabel!
    
    var animator: UIViewPropertyAnimator?
    
    func createBottomView() {
        guard let sub = storyboard!.instantiateViewController(withIdentifier: "TransactionViewController") as? TransactionViewController else { return }
        self.addChild(sub)
        self.view.addSubview(sub.view)
        sub.didMove(toParent: self)
        
//        self.view.roundCorners(corners: <#T##UIRectCorner#>, radius: <#T##CGFloat#>)
//
//        self.view.
//        
//        sub.view.
        sub.view.roundCorners(corners: [.topLeft, .topRight], radius: 30.0)
        
       // sub.view.addShadow(location: .top, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), opacity: 1.0, radius: 25.0)
    
        sub.view.frame = CGRect(x: 15, y: view.frame.maxY-5, width: view.frame.width, height: view.frame.height)
        
        sub.view.layer.masksToBounds = false
//        sub.minimize(completion: nil)
    }
    
    func subViewGotPanned(_ percentage: Int) {
        guard let propAnimator = animator else {
            animator = UIViewPropertyAnimator(duration: 3, curve: .linear, animations: {
                self.blackView.alpha = 1
//                self.someView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).concatenating(CGAffineTransform(translationX: 0, y: -20))
            })
            animator?.startAnimation()
            animator?.pauseAnimation()
            return
        }
        propAnimator.fractionComplete = CGFloat(percentage) / 100
    }
    
    func receiveNotification(_ notification: Notification) {
    
        
        guard let percentage = notification.userInfo?["percentage"] as? Int else { return }
        if(percentage >= 90)
        {
            self.navigationController?.navigationBar.isHidden = true
        }
        else
        {
            self.navigationController?.navigationBar.isHidden = false
        }
        subViewGotPanned(percentage)
        print(percentage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.isHidden = true
        let controller = WalletContentVC.instantiate(fromPeerParkingStoryboard: .Wallet)
        addChild(controller)
//        controller.view.frame = ...  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
//        self.navigationController?.pushViewController(vc,animated: false)
//        createBottomView()
//
//        let name = NSNotification.Name(rawValue: "BottomViewMoved")
//        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: receiveNotification(_:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("wallet will appear")
        
//        getCardDetails()
    }
    
    @IBAction func addCardBtn(_ sender: UIButton) {
        
//        choosePaymentButtonTapped()
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentView")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension WalletViewController: STPAddCardViewControllerDelegate {
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
        
        print("s_token===\(token)")
    }
    
    
    func choosePaymentButtonTapped() {
        
        // 2
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        navigationController?.pushViewController(addCardViewController, animated: true)
    }
    
    func getCardDetails(){
        
        Helper().showSpinner(view: self.view)
        
        let url = APIRouter.me
        let decoder = ResponseData<Me>.self
        
        APIClient.serverRequest(url: url, path: url.getPath(), dec: decoder) { (response,error) in
            
            print(response?.data)
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if let success = response?.success {
                    
//                    Helper().showToast(message: "Success=\(success)", controller: self)
                    if let val = response?.data {
                        
                        self.balance.text = "$ \(val.details?.wallet ?? 0.0)"
                        if let cardNo = val.card?.first?.lastFour {
                            self.cardNumber.text = "**** **** **** \(cardNo)"
                        }
                        else{
                            self.cardNumber.text = "Add Card"
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
}
