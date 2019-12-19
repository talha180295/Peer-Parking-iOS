//
//  BargainingCell.swift
//  PeerParking
//
//  Created by Apple on 19/12/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class BargainingCell: UITableViewCell {

    @IBOutlet weak var offer: UILabel!
    @IBOutlet weak var leftOffer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
