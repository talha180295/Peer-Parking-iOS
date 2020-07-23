//
//  AmountPopUp.swift
//  PeerParking
//
//  Created by talha on 14/07/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

protocol AmountPopUpDelegate {
    func transactionSuccessfully();
}
class AmountPopUp: UIViewController {
    
    
    @IBOutlet weak var heading:UILabel!
    @IBOutlet weak var descp:UILabel!
    @IBOutlet weak var amountTF:UITextField!
    
    var delgate:AmountPopUpDelegate!
    var me : Me!
    
    
    var type:AmountPopUpType!
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTF.keyboardType = .decimalPad
        
        if(type == AmountPopUpType.Withdraw){
           self.heading.text = "Withdraw"
             self.descp.text = "Your account balance is $\(me.details?.wallet ?? 0.0) \n Your given price should be less than or equals to your current amount"
//
        }
        else
        {
           self.heading.text = "Top Up"
             self.descp.text = "Your account balance is $\(me.details?.wallet ?? 0.0)"
        }
        
    }
    
    
    @IBAction func sumbitBtn(_ sender:UIButton){
        
        if validate(){
            switch type {
            case .Withdraw:
                self.heading.text = "Withdraw"
                 topUp(params: ["amount": Double(amountTF.text!) ?? 0.0],isWithdraw: true)
                break
            case .Topup:
                self.heading.text = "Top Up"
                topUp(params: ["amount": Double(amountTF.text!) ?? 0.0])
            default:
                break
            }
        }
    }
    
    func validate() -> Bool{
        
        if amountTF.hasText{
            return true
        }
        return false
    }
    
    func topUp(params:[String:Any], isWithdraw : Bool = false){
        
        Helper().showSpinner(view: self.view)
        let request = isWithdraw ?  APIRouter.withdraw(params): APIRouter.chargeCard(params)
        APIClient.serverRequest(url: request, path: request.getPath(),body: params, dec: PostResponseData.self) { (response, error) in
            
            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if (response?.success) != nil {
                    
                    
                    Helper().showToast(message: response?.message ?? "-", controller: self)
                    
                    self.dismiss(animated: true) {
                        self.delgate.transactionSuccessfully()
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
    
}


enum AmountPopUpType:Int{
    
    case Withdraw
    case Topup
}
