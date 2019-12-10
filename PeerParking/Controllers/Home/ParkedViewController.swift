//
//  ParkedViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 13/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

import CoreMedia
import CircleProgressView

class ParkedViewController: UIViewController {
    
    @IBOutlet weak var time_left: UILabel!
    

   @IBOutlet weak var lblTimer: UILabel!
   
   @IBOutlet weak var progressView: CircleProgressView!
   var seconds = 120 //This variable will hold a starting value of seconds. It could be any amount above 0.
   var MainSeconds = 120
   var timer = Timer()
   var isTimerRunning = false

    @IBOutlet weak var btnT: UIButton!
    
    
  
    
    
   // var strTime = "set"
   // @IBOutlet weak var timerView: Knob!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        
       
        //timerView.addTarget(self, action: #selector(ParkedViewController.handleValueChanged(_:)), for: .valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnChange(_ sender: Any) {
       // strTime = "set"
        //btnT.setTitle("Set Time", for: .normal)
        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = true
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func handleValueChanged(_ sender: Any) {
       
//        let timeV = timerView.value * 100
//        print(timerView.value)
//             progressBar.value = CGFloat(timeV)
//
       
       
    }
    @IBAction func btnStart(_ sender: UIButton) {
        
    lblTimer.text = timeString(time: TimeInterval(seconds))
    runTimer()
   }
    func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ParkedViewController.updateTimer)), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
         //This will update the label.
        if(seconds>=0)
        {
        lblTimer.text = timeString(time: TimeInterval(seconds))
        time_left.text = timeString2(time: TimeInterval(seconds))
        progressView.progress = Double(seconds)/Double(MainSeconds)
        }
        else
        {
            timer.invalidate()
        }
        
    }

    func timeString(time:TimeInterval) -> String {
        
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func timeString2(time:TimeInterval) -> String {
        
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        if(hours==0)&&(minutes==0){
             return String(format:"%02is",  seconds)
        }
        else if(hours==0){
            return String(format:"%02im:%02is", minutes, seconds)
        }
        else {
            String(format:"%02ih:%02im:%02is", hours, minutes, seconds)
        }
        
        return ""
    }
        

        
    
    
    
  

}
