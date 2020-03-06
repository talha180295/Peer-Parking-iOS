//
//  homeParkingCell.swift
//  PeerParking
//
//  Created by Munzareen Atique on 10/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import Cosmos

class homeParkingCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var parking_title: UILabel!
    
    @IBOutlet weak var rating_view: CosmosView!
    
    @IBOutlet weak var vehicle_type: UILabel!
    
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var isNegotiable: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



}
