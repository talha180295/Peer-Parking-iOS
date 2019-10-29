//
//  ParkedViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 13/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class ParkedViewController: UIViewController {
    @IBOutlet weak var progressBar: MBCircularProgressBarView!

    @IBOutlet weak var btnT: UIButton!
    var strTime = "set"
   // @IBOutlet weak var timerView: Knob!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        //timerView.addTarget(self, action: #selector(ParkedViewController.handleValueChanged(_:)), for: .valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnChange(_ sender: Any) {
        strTime = "set"
        btnT.setTitle("Set Time", for: .normal)
        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func handleValueChanged(_ sender: Any) {
       
//        let timeV = timerView.value * 100
//        print(timerView.value)
//             progressBar.value = CGFloat(timeV)
//
       
       
    }
    @IBAction func btnStart(_ sender: UIButton) {
        
        if(strTime.elementsEqual("set"))
        {
            strTime = "start"
            sender.setTitle("Start", for: .normal)
        }
        else  if(strTime.elementsEqual("start"))
        {
            //self.progressBar.progressRotationAngle.addProduct(0, 100)
            sender.setTitle("Stop", for: .normal)
            UIView.animate(withDuration: 10, delay: 0.1
                , options: [], animations: {

                    self.progressBar.value =  0
            }, completion:{
                [weak self] finished in
                self?.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            )
            
            strTime = "stop"
        }
        else  if(strTime.elementsEqual("stop"))
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "customVC") as! CustomSideMenuController
            //
           self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
  

}
