//
//  PrivateBookingsCell.swift
//  PeerParking
//
//  Created by haya on 22/06/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class PrivateBookingsCell: UITableViewCell {

    @IBOutlet weak var parkingTitle:UILabel!
    @IBOutlet weak var address:UILabel!
    @IBOutlet weak var availability:UILabel!
    @IBOutlet weak var status:UILabel!
    @IBOutlet weak var price:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
