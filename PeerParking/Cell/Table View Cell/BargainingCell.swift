//
//  BargainingCell.swift
//  PeerParking
//
//  Created by Apple on 19/12/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class BargainingCell: UITableViewCell {

    @IBOutlet weak var rightOffer: UILabel!
    @IBOutlet weak var leftOffer: UILabel!
    
    @IBOutlet weak var rightOfferDate: UILabel!
    @IBOutlet weak var leftOfferDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
