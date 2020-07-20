//
//  LiveLocationSendingService.swift
//  PeerParking
//
//  Created by APPLE on 7/20/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class LiveLocationSendingService  {
    
    
    
    
    
    var parkingId : String = ""
    var currentLocationReference : DatabaseReference!
    
    
    init(parkingId : String) {
        self.parkingId = parkingId
        self.setReference()
    }
    
    func setReference(){
       currentLocationReference =  Database.database().reference(withPath: "currentLocation")
    }
    
    
    func setBuyerCurrentLocation(lat : Double , long : Double,completion: @escaping (ParkingLocation) -> ()){
        
        if(currentLocationReference != nil)
        {
            
            var parkingLocation : ParkingLocation  = ParkingLocation(lastDate: makingCurrentDateModel(), latitude: lat, longitude: long)
            
            
            
             let dict = try! FirebaseEncoder().encode(parkingLocation)
            
            
            
            currentLocationReference.child(self.parkingId).setValue(dict , withCompletionBlock:{ (error, ref) -> Void in
                
                
               if let error = error {
                    print(error.localizedDescription)
                }
                else
               {
                
                completion(parkingLocation)
               }
                
                
            })
            
            
        }
        
        
        
        
        
        
    }
    
    func makingCurrentDateModel() -> LastDate {
           
           
           
           let userCalendar = Calendar.current
           let date = Date()
           let components = userCalendar.dateComponents([.day, .month, .year, .calendar], from: Date())
           let createdAt : LastDate = LastDate()
           createdAt.date = userCalendar.component(.day, from: date)
           createdAt.day = userCalendar.component(.weekday, from: date)
           createdAt.hours = userCalendar.component(.hour, from: date)
           createdAt.minutes = userCalendar.component(.minute, from: date)
           createdAt.month = userCalendar.component(.month, from: date)
           createdAt.seconds = userCalendar.component(.second, from: date)
           createdAt.timezoneOffset = -300
           createdAt.time =  Int(truncatingIfNeeded: date.millisecondsSince1970)
           createdAt.year = userCalendar.component(.year, from: date)
           //        date : userCalendar.component(.day, from: date),
           //                   day : userCalendar.component(.weekday, from: date),
           //                   hours : userCalendar.component(.hour, from: date),
           //                   minutes: userCalendar.component(.minute, from: date),
           //                   month : userCalendar.component(.month, from: date),
           //                   seconds : userCalendar.component(.second, from: date),
           //                   time: NSDate().timeIntervalSince1970.hashValue,
           //                   //            timezoneOffset: userCalendar.component(.timeZone, from: date),
           //                   timezoneOffset: -300,
           //                   year: userCalendar.component(.year, from: date)
           
           
           return createdAt
       }
    
    
    
    
    
    
    
    
    
}
