//
//  LiveLocationReceivingService.swift
//  PeerParking
//
//  Created by APPLE on 7/20/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

protocol LiveLocationReceivingServiceDeleegate {
    func updateLocation(latitude:Double?, longitude:Double?)
}
class LiveLocationReceivingService{
    
    //Intent Variable
    var parkingId : String = ""
    
    
    var delegate:LiveLocationReceivingServiceDeleegate!
    var currentLocationReference : DatabaseReference!
        
        
    
    init(parkingId : String) {
        self.parkingId = parkingId
        setReference()
        getParkingLocation()
    }
    
    func setReference(){
       currentLocationReference =  Database.database().reference(withPath: "currentLocation")
    }
    
   
    
    func getParkingLocation() {
       
//        var parkingLocation : ParkingLocation?
        
        if(currentLocationReference != nil)
        {
            if(parkingId != "")
            {
               
               
                
                self.currentLocationReference.child(self.parkingId).observe(.value) { (snapshot) in
                    
                    if(snapshot.exists())
                    {
                        
                        do {
                            let parkingLocation = try FirebaseDecoder().decode(ParkingLocation.self, from: snapshot.value ?? 0)
                            
//                            print(parkingLocation.latitude!)
//                            print(parkingLocation.longitude!)
                            
                            self.delegate.updateLocation(latitude: parkingLocation.latitude, longitude: parkingLocation.longitude!)
//                            completion(parkingLocation)
                            
                        } catch let error {
                            print(error)
                        }
                         
                        
                    }
                   
                    
                }
                
            }
        }
        
        
       
        
        
    }
    
    
    

    
    
    
    
    
    
    
}
