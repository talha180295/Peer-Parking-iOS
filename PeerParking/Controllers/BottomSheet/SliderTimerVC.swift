//
//  ViewController.swift
//  sliderTime
//
//  Created by Munzareen Atique on 30/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import MultiSlider

import Charts

protocol OnTimeSelectDelegate {
    
    func timeSelect( startigTime : String , endingTime : String, finalPrice : Double)
}

class SliderTimerVC: UIViewController ,UITableViewDelegate,UITableViewDataSource  {
    

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var chartView: HorizontalBarChartView!
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
    var finalPrice : Double!
   
    
    
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
        
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
      
        
      //  self.slider.transform = CGAffineTransform(rotationAngle: (180.0 * .pi) / 180.0)
        
        price = parking_details.initialPrice
        
        
        let date = Date()
        let calendar = Calendar.current
         components = calendar.dateComponents([.year, .month, .day], from: date)
        
//        setChartView()
        setSlider()
//        maxAmount()
        getBookedSlots()
       
// ,
    
//        self.parking_details.sl

    }
    
    func setChartView(){
          chartView.drawBarShadowEnabled = false
                chartView.drawValueAboveBarEnabled = true
                
       
                
                chartView.fitBars = false
        chartView.drawBordersEnabled = false
        chartView.setScaleEnabled(false)
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = false
         chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.xAxis.drawLabelsEnabled = false
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        
        
        
        drawMarginChart()
       
       
       
        
//        chartView.xAxis.
        
        
                
                
//                let barchart = BarChartDataEntry.init(x: 100.0, y: 100.0)
//
//
//
//                let set1 = BarChartDataSet(entries: [barchart], label: "")
//
//
//
//
//
//
//                let data = BarChartData(dataSet: set1)
//
//                data.setValueFont(UIFont(name:"HelveticaNeue-Light", size:100)!)
//        //        data.barWidth = barWidth
//
//                chartView.data = data
                
                
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 286
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        var cell  : UITableViewCell = UITableViewCell()
        
        
        if(startTimeInt.count > 0)
        {
            
            
            for i in 0..<self.startTimeInt.count{
                if(indexPath.row >= startTimeInt[i] / 5  && indexPath.row < endTimeInt[i] / 5 )
                           {
                                cell.backgroundColor = UIColor.black
                           }
            }
        
           
        
        }
        
//        if(indexPath.row >= 0 && indexPath.row < 6 )
//        {
//            cell.backgroundColor = UIColor.black
//        }
//
//        if(indexPath.row >= 138 && indexPath.row < 143 )
//        {
//            cell.backgroundColor = UIColor.black
//        }
        return cell
        
    }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return (self.slider.frame.size.height - 10) / 286
        }
    
    
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1430
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func drawMarginChart() {

        let values = [1000, 2000, 3000, 5000, 7000, 8000, 15000, 21000, 22000, 55000]
//        let labels = ["Blue Yonder Airlines", "Aaron Fitz Electrical", "Central Communications", "Magnificent Office Images", "Breakthrough Telemarke", "Lawrence Telemarketing", "Vancouver Resort Hotels", "Mahler State University", "Astor Suites", "Plaza One"]



        var dataEntries = [ChartDataEntry]()

//        for i in 0..<10 {
            let entry = BarChartDataEntry(x: Double(100), y: Double(100))
let entry1 = BarChartDataEntry(x: Double(200), y: Double(100))
            
            dataEntries.append(entry)
        dataEntries.append(entry1)
//        }
        
        

        let barChartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        barChartDataSet.drawValuesEnabled = false
//        barChartDataSet.colors = ChartColorTemplates.joyful()

        let barChartData = BarChartData(dataSet: barChartDataSet)
        chartView.data = barChartData
        chartView.legend.enabled = false

        

//        chartView.animate(xAxisDuration: 3.0, yAxisDuration: 3.0, easingOption: .easeInOutBounce)

        chartView.chartDescription?.text = ""


//       chartView.zoom(scaleX: 1.1, scaleY: 1.0, x: 0, y: 0)

        
//        let xAxis = chartView.xAxis
//        xAxis.drawGridLinesEnabled = false
//        xAxis.granularity = 10.0
//        xAxis.setLabelCount(143, force: true)
        
        chartView.maxVisibleCount = 1430
        chartView.minOffset = 0.0
        chartView.extraBottomOffset = -1
        
        
        chartView.leftAxis.axisMaximum = 100
        chartView.leftAxis.axisMinimum = 0
        
        chartView.rightAxis.axisMinimum = 0
        chartView.rightAxis.axisMaximum = 1430
       
       
      
//        chartView.setVisibleXRangeMaximum(1000)
//        chartView.setVisibleYRangeMaximum(1000, axis: .left)

//        chartView.setExtraOffsets (left: 0, top: 20.0, right:0.0, bottom: 20.0)



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
                            
//                            self.startTimeInt = []
//                            self.endTimeInt = []
                            
                            response?.data?.forEach({ (parking) in
                                
                                    
                                self.addBookedSlotView(parking: parking)
                                
                            })
                            self.tableview.reloadData()
                              
                            
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
        self.startTime.append(self.convertStringToDate(dateStr1: parking.startAt!))
        self.endTime.append(self.convertStringToDate(dateStr1: parking.endAt!))
        
        
        
       
        
//        self.startTimeInt.append(self.convertInMinutes(date1: self.convertStringToDate(dateStr1: parking.startAt!)))
        
        self.startTimeInt.append(self.convertServerDateToMinutes(date_string: parking.startAt!))
        self.endTimeInt.append(self.convertServerDateToMinutes(date_string: parking.endAt!))
        
//        self.endTimeInt.append(self.convertInMinutes(date1: self.convertStringToDate(dateStr1: parking.endAt!)))
        
        
        
        let startTime : String = parking.startAt?.components(separatedBy: " ")[1] ?? ""
        let startHour : Int = Int( startTime.components(separatedBy: ":")[0] )!
        
        let endTime : String = parking.endAt?.components(separatedBy: " ")[1] ?? ""
        let endHour : Int = Int( endTime.components(separatedBy: ":")[0] )!
        
        print(String(endHour))
//        self.outletArray[parking.startAt]
        
        
//        for i in startHour...endHour{
//            self.outletArray[i].backgroundColor = UIColor.lightGray
//        }
        
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
        
        self.finalPrice = priceperminute
        
        
        
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
        
        if(dateFormatter.date(from: a) != nil)
        {
            let date : Date = dateFormatter.date(from: a)!
                   dateFormatter.dateFormat = "hh:mm a"
                   let Date12 = dateFormatter.string(from: date)
                   return Date12
        }
        else
        {
          return  dateAsString
        }
        
       
       
    }

    func formatDate(date : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        
        var date1 : Date = Date()
        if(dateFormatter.date(from: date) != nil)
        {
            date1  = dateFormatter.date(from: date)!
            
        }
        return date1
        
        
        
    }
    
    @objc func sliderTapped(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        guard let slider = gesture.view as? UISlider else { return }

        let pointTapped: CGPoint = gesture.location(in: slider)
        let positionOfSlider: CGPoint = slider.convert(slider.bounds.origin, to: slider)
        let widthOfSlider: CGFloat = slider.bounds.size.width

        let moveDistance = sqrt(Double(pow(Double(pointTapped.x - positionOfSlider.x),2) + pow(Double(pointTapped.y - positionOfSlider.y),2)))

        var newValue: CGFloat
        if pointTapped.x < 10 {
            newValue = 0
        }
        else {
            newValue = (CGFloat(moveDistance) * CGFloat(slider.maximumValue) / widthOfSlider)
        }

        slider.setValue(Float(newValue), animated: true)
    }
    
