//
//  transactionCell.swift
//  PeerParking
//
//  Created by Munzareen Atique on 09/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class transactionCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var parkingSoldOrBought: UILabel!
    @IBOutlet weak var transactionFeeLabel: UILabel!
    @IBOutlet weak var parkingPrice: UILabel!
    @IBOutlet weak var tranFee: UILabel!
    @IBOutlet weak var balance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
