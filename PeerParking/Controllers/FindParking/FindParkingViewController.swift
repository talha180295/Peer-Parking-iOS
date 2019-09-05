//
//  FindParkingViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 04/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import SideMenuController

class FindParkingViewController: UIViewController ,SideMenuControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
     
      //  loadView()
        
    }
    
    
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            print("\(#function) -- \(self)")
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            print("\(#function) -- \(self)")
        }
        
        @IBAction func presentAction() {
            present(ViewController.fromStoryboard, animated: true, completion: nil)
        }
        
        var randomColor: UIColor {
            let colors = [UIColor(hue:0.65, saturation:0.33, brightness:0.82, alpha:1.00),
                          UIColor(hue:0.57, saturation:0.04, brightness:0.89, alpha:1.00),
                          UIColor(hue:0.55, saturation:0.35, brightness:1.00, alpha:1.00),
                          UIColor(hue:0.38, saturation:0.09, brightness:0.84, alpha:1.00)]
            
            let index = Int(arc4random_uniform(UInt32(colors.count)))
            return colors[index]
        }
        
        func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
            print(#function)
        }
        
        func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
            print(#function)
        }

}
