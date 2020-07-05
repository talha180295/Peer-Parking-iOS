//
//  HistoryCell.swift
//  PeerParking
//
//  Created by Munzareen Atique on 11/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    @IBOutlet weak var startAtlabel: UILabel!
    @IBOutlet weak var direction: UILabel!
    @IBOutlet weak var parkingTitle: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var availablity: UILabel!
    @IBOutlet weak var type: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
