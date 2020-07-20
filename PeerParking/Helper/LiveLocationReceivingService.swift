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
class LiveLocationReceivingService{
    
    
    var parkingId : String = ""
    var currentLocationReference : DatabaseReference!
        
        
    
    init(parkingId : String) {
        self.parkingId = parkingId
        setReference()
    }
    
    func setReference(){
       currentLocationReference =  Database.database().reference(withPath: "currentLocation")
    }
    
   
    
    func getParkingLocation(completion: @escaping (ParkingLocation) -> ()) {
       
         var parkingLocation : ParkingLocation?
        
        if(currentLocationReference != nil)
        {
            if(parkingId != "")
            {
               
               
                
                self.currentLocationReference.child(self.parkingId).observe(.value) { (snapshot) in
                    
                    if(snapshot.exists())
                    {
                        
                        do {
                            let parkingLocation = try FirebaseDecoder().decode(ParkingLocation.self, from: snapshot.value)
                            
                            print(parkingLocation.latitude!)
                            print(parkingLocation.longitude!)
                            
                            completion(parkingLocation)
                            
                        } catch let error {
                            print(error)
                        }
                         
                        
                    }
                   
                    
                }
                
            }
        }
        
        
       
        
        
    }
    
    
    

    
    
    
    
    
    
    
}
