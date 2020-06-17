//
//  chatOfferCell.swift
//  PeerParking
//
//  Created by APPLE on 6/11/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class chatOfferCell: UITableViewCell {

    @IBOutlet weak var leftOfferView: CardView!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var acceptButtonView: UIButton!
      @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var rightOfferView: CardView!
       @IBOutlet weak var rightOfferLabel: UILabel!
//       @IBOutlet weak var rightAcceptButtonView: UIButton!
         @IBOutlet weak var rightDateLabel: UILabel!
    
    @IBOutlet weak var textView: CardView!
      
    
     
      

      @IBOutlet  var leadingTextConstrain: NSLayoutConstraint!
      @IBOutlet  var trailingTextConstrain: NSLayoutConstraint!
      
      @IBOutlet  var leadingDateConstrain: NSLayoutConstraint!
      @IBOutlet  var trailingDateConstrain: NSLayoutConstraint!
      
    
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }
    
    
    
    
    
    func hideLeft(isHidden : Bool){
        if(isHidden){
            leftOfferView.isHidden = true
            offerLabel.isHidden = true
//            isAcceptbuttonHide(_isHide: true)
              dateLabel.isHidden = true
        }
        else
        {
            leftOfferView.isHidden = false
            offerLabel.isHidden = false
//            isAcceptbuttonHide(_isHide: false)
              dateLabel.isHidden = false
        }
        
                   
        
    }
    
    func isAcceptbuttonHide(_isHide : Bool){
        
//        if(_isHide){
//            acceptButtonView.isHidden = true
//            acceptButtonView.superview!.isHidden = true
//            acceptButtonView.superview!.superview!.isHidden = true
//        }
//        else
//        {
//            acceptButtonView.superview!.isHidden = false
//            acceptButtonView.isHidden = false
//             acceptButtonView.superview!.superview!.isHidden = false
//        }
        
    }
    
    func hideRight(isHidden : Bool){
        if(isHidden){
            rightOfferView.isHidden = true
            rightOfferLabel.isHidden = true
           
              rightDateLabel.isHidden = true
            
            

        }
        else
        {
             rightOfferView.isHidden = false
                       rightOfferLabel.isHidden = false
                    
                         rightDateLabel.isHidden = false
            
         
        }
        
                   
        
    }
    
    func setOfferText(offer : Int , isRight : Bool){
        
        
        
        if(isRight){
                    rightOfferLabel.text = "You sent an offer of $" + String(offer)
                  hideLeft(isHidden: true)
                   hideRight(isHidden: false)
            
            
           
            
            
                 }
                 
                 else
                 {
                      offerLabel.text = "You recieved an offer of $" + String(offer)
                      hideLeft(isHidden: false)
                                hideRight(isHidden: true)
                    
                    
                     
                 }
        
   
        
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
