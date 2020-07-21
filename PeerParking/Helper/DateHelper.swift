//
//  DateHelper.swift
//  
//
//  Created by talha on 21/07/2020.
//

import UIKit

enum dateFormat:String{
    
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    case ddMMyyy = "dd/MM/yyyy"
    case hmma = "h:mm a"
    case HHmmss = "HH:mm:ss"
}

class DateHelper {
    
    //    static let yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    //    static let ddMMyyy = "dd/MM/yyyy"
    
    static func getFormatedDate(dateStr:String, inFormat:String, outFormat:String) -> String{
        
        if(dateStr == ""){
            
            return "-"
        }
        else{
            
            let inDateFormatter = DateFormatter()
            inDateFormatter.dateFormat = inFormat
            
            if(inDateFormatter.date(from:dateStr) != nil){
                
                let inFormateDate = inDateFormatter.date(from:dateStr)!
                
                let outDateFormatter = DateFormatter()
                outDateFormatter.dateFormat = outFormat
                let outFormateDate = outDateFormatter.string(from: inFormateDate)
                return outFormateDate
            }
            else{
                
                return  dateStr
            }
        }
    }
    
}
