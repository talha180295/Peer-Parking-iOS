//
//  RequestCell.swift
//  PeerParking
//
//  Created by Apple on 07/11/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import FittedSheets


protocol ViewOfferProtocol {
    func ViewOfferButtonDidSelect(index:Int)
}

class RequestCell: UITableViewCell {

    var index:Int!
    
    @IBOutlet weak private var date: UILabel!
    
    @IBOutlet weak private var address: UILabel!
    
    @IBOutlet weak private var directionText: UILabel!
    
    @IBOutlet weak private var price: UILabel!
    
    var delegate: ViewOfferProtocol!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
    @IBAction func view_offer_btn(_ sender: UIButton) {
     
        
        self.delegate.ViewOfferButtonDidSelect(index: self.index)
    }
    
    func setData(data:NSDictionary){
        
        
        if let created_at = data["created_at"] as? String{
            
            let created_at = created_at.components(separatedBy: " ")
            
            let date = created_at[0]
            self.date.text = date
        }
        
        if let direction = data["direction"] as? Int{
            
            if(direction == 10){
                self.directionText.text = "has sent you a new offer"
            }
        }
        
        if let offer = data["offer"] as? Double{
            
           self.price.text = "$ \(offer)"
        }
        
        
        
        
        
        let parking = data["parking"] as! NSDictionary
        
        
        if let p_address = parking["address"] as? String{
            
            self.address.text = p_address
        }
        
        
//        if let initial_price = parking["initial_price"] as? Double{
//
//            self.price.text = "$ \(initial_price)"
//        }
        
        
    }
    
}
