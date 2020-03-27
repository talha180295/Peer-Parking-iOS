//
//  BarViewController.swift
//  rangeSample
//
//  Created by haya on 16/03/2020.
//  Copyright © 2020 haya. All rights reserved.
//

import UIKit
import Charts

import MultiSlider
class BarViewController:  DemoBaseViewController,UIGestureRecognizerDelegate{
  
    
var months: [String]!
    @IBOutlet weak var chartBar: BarChartView!
   var gesture: UITapGestureRecognizer!
    let labels = ["Value 1", "Value 2", "Value 3"]

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var slider: MultiSlider!
   var dataEntries: [ChartDataEntry] = []
    var selectionMax:Float = 0.0
    var selectionMin:Float = 0.0
    var a:CGFloat!
    var b:CGFloat!
    
        lazy var dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "hh:mm a"
            return dateFormatter
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        a = 1 * 60 * 60
//                  b = 8 * 60 * 60

                   updateText(slider)
//        slider.value = [1,14]
//         slider.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
//          chartBar.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)

        months = ["12 am","1 am" , "2 am", "3 am", "4 am", "5 am", "6 am", "7 am", "8 am", "9 am", "10 am", "11 am", "12 pm", "1 pm", "2 pm", "3 pm", "4 pm","5 pm","6 pm","7 pm","8 pm","9 pm", "10 pm","11 pm"]
       let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
          self.title = "Bar Chart"
                
//        let gest = UITapGestureRecognizer(target: self, action: #selector(scale))
        self.slider.addTarget(self, action: #selector(scale), for: .touchDown)

      
      
        self.options = [.toggleValues,
                                .toggleHighlight,
                                .animateX,
                                .animateY,
                                .animateXY,
                                .saveToGallery,
                                .togglePinchZoom,
                                .toggleData,
                                .toggleBarBorders]
                
        self.setup(barLineChartView: chartBar)
                
                chartBar.delegate = self
                
                chartBar.drawBarShadowEnabled = false
                chartBar.drawValueAboveBarEnabled = false
    
//                chartBar.maxVisibleCount = 10
                chartBar.fitBars = true
     
                let xAxis = chartBar.xAxis
                xAxis.labelPosition = .bottom
                xAxis.labelFont = .systemFont(ofSize: 10)
                xAxis.granularity = 1
                xAxis.labelCount = 24
               xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        chartBar.drawGridBackgroundEnabled = true


        chartBar.gridBackgroundColor = UIColor.lightGray
        

//
//    chartBar.xAxis.valueFormatter = IndexAxisValueFormatter(values:labels)
//    //Also, you probably we want to add:
//
//    chartBar.xAxis.granularity = 1
        
      
//               xAxis.valueFormatter = IAxisValueFormatter(chart: chartBar)
                
//                let leftAxisFormatter = IAxisValueFormatter()
//                leftAxisFormatter.minimumFractionDigits = 0
//                leftAxisFormatter.maximumFractionDigits = 1
//                leftAxisFormatter.negativeSuffix = " $"
//                leftAxisFormatter.positiveSuffix = " $"
//        xAxis.valueFormatter = IAxisValueFormatter
        
        
//            let leftAxisFormatter = NumberFormatter()
//               leftAxisFormatter.minimumFractionDigits = 0
//               leftAxisFormatter.maximumFractionDigits = 1
//               leftAxisFormatter.negativeSuffix = " $"
//               leftAxisFormatter.positiveSuffix = " $"
                let leftAxis = chartBar.leftAxis
                leftAxis.labelFont = .systemFont(ofSize: 10)
                leftAxis.labelCount = 8
//                leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelTextColor = UIColor.clear
                leftAxis.labelPosition = .outsideChart
                leftAxis.spaceTop = 0
                leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
                
//                let rightAxis = chartBar.rightAxis
//                rightAxis.enabled = true
//                rightAxis.labelFont = .systemFont(ofSize: 10)
//                rightAxis.labelCount = 8
//                rightAxis.valueFormatter = leftAxis.valueFormatter
//                rightAxis.spaceTop = 0.15
//                rightAxis.axisMinimum = 0
//        chartBar.xAxis.drawGridLinesEnabled = false
        chartBar.leftAxis.drawGridLinesEnabled = false
//                let l = chartBar.legend
//                l.horizontalAlignment = .left
//                l.verticalAlignment = .top
//                l.orientation = .vertical
//                l.drawInside = false
//              //  l.form = .circle
//                l.formSize = 9
//                l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
//                l.xEntrySpace = 1
                updateChartData()
//                chartView.legend = l
//                let marker = XYMarkerView(color: UIColor(white: 180/250, alpha: 1),
//                                          font: .systemFont(ofSize: 12),
//                                          textColor: .white,
//                                          insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
//                                          xAxisValueFormatter: chartBar.xAxis.valueFormatter!)
//                marker.chartView = chartBar
//                marker.minimumSize = CGSize(width: 80, height: 40)
//                chartBar.marker = marker
//
//                sliderX.value = 12
//                sliderY.value = 50
//                slidersValueChanged(nil)

//        months = ["a", "b"]
//        chartBar.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
//       setChart(dataPoints: months, values: unitsSold)
//      slider.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)

    }
    @objc func scale(_ sender: UITapGestureRecognizer) {
          switch sender.state {
          case .began: break
//              identity = vieww.transform
          case .changed,.ended: break
//              vieww.transform = identity.scaledBy(x: sender.scale, y: sender.scale)
          case .cancelled:
              break
          default:
              break
          }
      }
   
