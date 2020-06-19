//
//  ParkingBookingDetailsVC.swift
//  PeerParking
//
//  Created by haya on 18/06/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import Cosmos

class ParkingBookingDetailsVC: UIViewController {

    var viewModel:ParkingBookingDetailsViewModel!

    
    //Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var subType: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var userType: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Parking Bookin Details"
        self.setData(data: viewModel.getParkingModel())
    }
    


}

//Data Methods
extension ParkingBookingDetailsVC{
    
    func setData(data:Parking){
        
        let imgUrl = data.imageURL
        
        self.image.sd_setImage(with: URL(string: imgUrl ?? ""),placeholderImage: UIImage.init(named: "placeholder-img") )
        self.address.text = data.address ?? "-"
        self.ratingView.rating = data.seller?.details?.averageRating ?? 0.0
        self.subType.text = data.parkingSubTypeText ?? "-"
        self.price.text = String(data.finalPrice ?? 0.0)
        
        if(viewModel.getIsPosted()){
            self.userType.text = "Buyer's Information"
            self.name.text = data.buyer?.details?.fullName ?? "-"
            self.number.text = data.buyer?.details?.phone ?? "-"
        }
        else{
            self.userType.text = "Seller Information"
            self.name.text = data.seller?.details?.fullName ?? "-"
            self.number.text = data.seller?.details?.phone ?? "-"
        }
        
    }
}
