//
//  StartEndPopUp.swift
//  PeerParking
//
//  Created by Apple on 23/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class StartEndPopUp: UIViewController {

    
    @IBOutlet weak var startPicker:UIDatePicker!
    @IBOutlet weak var endPicker:UIDatePicker!
    @IBOutlet weak var segmentedControl:UISegmentedControl!
    @IBOutlet weak var textLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textLabel.text = "Start Time"
        startPicker.isHidden = false
        endPicker.isHidden = true
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

}
