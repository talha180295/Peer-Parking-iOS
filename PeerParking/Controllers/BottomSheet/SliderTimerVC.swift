//
//  ViewController.swift
//  sliderTime
//
//  Created by Munzareen Atique on 30/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import MultiSlider


protocol OnTimeSelectDelegate {
    
    func timeSelect( startigTime : String , endingTime : String)
}

class SliderTimerVC: UIViewController {

    var parking_details:Parking!
    @IBOutlet weak var finalpricelabel: UILabel!
    @IBOutlet weak var slider: MultiSlider!
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblEnd: UILabel!
    var delegate:OnTimeSelectDelegate?
    var strStart : String! = ""
    var strEnd : String! = ""
    var price : Double!
    var components : DateComponents?
       var a:CGFloat!
       var b:CGFloat!
    
    lazy var dateFormatter: DateFormatter = {
               let dateFormatter = DateFormatter()
               dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
               dateFormatter.dateFormat = "hh:mm a"
               return dateFormatter
           }()
    
    //  @IBOutlet weak var slider: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.slider.transform = CGAffineTransform(rotationAngle: (180.0 * .pi) / 180.0)
        
        price = parking_details.initialPrice
        
        
        let date = Date()
        let calendar = Calendar.current
         components = calendar.dateComponents([.year, .month, .day], from: date)
        
        setSlider()
        maxAmount()
        
        // Do any additional setup after loading the view.
    }

    func changeIntoHour(val : Int) -> String {
      
//        if(val > 0)
//        {
        if(val <= 1430)
        {
            
        let hours = val / 60
        let minutes = val  % 60
        return String(format: "%0.2d:%0.2d", hours, minutes)
        }
        else
        {
//            setPrice(val: val)
            return String(format: "23:59")
        }
//        }
//        else
//        {
//           return String(format: "00:10:00")
//        }
    }
    
    
    func setPrice(val : Int){
       
        
        let totalMinutes = Double(val)
        let priceperminute = (totalMinutes / 60.0 ) * price
        
         finalpricelabel.text = "$ " +  String(format: "%0.2f" ,priceperminute)
//        }
//        else
//        {
//            let totalMinutes = 1430.0
//
//            finalpricelabel.text = "$ " +  String(format: "%0.2f" ,totalMinutes * price)
//        }
    }
   
    
    func changeInPrice(val : Int, isComingDown : Bool) {
       
        if(val <= 1430)
        {
            
            print("converted val \(String(val))")
            
            let perminute = price / 60.0
            
            
            
            let price = isComingDown ? perminute * Double(1430 - val) : perminute * Double(val)
            
            print("converted price \(price)")
//        let minutes = val  % 60
            
            
            finalpricelabel.text = "$ " +  String(format: "%0.2f" ,price)
//            return String(format: "%0.2d",price)
            
        }
        else
        {
            maxAmount()
//            return String(format: "%0.2d",price)
        }
    }
    
    func maxAmount(){
        
        
        let totalMinutes = Double(1439)
               let priceperminute = (totalMinutes / 60.0 ) * price
            
        
                finalpricelabel.text = "$ " +  String(format: "%0.2f" ,priceperminute)
//        let perminute = price / 60.0
//                   let price = perminute * 1430.0
//
//                    finalpricelabel.text =  "$ " + String(format: "%0.2f",price)
        
        
    }
   
    func convertTimeFormat(dateAsString : String) -> String
    {
        let a  =  getCurrentDateString() + dateAsString
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date : Date = dateFormatter.date(from: a)!
        dateFormatter.dateFormat = "hh:mm a"
        let Date12 = dateFormatter.string(from: date)
        return Date12
       
    }

    func formatDate(date : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date1 : Date = dateFormatter.date(from: date)!
        return date1
    }
  
    func getDifference(strStart : String,endStr : String) -> String {
         
         let wakeDate = formatDate(date: strStart)
         let bedtimeDate = formatDate(date: endStr)
         let formatter = DateComponentsFormatter()
         formatter.allowedUnits = [.hour, .minute]
         print(formatter.string(from: bedtimeDate, to: wakeDate)!)
         let difference = Calendar.current.dateComponents([.hour, .minute], from: bedtimeDate, to: wakeDate)
      
        let totalMinutes = -difference.hour! * 60 + -difference.minute!
        
        print("difference minute \(String(totalMinutes))")
        
        setPrice(val: totalMinutes)
        
         let formattedString = String(format: "%02ldh : %02ldm", -difference.hour!, -difference.minute!)
         return formattedString
    }
    @IBAction func sliderValue(_ sender: MultiSlider) {
        
        
        
        print("drag index \(String(sender.draggedThumbIndex))" )
        
          a = sender.value[0]
          b = sender.value[1]
        
        print("a value \(a)")
        print("b value \(b)")
     
        
        
        let endStr = convertTimeFormat(dateAsString: changeIntoHour(val: Int(-a)))
        let startStr =  convertTimeFormat(dateAsString: changeIntoHour(val: Int(-b)))
        
        strEnd = getCurrentDateString() + endStr
        strStart = getCurrentDateString() + startStr
        
        let diff = getDifference(strStart: strStart, endStr: strEnd)
        print(diff)
            lblEnd.text = diff
        
//            lblEnd.text = startStr + " - " + endStr
        
        
        
        
        
        
//        if(sender.draggedThumbIndex == 0)
//        {
//            changeInPrice(val: Int(-a),isComingDown: false)
//        }
//        else{
//            changeInPrice(val: Int(-b),isComingDown: true)
//        }
        
          
         
        
        
        sender.valueLabels[0].backgroundColor = .white
        sender.valueLabels[1].backgroundColor = .white
        sender.valueLabels[0].text = endStr
        sender.valueLabels[1].text = startStr
//
           //button enable/disable
  
                        
    }
    
    func setSlider()
    {

     // slider.value = [-1430, -1440]
        
        slider.valueLabelPosition = .right // .notAnAttribute = don't show labels
        slider.isValueLabelRelative = true // show differences between thumbs instead of absolute values
        ///slider.valueLabelFormatter.positiveSuffix = " 𝞵s"
        slider.valueLabels[1].text = "12:00 AM"
        slider.valueLabels[0].text = "11:59 PM"
        slider.valueLabels[0].backgroundColor = .white
        slider.valueLabels[1].backgroundColor = .white
        slider.thumbViews[0].isHidden = true
        slider.thumbViews[1].isHidden = true
        lblEnd.text = "23h : 59m"
        
        strEnd = getCurrentDateString() + slider.valueLabels[1].text!
        strStart = getCurrentDateString() + slider.valueLabels[0].text!
    
    }
    
    func getCurrentDateString()->String{
        
        
        return String(self.components!.month!) + "/" + String(self.components!.day!) + "/" + String(self.components!.year!) + " "
    }

    @IBAction func setTimeAction(_ sender: Any) {
        
       
       
        delegate!.timeSelect(startigTime:strStart  , endingTime : strEnd)
         self.dismiss(animated: false)
        
        
    }
    @IBAction func cancelAction(_ sender: Any) {
        
        self.dismiss(animated: false)
    }
}

