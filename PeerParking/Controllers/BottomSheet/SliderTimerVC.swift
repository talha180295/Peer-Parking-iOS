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
    
       @IBOutlet weak var v1: UIView!
       @IBOutlet weak var v2: UIView!
       @IBOutlet weak var v3: UIView!
       @IBOutlet weak var v4: UIView!
       @IBOutlet weak var v5: UIView!
       @IBOutlet weak var v6: UIView!
       @IBOutlet weak var v7: UIView!
       @IBOutlet weak var v8: UIView!
       @IBOutlet weak var v9: UIView!
       @IBOutlet weak var v10: UIView!
       @IBOutlet weak var v11: UIView!
       @IBOutlet weak var v12: UIView!
       @IBOutlet weak var v13: UIView!
       @IBOutlet weak var v14: UIView!
       @IBOutlet weak var v15: UIView!
       @IBOutlet weak var v16: UIView!
       @IBOutlet weak var v17: UIView!
       @IBOutlet weak var v18: UIView!
       @IBOutlet weak var v19: UIView!
       @IBOutlet weak var v20: UIView!
       @IBOutlet weak var v21: UIView!
       @IBOutlet weak var v22: UIView!
       @IBOutlet weak var v23: UIView!
       @IBOutlet weak var v24: UIView!
    
    var delegate:OnTimeSelectDelegate?
    var strStart : String! = ""
    var strEnd : String! = ""
    var price : Double!
    
    
    var startTime : [Date] = []
    var endTime : [Date] = []
    
    var startTimeInt : [Int] = []
    var endTimeInt : [Int] = []
    
    var outletArray :  [UIView] = []
    
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
        
        self.outletArray = [self.v1,self.v2,self.v3,self.v4,self.v5,self.v6,self.v7,self.v8,self.v9,self.v10,self.v11,self.v12,self.v13,self.v14,self.v15,self.v16,self.v17,self.v18,self.v19,self.v20,self.v21,self.v22,self.v23,self.v24]
        
      //  self.slider.transform = CGAffineTransform(rotationAngle: (180.0 * .pi) / 180.0)
        
        price = parking_details.initialPrice
        
        
        let date = Date()
        let calendar = Calendar.current
         components = calendar.dateComponents([.year, .month, .day], from: date)
        
        setSlider()
        maxAmount()
        getBookedSlots()
       
// ,
    
