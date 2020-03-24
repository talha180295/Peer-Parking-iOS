//
//  StartEndPopUp.swift
//  PeerParking
//
//  Created by Apple on 23/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

typealias time = (_ startTime :String, _ endTime :String) ->()

class StartEndPopUp: UIViewController {

    
    @IBOutlet weak var startPicker:UIDatePicker!
    @IBOutlet weak var endPicker:UIDatePicker!
    @IBOutlet weak var segmentedControl:UISegmentedControl!
    @IBOutlet weak var textLabel:UILabel!
    
    //Intent Variables
    var startDate = ""
    var endDate = ""
    
    //Variables
    var completionBlock:time?
    let formatter = DateFormatter()
   

    override func viewDidLoad() {
        super.viewDidLoad()

        textLabel.text = "Start Time"
        startPicker.isHidden = false
        endPicker.isHidden = true
        
        formatter.timeStyle = .short
        startPicker.date = formatter.date(from: startDate) ?? Date()
        endPicker.date = formatter.date(from: endDate) ?? Date()
        
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            textLabel.text = "Start Time"
            startPicker.isHidden = false
            endPicker.isHidden = true
        case 1:
            textLabel.text = "End Time"
            startPicker.isHidden = true
            endPicker.isHidden = false
        default:
            break
        }
    }
    @IBAction func done_btn(_ sender: UIButton) {
       returnFirstValue(sender: sender)
       self.dismiss(animated: true, completion: nil)
    }


    func returnFirstValue(sender: UIButton) {
        guard let cb = completionBlock else {return}
       
        let st_date = formatter.string(from: startPicker.date)
        let end_date = formatter.string(from: endPicker.date)
        cb(st_date, end_date)
    }

}
