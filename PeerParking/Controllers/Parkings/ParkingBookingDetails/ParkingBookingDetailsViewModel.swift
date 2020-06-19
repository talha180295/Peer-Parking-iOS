//
//  ParkingBookingDetailsViewModel.swift
//  PeerParking
//
//  Created by haya on 18/06/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class ParkingBookingDetailsViewModel: NSObject {

    private var parkingModel:Parking!
    private var isPosted:Bool!
    
    init(parkingModel:Parking) {
        self.parkingModel = parkingModel
    }
    
    func getParkingModel() -> Parking{
        return self.parkingModel
    }
    
    func setIsPosted(isPosted:Bool){        
        self.isPosted = isPosted
    }
    func getIsPosted() -> Bool{
        return self.isPosted
    }

}
