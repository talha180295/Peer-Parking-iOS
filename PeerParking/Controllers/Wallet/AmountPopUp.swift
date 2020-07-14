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
    
    var type:AmountPopUpType!
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTF.keyboardType = .decimalPad
        
    }
    
    
    @IBAction func sumbitBtn(_ sender:UIButton){
        
        if validate(){
            switch type {
            case .Withdraw:
                break
            case .Topup:
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
    
    func topUp(params:[String:Any]){
        
        let request = APIRouter.chargeCard(params)
        APIClient.serverRequest(url: request, path: request.getPath(),body: params, dec: PostResponseData.self) { (response, error) in
            
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