//    func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
//           //  print("A")
//
//        let pointTapped: CGPoint = gestureRecognizer.location(in: self.view)
//
//           let positionOfSlider: CGPoint = slider.frame.origin
//           let widthOfSlider: CGFloat = slider.frame.size.width
//           let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(slider.maximumValue) / widthOfSlider)
//
//        slider.value[1] = newValue
////        self.slider.setValue(Float(newValue), animated: true)
//       }
    
    func formatDateServer(date : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
        
//        print("strEnd price \( Helper().getFormatedServerDateTime(dateStr: strEnd))")
       
        
        
        
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
        
          
         
        
        slider.valueLabels[0].textColor = .black
        slider.valueLabels[1].textColor = .black
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
        slider.valueLabels[1].text = " "
        slider.valueLabels[0].text = " "
        slider.valueLabels[0].textColor = UIColor(white: 1, alpha: 0.0)
        slider.valueLabels[1].textColor = UIColor(white: 1, alpha: 0.0)
        slider.valueLabels[0].backgroundColor = UIColor(white: 1, alpha: 0.0)
        slider.valueLabels[1].backgroundColor = UIColor(white: 1, alpha: 0.0)
        slider.thumbViews[0].isHidden = true
        slider.thumbViews[1].isHidden = true
        slider.value[0] = 0.0
        slider.value[1] = 0.0
        
//        lblEnd.text = "23h : 59m"
        
//        strEnd = getCurrentDateString() + slider.valueLabels[1].text!
//        strStart = getCurrentDateString() + slider.valueLabels[0].text!
    
    }
    
    func getCurrentDateString()->String{
        
        
        return String(self.components!.month!) + "/" + String(self.components!.day!) + "/" + String(self.components!.year!) + " "
    }

    @IBAction func setTimeAction(_ sender: Any) {
        
       
        
        if(self.strStart == "" || self.strEnd == ""){
            
            Helper().showToast(message: "Please Select Time Range", controller: self)
        }
        else
        {
            if(self.validateTimeSlot())
            {
                delegate!.timeSelect(startigTime:strStart  , endingTime : strEnd, finalPrice: self.finalPrice ?? 0.0)
                         self.dismiss(animated: false)
            }
            else
            {
               Helper().showToast(message: "Selected Interval contains time already booked", controller: self)
            }
            
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
        
        
        
        
        let strtstrToDate = convertInMinutes(date1: self.formatDateServer(date: Helper().getFormatedServerDateTime(dateStr: self.strStart) ))
        
//        let strtstrToDate = self.convertServerDateToMinutes(date_string: Helper().getFormatedServerDateTime(dateStr: self.strStart))
        
        let endstrToDate = convertInMinutes(date1: self.formatDateServer(date: Helper().getFormatedServerDateTime(dateStr: self.strEnd) ))
//        let endstrToDate = self.convertServerDateToMinutes(date_string: Helper().getFormatedServerDateTime(dateStr: self.strEnd))

        for i in 0..<self.startTimeInt.count{

            
//                            print(i)
//                           print(self.startTimeInt[i])
//                           print(self.endTimeInt[i])
//                           print(strtstrToDate)
//                           print(endstrToDate)
//
//                           print(self.strStart)
//                            print(self.strEnd)
//                            print(startTime[i])
//                            print(endTime[i])
                           
            
            if(strtstrToDate > self.startTimeInt[i]  && strtstrToDate < self.endTimeInt[i] )  {
                print(i)
                print(self.startTimeInt[i])
                print(self.endTimeInt[i])
                print(strtstrToDate)
                print(endstrToDate)
                
                print(self.strStart)
                 print(self.strEnd)
                 print(startTime[i])
                 print(endTime[i])
                
                return false
            }
            else if( endstrToDate >  self.startTimeInt[i]  && endstrToDate < self.endTimeInt[i] )  {
                 print(i)
                 print(self.startTimeInt[i])
                               print(self.endTimeInt[i])
                               print(strtstrToDate)
                               print(endstrToDate)
                               
                               print(self.strStart)
                                print(self.strEnd)
                                print(startTime[i])
                                print(endTime[i])
                return false
            }
            else if(strtstrToDate < self.startTimeInt[i] && endstrToDate > self.startTimeInt[i] ){
                 print(i)
                 print(self.startTimeInt[i])
                               print(self.endTimeInt[i])
                               print(strtstrToDate)
                               print(endstrToDate)
                               
                               print(self.strStart)
                                print(self.strEnd)
                                print(startTime[i])
                                print(endTime[i])
                return false
            }



        }

        return true
        
        
    }
    
    func convertServerDateToMinutes(date_string : String) -> Int{
        
       
        var hour = Int( date_string.components(separatedBy: " ")[1].components(separatedBy: ":")[0])!
        var minnute = Int( date_string.components(separatedBy: " ")[1].components(separatedBy: ":")[1])!
      
        let time1 = (60 * hour) + minnute
        return time1
    }
    
    
    func convertInMinutes(date1 : Date) -> Int{
        
        
//        let time1 = 60*Calendar.current.component(.hour, from: date) + Calendar.current.component(.minute, from: date) + (Calendar.current.component(.second, from: date)/60)
        
        
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//        print("Dateobj: \(dateFormatter.string(from: date1))")
//
       let time1 = (60*Calendar.current.component(.hour, from: date1) ) + Calendar.current.component(.minute, from: date1)
        
        
        return time1
    }
    
    func convertStringToDate(dateStr1 : String)->Date{
        
        let dateFormatterPrint = DateFormatter()
                
       
        
                dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                dateFormatterPrint.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatterPrint.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                       dateFormatterPrint.calendar = Calendar(identifier: .iso8601)
                       dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
                     
        //        dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let date =  dateFormatterPrint.date(from: dateStr1)!
        print(stringFromTime(interval: 12345.67))
        
        return date
    }
    
    func stringFromTime(interval: TimeInterval) -> String {
        let ms = Int(interval.truncatingRemainder(dividingBy: 1) * 1000)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: interval)! + ".\(ms)"
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