//        self.parking_details.sl

    }
    
    func getBookedSlots(){
        
        let formatter4 = DateFormatter()
        formatter4.dateFormat = "yyyy-MM-dd"
        
        var currnetDate : String = formatter4.string(from: Date())
        let params:[String:Any] = ["private_parking_id" : self.parking_details.id ?? 0,
                                   "private_parking_date" : currnetDate
        ]
        
        
        
        APIClient.serverRequest(url: APIRouter.getParkings(params),path:APIRouter.getParkings(params).getPath(), dec: ResponseData<[Parking]>.self) { (response, error) in
                  
//                  Helper().hideSpinner(view: self.view)
                  if(response != nil){
                      if (response?.success) != nil {
                          //                    Helper().showToast(message: response?.message ?? "-", controller: self)
                          if let val = response?.data {
                            
                            response?.data?.forEach({ (parking) in
                                
                                    
                                self.addBookedSlotView(parking: parking)
                                
                            })
                              
                            
                          }
                      }
                      else{
                          Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                      }
                  }
                  else if(error != nil){
                      Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
                  }
                  else{
                      Helper().showToast(message: "Nor Response and Error!!", controller: self)
                  }
              }
        
        
        
        
        
        
    }
    
    func addBookedSlotView(parking : Parking)
    {
//        self.startTime.append(self.convertStringToDate(dateStr1: parking.startAt!))
//        self.endTime.append(self.convertStringToDate(dateStr1: parking.endAt!))
        
        
        
        self.startTimeInt.append(self.convertInMinutes(date: self.convertStringToDate(dateStr1: parking.startAt!)))
        self.endTimeInt.append(self.convertInMinutes(date: self.convertStringToDate(dateStr1: parking.endAt!)))
        
        
        
        let startTime : String = parking.startAt?.components(separatedBy: " ")[1] ?? ""
        let startHour : Int = Int( startTime.components(separatedBy: ":")[0] )!
        
        let endTime : String = parking.endAt?.components(separatedBy: " ")[1] ?? ""
        let endHour : Int = Int( endTime.components(separatedBy: ":")[0] )!
        
        print(String(endHour))
//        self.outletArray[parking.startAt]
        
        
        for i in startHour...endHour{
            self.outletArray[i].backgroundColor = UIColor.lightGray
        }
        
    }
    
    
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        (self.slider.subviews[0] as UIView).tintColor = UIColor.black
//        (self.slider.subviews[0] as UIView).backgroundColor = UIColor.black
//
//    }
    
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
        
        
        print("ending price \(strEnd)")
        print("staritng parice \(strStart)")
        
        print("strEnd price \( Helper().getFormatedServerDateTime(dateStr: strEnd))")
       
        
        
        
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
        
       
        if(self.validateTimeSlot())
        {
                    delegate!.timeSelect(startigTime:strStart  , endingTime : strEnd)
                     self.dismiss(animated: false)
        }
        else
        {
            Helper().showToast(message: "Selected Interval contains time already booked", controller: self)
        }
        

        
        
    }
    @IBAction func cancelAction(_ sender: Any) {
        
        self.dismiss(animated: false)
    }
    
    func validateTimeSlot()->Bool{
        
        
       
        
//        let strtstrToDate = self.convertStringToTime(dateStr1: Helper().getFormatedServerDateTime(dateStr: self.strStart).components(separatedBy: " ")[1])
//
//        return false
//        let strtstrToDate = self.convertStringToDate(dateStr1: Helper().getFormatedServerDateTime(dateStr: self.strStart))
//        let endstrToDate = self.convertStringToDate(dateStr1: Helper().getFormatedServerDateTime(dateStr: self.strEnd))
        
         let strtstrToDate = convertInMinutes(date: self.formatDate(date: self.strStart))
        let endstrToDate = convertInMinutes(date: self.formatDate(date: self.strEnd))

        for i in 0...self.startTime.count{

            
            
            
            if(strtstrToDate >  self.startTimeInt[i]  && strtstrToDate < self.endTimeInt[i] )  {
                print(self.startTimeInt[i])
                print(self.endTimeInt[i])
                print(strtstrToDate)
                print(endstrToDate)
                
                print(strtstrToDate)
                 print(endstrToDate)
                 print(startTime[i])
                 print(endTime[i])
                
                return false
            }
            else if( endstrToDate >  self.startTimeInt[i]  && endstrToDate < self.endTimeInt[i] )  {
                print(self.startTimeInt[i])
                print(self.endTimeInt[i])
                print(strtstrToDate)
                print(endstrToDate)
                
                print(strtstrToDate)
                 print(endstrToDate)
                 print(startTime[i])
                 print(endTime[i])
                return false
            }
            else if(strtstrToDate < self.startTimeInt[i] && endstrToDate > self.startTimeInt[i] ){
                print(self.startTimeInt[i])
                print(self.endTimeInt[i])
                print(strtstrToDate)
                print(endstrToDate)
                
                print(strtstrToDate)
                 print(endstrToDate)
                 print(startTime[i])
                 print(endTime[i])
                return false
            }



        }

        return true
        
        
    }
    
    
    func convertInMinutes(date : Date) -> Int{
        
        
//        let time1 = 60*Calendar.current.component(.hour, from: date) + Calendar.current.component(.minute, from: date) + (Calendar.current.component(.second, from: date)/60)
        
       let time1 = (60*Calendar.current.component(.hour, from: date) ) + Calendar.current.component(.minute, from: date)
        
        return time1
        
    }
    
    func convertStringToDate(dateStr1 : String)->Date{
        
        var dateFormatter = DateFormatter()
       
        
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var dateString = dateFormatter.date(from: dateStr1)!
        
        return dateString
    }
    
    func convertStringToDateLocal(dateStr1 : String)->Date{
        
        var dateFormatter = DateFormatter()
       
        
        
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        var dateString = dateFormatter.date(from: dateStr1)!
        
        return dateString
    }
    
    func convertStringToTime(dateStr1 : String)->Date{
        
        
        
        var date : Date = Date()
        var dateFormatter = DateFormatter()
       
        
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "HH:mm:ss"
        var dateString = dateFormatter.date(from: dateStr1)!
        
        
        
        
        return dateString
    }
}

