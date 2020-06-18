//
//  MySpotParkingDetailViewModel.swift
//  PeerParking
//
//  Created by talha on 16/06/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import Foundation
class MySpotParkingDetailViewModel{
    
    private var parkingDetails:Parking!
    
    init(parkingDetails:Parking) {
        self.parkingDetails = parkingDetails
    }
    
    public func getParkingDetails() -> Parking{
        return self.parkingDetails
    }
    public func setParkingDetails(parkingDetails:Parking){
        self.parkingDetails = parkingDetails
    }
    
}