    override func updateChartData() {
            if self.shouldHideData
            {
                chartBar.data = nil
                return
            }
            
          self.setDataCount(Int(23))
        }
        
        func setDataCount(_ count: Int) {
            let start = 0
            let end = Int(selectionMax)
            print(selectionMin)
            print(selectionMax)
            let yVal = (start..<count + 1).map{ (i) -> BarChartDataEntry in
                print("label = \(i)")
                if i >= end || i <= Int(selectionMin){
                  
                    return BarChartDataEntry(x: Double(i), y: 0, icon: UIImage(named: "icon"))
                    
                    
                }
                  return BarChartDataEntry(x: Double(i), y: 30, icon: UIImage(named: "icon"))
                
                
        
            }
            
            
            
            
//            let yVals = (start..<start+count+1).map { (i) -> BarChartDataEntry in
//                let mult = range + 1
//                let val = Double(arc4random_uniform(mult))
//                if arc4random_uniform(100) < 99{
//                    return BarChartDataEntry(x: Double(i), y: 0, icon: UIImage(named: "icon"))
//                } else {
//                    return BarChartDataEntry(x: Double(i), y: val)
//                }
//            }
            
            var set1: BarChartDataSet! = nil
            if let set = chartBar.data?.dataSets.first as? BarChartDataSet {
                set1 = set
                set1.replaceEntries(yVal)
                chartBar.data?.notifyDataChanged()
                chartBar.notifyDataSetChanged()
            } else {
                set1 = BarChartDataSet(entries: yVal, label: "")
                set1.colors = [#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)]
                set1.drawValuesEnabled = false
            
                let data = BarChartData(dataSet: set1)
                data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
                data.barWidth = 1
                chartBar.data = data
         
            }
            
    //        chartView.setNeedsDisplay()
        }
         
        override func optionTapped(_ option: Option) {
            super.handleOption(option, forChartView: chartBar)
        }

        
             func adjustValue(value: inout CGFloat) {
                 let minutes = value / 60
                 let adjustedMinutes =  ceil(minutes / 5.0) * 5
                 value = adjustedMinutes * 60
             }
    @IBAction func updateText(_ sender: MultiSlider) {
//        slider.maximumValue = slider.maximumValue * 60 * 60
        a = sender.value[0] * 1 * 60 * 60
        b = sender.value[1] *  1 * 60 * 60
        print(selectionMin)
                print(selectionMax)
//        a = sender.value[0] * 60 * 60 * 1
//        b = sender.value[1] * 8 * 60 * 60
         adjustValue(value: &a)
                     adjustValue(value: &b)

                     
                     let bedtime = TimeInterval(a)
                     let bedtimeDate = Date(timeIntervalSinceReferenceDate: bedtime)
                     lblLast.text = dateFormatter.string(from: bedtimeDate)
                     
                     let wake = TimeInterval(b)
                     let wakeDate = Date(timeIntervalSinceReferenceDate: wake)
                     lbl.text = dateFormatter.string(from: wakeDate)
                     
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        print(formatter.string(from: bedtimeDate, to: wakeDate)!)
        let difference = Calendar.current.dateComponents([.hour, .minute], from: bedtimeDate, to: wakeDate)
        let formattedString = String(format: "%02ldh%02ldm", difference.hour!, difference.minute!)
       durationLabel.text = formattedString
        
        
//                     let duration = wake - bedtime
//                     let durationDate = Date(timeIntervalSinceReferenceDate: duration)
//                     dateFormatter.dateFormat = "HH:mm"
//                durationLabel.text = dateFormatter.string(from: durationDate)
//                     dateFormatter.dateFormat = "hh:mm a"
        print(selectionMin)
                       print(selectionMax)
        selectionMax = Float(sender.value[1])
        
            
              selectionMin = Float(sender.value[0])
                   updateChartData()
        if slider.value[0] == 0 && slider.value[1] == 1{
            
            
            
            
        }
        if slider.value[0] == 0 && slider.value[1] == 2{
                  
                  
                  
                  
              }
        if slider.value[0] == 0 && slider.value[1] == 3{
                         
                         
                         
                         
                     }
        if slider.value[0] == 0 && slider.value[1] == 4{
                           }
              
    }
    
 
   func setChart(dataPoints: [String], values: [Double]) {
   
                 
        var counter = 0.0

            for i in 0..<dataPoints.count {
                counter += 1.0
                let dataEntry = BarChartDataEntry(x: 0, yValues: values)
                dataEntries.append(dataEntry)
            }

    let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Time")
            let chartData = BarChartData()
            chartData.addDataSet(chartDataSet)
            chartBar.data = chartData
    }

   
    @IBOutlet weak var lblLast: UILabel!
    @IBOutlet weak var lbl: UILabel!
    @IBAction func sliderVal(_ sender: MultiSlider) {
        print(sender.snapStepSize)
        selectionMax = Float(sender.value[1])
//      slider.valueLabelPosition = .right
      
        selectionMin = Float(sender.value[0])
             updateChartData()
 

    }
    
    @IBAction func cancel_btn(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func set_btn(_ sender: UIButton) {
       self.dismiss(animated: true, completion: nil)
    }
 
}
class BarViewCsontroller: MultiSlider {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return true
    }
}
