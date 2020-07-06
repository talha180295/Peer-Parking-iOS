//
//  PricePicker.swift
//  PeerParking
//
//  Created by Apple on 04/11/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

typealias price = (_ infoToReturn :String) ->()

class PricePicker: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    var completionBlock:price?
    var price = ""
    
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        picker.dataSource = self
        
        picker.selectRow(14, inComponent: 0, animated: false)
        picker.selectRow(1, inComponent: 1, animated: false)
    }
    

    @IBAction func done_btn(_ sender: UIButton) {
        returnFirstValue(sender: sender)
        self.dismiss(animated: true, completion: nil)
    }
    
 
    func returnFirstValue(sender: UIButton) {
        guard let cb = completionBlock else {return}
        price = "\(picker.selectedRow(inComponent:0) + 1).\((picker.selectedRow(inComponent:1) + 1)*25)"
        cb("\(price)")
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print("self.index=\(self.index)")
//        self.index = row+1
//    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 100
        } else {
            return 4
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row+1)"
        } else {
            return "\((row)*25)"
        }
    }
    
}
