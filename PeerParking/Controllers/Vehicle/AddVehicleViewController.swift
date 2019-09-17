//
//  AddVehicleViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 14/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class AddVehicleViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    var typeArr :[String] = ["SUV", "Sedan", "Coupe", "Van", "Truck", "Wagon"]
    var colorArr :[String]  = ["White", "Black", "Grey"]
    
    @IBOutlet weak var txtColor: UITextField!
    @IBOutlet weak var txtType: UITextField!
    var pickerColor : UIPickerView!
    var pickerType : UIPickerView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        setPicker()
        // Do any additional setup after loading the view.
    }
    
    func setPicker() {
        
        pickerColor = UIPickerView()
        pickerColor.dataSource = self
        pickerColor.delegate = self
        txtColor.inputView = pickerColor
        
        pickerType = UIPickerView()
        pickerType.dataSource = self
        pickerType.delegate = self
        txtType.inputView = pickerType
        
       
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return  1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        var count = 0
        if pickerView == pickerColor
        {
            count = colorArr.count
        }
        if pickerView == pickerType
        {
            count = typeArr.count
        }
       
        
        
        
        return count
        
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerColor{
            
            
            let strState = colorArr[row] as! String
            txtColor.text = strState
            
            
        }
        if pickerView == pickerType{
            
            
            let strState = typeArr[row]
            txtType.text = strState
            
            
        }
       
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var strFav: String!
        if(pickerView == pickerColor)
        {
            let strState = colorArr[row] as! String
            strFav = strState
        }
        if(pickerView == pickerType)
        {
            let strState = typeArr[row]
            strFav = strState
        }
       
        // return title
        
        
        return strFav
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
