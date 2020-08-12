//
//  ReportViewController.swift
//  PeerParking
//
//  Created by APPLE on 8/11/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import MBRadioCheckboxButton
class ReportViewController: UIViewController , UITextViewDelegate {

    @IBOutlet weak var radioButtonSpam: RadioButton!
    @IBOutlet weak var radioButtonMissInfo: RadioButton!
    @IBOutlet weak var rradoadioButtonChat: RadioButton!
    @IBOutlet weak var radioButtonContent:RadioButton!
    @IBOutlet weak var radioButtonOthers:RadioButton!
    
    var parking : Parking!
    var reasonCode : Int = 10
   
//    @IBOutlet weak var descriptionReport: UITextField!
    @IBOutlet weak var descriptionReport: UITextView!
    var group3Container = RadioButtonContainer()
    override func viewDidLoad() {
        super.viewDidLoad()

        group3Container.addButtons([radioButtonSpam, radioButtonMissInfo, rradoadioButtonChat,radioButtonContent,radioButtonOthers])
        
        group3Container.selectedButtons = [radioButtonSpam]
        
        descriptionReport.delegate = self
        descriptionReport.text = "Description"
        descriptionReport.textColor = UIColor.lightGray
     
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionReport.textColor == UIColor.lightGray {
            descriptionReport.text = ""
            descriptionReport.textColor = UIColor.black
        }
    }
   
    @IBAction func radioButtonClicked(_ sender: RadioButton) {
    
//        print(sender.accessibilityIdentifier)
        switch sender.accessibilityIdentifier {
        case "0":
            reasonCode = 10
            break
            case "1":
            reasonCode = 20
            break
            case "2":
            reasonCode = 30
            break
            case "3":
            reasonCode = 40
            break
            case "4":
            reasonCode = 50
            break
        default:
            reasonCode = 10
            break
        }
//        if(sender.)
        
    }
    @IBAction func reportButtonAction(_ sender: Any) {
        
        self.reportParking()
//        print(group3Container.tag)
        
    }
    
    func reportParking(){
        
        let buyerParkingSendingModel = ParkingReportModel.init(reason: reasonCode, parking_id: parking.id!, description: self.descriptionReport.text!,parking_type : self.parking.parkingType)
        do{
            let data = try JSONEncoder().encode(buyerParkingSendingModel)
             Helper().showSpinner(view: self.view)
            
            let request = APIRouter.reportParking(data)
            APIClient.serverRequest(url: request, path: request.getPath(),body: buyerParkingSendingModel.dictionary ?? [:], dec: PostResponseData.self) { (response, error) in
                
                Helper().hideSpinner(view: self.view)
                if(response != nil){
                    if (response?.success) != nil {
                        
                        
                        Helper().showToast(message: response?.message ?? "-", controller: self)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
                           // Code you want to be delayed
                            self.dismiss(animated: true, completion: nil)

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
             Helper().hideSpinner(view: self.view)
            print("Error", parsingError)
            
        }
        
    }
}
