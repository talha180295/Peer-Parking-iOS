//
//  DateHelper.swift
//  
//
//  Created by talha on 21/07/2020.
//

import UIKit

enum dateFormat:String{
    
//    case serverFormat = "yyyy-MM-dd HH:mm:ss"
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    case ddMMyyy = "dd/MM/yyyy"
    case MMddyyy = "MM/dd/yyyy"
    case hmma = "h:mm a"
    case HHmmss = "HH:mm:ss"
}

class DateHelper {
    
    //    static let yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    //    static let ddMMyyy = "dd/MM/yyyy"
    
    static func getFormatedDate(dateStr:String, inFormat:String = "yyyy-MM-dd HH:mm:ss", outFormat:String) -> String{
        
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
    
    static func getDateString(date:Date) -> String{
        
//        let today = Date()
        let formatter1 = DateFormatter()
//        formatter1.dateStyle = .short
        let dateStr = formatter1.string(from: date)
        
        return dateStr
    }
    
}
