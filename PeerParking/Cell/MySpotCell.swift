//
//  PrivateSpotCell.swift
//  PeerParking
//
//  Created by Apple on 26/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class MySpotCell: UITableViewCell {

    @IBOutlet weak var titleStr:UILabel!
    @IBOutlet weak var address:UILabel!
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
