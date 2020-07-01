//
//  chatOfferCell.swift
//  PeerParking
//
//  Created by APPLE on 6/11/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit



protocol chatOfferCellDelegate{
    
    func acceptButton(index : Int)
    
}



class chatOfferCell: UITableViewCell {
        @IBOutlet weak var leftButtonView: UIView!
    @IBOutlet weak var leftOfferView: CardView!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var leftacceptButton: UIButton!
      @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var rightOfferView: CardView!
       @IBOutlet weak var rightOfferLabel: UILabel!
//       @IBOutlet weak var rightAcceptButtonView: UIButton!
         @IBOutlet weak var rightDateLabel: UILabel!
    
    @IBOutlet weak var textView: CardView!
    
    var index : Int!
    
    var delegate : chatOfferCellDelegate!
      
    
     
      

      @IBOutlet  var leadingTextConstrain: NSLayoutConstraint!
      @IBOutlet  var trailingTextConstrain: NSLayoutConstraint!
      
      @IBOutlet  var leadingDateConstrain: NSLayoutConstraint!
      @IBOutlet  var trailingDateConstrain: NSLayoutConstraint!
      
    
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }
    
    
    
    
    @IBAction func acceptOfferButtonAction(_ sender: Any) {
        
        
        
        delegate.acceptButton(index: self.index)
        
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
    
    func setOfferText(offer : Double , date : String , isRight : Bool,offerStatus:Int){
        
        
        
        
        
        if(isRight){
            
            
            rightOfferLabel.text = offerStatus == 10 ? "This offer of $" + String(offer) + " has been accepted" : "You sent an offer of $" + String(offer)
            rightDateLabel.text = date
            
             
                  hideLeft(isHidden: true)
                   hideRight(isHidden: false)
           
            
           
            
            
                 }
                 
                 else
                 {
                      offerLabel.text = offerStatus == 10 ? "This offer of $" + String(offer) + " has been accepted" : "You recieved an offer of $" + String(offer)
                    dateLabel.text =  date
                    
                    if(offerStatus == 10) {


                       leftacceptButton.isHidden = true
                        leftacceptButton.superview?.isHidden = true
                        
                               
                    }
                    
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
