//
//  FilterBottomSheetVC.swift
//  PeerParking
//
//  Created by Apple on 17/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class FilterBottomSheetVC: UIViewController {


    @IBOutlet weak var mini_btn: UIButton!
    @IBOutlet weak var family_btn: UIButton!
    @IBOutlet weak var suv_btn: UIButton!
    
    
    
    @IBOutlet weak var price_switch: DGRunkeeperSwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let multi_switch = price_switch {
//
//            multi_switch.titles = ["Low First", "High First"]
//            multi_switch.borderWidth = 0.3
//            multi_switch.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
//            multi_switch.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            multi_switch.selectedBackgroundColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)
//            multi_switch.titleColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
//            multi_switch.selectedTitleColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            //multi_switch.titleFont = UIFont(name: "Poppins-Bold", size: 17.0)
        }
       
    }
    
   
    @IBAction func bus_btn_click(_ sender: UIButton) {
        
        if(!sender.isSelected){
            
            print("::=unselected")
            
           // sender.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            sender.setBackgroundImage(UIImage.init(named: "bus_btn_img"), for: .normal)
            sender.tintColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)
            
            sender.isSelected = true
        }
        else{
            
            print("::=selected")
            //sender.backgroundColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)
            sender.setBackgroundImage(UIImage.init(named: "blue_round_bg"), for: .normal)
            sender.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            sender.isSelected = false
        }
//        else{
//            sender.imageView?.tintColor = #colorLiteral(red: 0.2156862745, green: 0.6156862745, blue: 0.8156862745, alpha: 1)
//        }
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
