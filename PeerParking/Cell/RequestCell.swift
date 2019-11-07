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
    func ViewOfferButtonDidSelect()
}

class RequestCell: UITableViewCell {

    
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
     
        
       self.delegate.ViewOfferButtonDidSelect()
    }
    
}
