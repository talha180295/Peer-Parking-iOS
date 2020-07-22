//
//  PaymentView.swift
//  PeerParking
//
//  Created by Apple on 22/01/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class PaymentView: UIViewController,STPPaymentCardTextFieldDelegate {
    
    
    @IBOutlet weak var myView: UIView!
    
    var paymentType:AmountPopUpType = .Topup
    
    lazy var cardTextField: STPPaymentCardTextField = {
        let cardTextField = STPPaymentCardTextField()
        return cardTextField
    }()
    lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(named: "themeBlue")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.setTitle("Add Card", for: .normal)
        button.addTarget(self, action: #selector(pay), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [cardTextField, payButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        myView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalToSystemSpacingAfter: myView.leftAnchor, multiplier: 2),
            myView.rightAnchor.constraint(equalToSystemSpacingAfter: stackView.rightAnchor, multiplier: 2),
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: myView.topAnchor, multiplier: 2),
        ])
    }
    
    @objc
    func pay() {
        Helper().showSpinner(view: self.view)
        let cardParams = STPCardParams()
        cardParams.number = cardTextField.cardNumber
        cardParams.expMonth = (cardTextField.expirationMonth)
        cardParams.expYear = (cardTextField.expirationYear)
        cardParams.cvc = cardTextField.cvc
        cardParams.currency = "usd"
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                // Present error to user...
                Helper().hideSpinner(view: self.view)
                Helper().showToast(message: error?.localizedDescription ?? "Error nil", controller: self)
                return
            }
            //            self.dictPayData["stripe_token"] = token.tokenId
            print(token.tokenId)
            
            print(UserDefaults.standard.string(forKey: APP_CONSTANT.ACCESSTOKEN) ?? "")
            
            //post: user_card
            
            let params = ["stripeToken" : token.tokenId, "currency" : "usd"]
            
            switch self.paymentType{
            case .Topup:
                self.addUserCard(params: params)
            case .Withdraw:
                self.addExternalCard(params: params)
                
            }
            
        }
    }
    
    
    func addUserCard(params:[String:Any]){
        
        Helper().RefreshToken { response in
            
            print(response)
            if response.result.value == nil {
                print("No response")
                
                return
            }
            else{
                
                Alamofire.request(APIRouter.addUserCard(params)).responsePost{ response in
                    
                    Helper().hideSpinner(view: self.view)
                    switch response.result {
                        
                    case .success:
                        if response.result.value?.success ?? false{
                            
                            
                            Helper().showToast(message: response.result.value?.message ?? "-", controller: self)
                            
                            
                            
                        }
                        else{
                            print("Server Message=\(response.result.value?.message ?? "-" )")
                            
                            // your code here
                            Helper().showToast(message: response.result.value?.message ?? "-", controller: self)
                            
                            
                            
                        }
                        
                    case .failure(let error):
                        print("ERROR==\(error)")
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.sideMenuController?.performSegue(withIdentifier: "WalletVC", sender: nil)
                    }
                }
                
            }
            
        }
    }
    
    
    func addExternalCard(params:[String:Any]){
        
        Helper().RefreshToken { response in
            
            print(response)
            if response.result.value == nil {
                print("No response")
                
                return
            }
            else{
                
                Alamofire.request(APIRouter.addExternalCard(params)).responsePost{ response in
                    
                    Helper().hideSpinner(view: self.view)
                    switch response.result {
                        
                    case .success:
                        if response.result.value?.success ?? false{
                            
                            
                            Helper().showToast(message: response.result.value?.message ?? "-", controller: self)
                            
                        }
                        else{
                            print("Server Message=\(response.result.value?.message ?? "-" )")
                            
                            Helper().showToast(message: response.result.value?.message ?? "-", controller: self)
                            
                            
                        }
                        
                    case .failure(let error):
                        print("ERROR==\(error)")
                        Helper().showToast(message: error.localizedDescription, controller: self)
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.sideMenuController?.performSegue(withIdentifier: "WalletVC", sender: nil)
                    }
                }
                
            }
            
            
        }
    }
}
