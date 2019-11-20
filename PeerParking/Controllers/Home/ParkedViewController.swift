//
//  ParkedViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 13/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

import CoreMedia
import MBCircularProgressBar
import UICircularProgressRing

class ParkedViewController: UIViewController {
    
    @IBOutlet weak var time_left: UILabel!
    
    @IBOutlet weak var progressBar: UICircularTimerRing!

    @IBOutlet weak var btnT: UIButton!
    
    
    var timer = Timer()
    
    
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
        
        
        progressBar.startTimer(to: 10) { state in
            switch state {
            case .finished:
                print("finished")
            case .continued(let time):
                print("continued: \(time)")
            case .paused(let time):
                print("paused: \(time)")
            }
        }
        
//        self.progressBar.value =  self.progressBar.maxValue
//
//
//        UIView.animate(withDuration: 20, delay: 0
//            , options: [], animations: {
//
//                self.progressBar.value =  0
//                self.progressBar.showValueString = true
//        },  completion:{
//            [weak self] finished in
//
//            self!.progressBar.value =  self!.progressBar.maxValue
//            //self?.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//            }
//        )
        
        
       
        
//        if(strTime.elementsEqual("set"))
//        {
//            strTime = "start"
//            sender.setTitle("Start", for: .normal)
//        }
//        else  if(strTime.elementsEqual("start"))
//        {
//            //self.progressBar.progressRotationAngle.addProduct(0, 100)
//            sender.setTitle("Stop", for: .normal)
//            UIView.animate(withDuration: 10, delay: 0.1
//                , options: [], animations: {
//
//                    self.progressBar.value =  0
//            }, completion:{
//                [weak self] finished in
//                //self?.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//            }
//            )
//
//            strTime = "stop"
//        }
//        else  if(strTime.elementsEqual("stop"))
//        {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "customVC") as! CustomSideMenuController
//            //
//           self.navigationController?.pushViewController(vc, animated: true)
//        }
        
    }
    
    
  

}
