//
//  StepOneVC.swift
//  PeerParking
//
//  Created by Apple on 28/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import UIAlertDateTimePicker
import DatePickerDialog

class StepOneVC: UIViewController, UIAlertDateTimePickerDelegate {
    
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var price_switch: DGRunkeeperSwitch!
    
    @IBOutlet weak var time_field: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timePicker.datePickerMode = .time
        if let multi_switch = price_switch {
            //
            multi_switch.titles = ["Now", "At"]
            multi_switch.borderWidth = 0.3
            multi_switch.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            multi_switch.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            multi_switch.selectedBackgroundColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)
            multi_switch.titleColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            multi_switch.selectedTitleColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            //multi_switch.titleFont = UIFont(name: "Poppins-Bold", size: 17.0)
        }
        
    }
    

    @IBAction func tap_field(_ sender: UITextField) {
        

        datePickerTapped()
//        let datePicker = UIAlertDateTimePicker(withPickerMode: .time, pickerTitle: "Select Time", showPickerOn: (self.view.superview?.superview?.superview)!)
//
//        datePicker.delegate = self
//
//
//        datePicker.showAlert()
        
    }
    
    
    
    func datePickerTapped() {
        DatePickerDialog().show("Select Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
            (date) -> Void in
            if let time = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "hh:mm a"
                self.time_field.text = formatter.string(from: time)
            }
        }
    }
    
    @IBAction func switchValueDidChange(sender: DGRunkeeperSwitch!) {
        print("valueChanged: \(sender.selectedIndex)")
        
        if(sender.selectedIndex == 1){
                time_field.isHidden = false
        }
        else{
            time_field.isHidden = true
        }
    }
    func positiveButtonClicked(withDate date: Date) {
        print("positve")
    }
    
}
