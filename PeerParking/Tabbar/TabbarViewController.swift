//
//  TabbarViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 04/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import SideMenuController
class TabbarViewController: UITabBarController ,SideMenuControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "icon_menu")
        sideMenuController?.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(#function) -- \(self)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(#function) -- \(self)")
    }
    
   
    
  
    
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
        print(#function)
    }
    
    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
        print(#function)
    }

}