extension Date {
    func secondsFromBeginningOfTheDay() -> TimeInterval {
        let calendar = Calendar.current
        // omitting fractions of seconds for simplicity
        let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: self)

        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60 + dateComponents.second!

        return TimeInterval(dateSeconds)
    }

    // Interval between two times of the day in seconds
    func timeOfDayInterval(toDate date: Date) -> TimeInterval {
        let date1Seconds = self.secondsFromBeginningOfTheDay()
        let date2Seconds = date.secondsFromBeginningOfTheDay()
        return date2Seconds - date1Seconds
    }
}

//
//extension Date {
//    func string(format: String) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = format
//        return formatter.string(from: self)
//    }
//    var time: Time {
//        return Time(self)
//    }
//}
//
//class Time: Comparable, Equatable {
//init(_ date: Date) {
//    //get the current calender
//    let calendar = Calendar.current
//
//    //get just the minute and the hour of the day passed to it
//    let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
//
//        //calculate the seconds since the beggining of the day for comparisions
//        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60
//
//        //set the varibles
//        secondsSinceBeginningOfDay = dateSeconds
//        hour = dateComponents.hour!
//        minute = dateComponents.minute!
//    }
//
//    init(_ hour: Int, _ minute: Int) {
//        //calculate the seconds since the beggining of the day for comparisions
//        let dateSeconds = hour * 3600 + minute * 60
//
//        //set the varibles
//        secondsSinceBeginningOfDay = dateSeconds
//        self.hour = hour
//        self.minute = minute
//    }
//
//    var hour : Int
//    var minute: Int
//
//    var date: Date {
//        //get the current calender
//        let calendar = Calendar.current
//
//        //create a new date components.
//        var dateComponents = DateComponents()
//
//        dateComponents.hour = hour
//        dateComponents.minute = minute
//
//        return calendar.date(byAdding: dateComponents, to: Date())!
//    }
//
//    /// the number or seconds since the beggining of the day, this is used for comparisions
//    private let secondsSinceBeginningOfDay: Int
//
//    //comparisions so you can compare times
//    static func == (lhs: Time, rhs: Time) -> Bool {
//        return lhs.secondsSinceBeginningOfDay == rhs.secondsSinceBeginningOfDay
//    }
//
//    static func < (lhs: Time, rhs: Time) -> Bool {
//        return lhs.secondsSinceBeginningOfDay < rhs.secondsSinceBeginningOfDay
//    }
//
//    static func <= (lhs: Time, rhs: Time) -> Bool {
//        return lhs.secondsSinceBeginningOfDay <= rhs.secondsSinceBeginningOfDay
//    }
//
//
//    static func >= (lhs: Time, rhs: Time) -> Bool {
//        return lhs.secondsSinceBeginningOfDay >= rhs.secondsSinceBeginningOfDay
//    }
//
//
//    static func > (lhs: Time, rhs: Time) -> Bool {
//        return lhs.secondsSinceBeginningOfDay > rhs.secondsSinceBeginningOfDay
//    }
//}

