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
        
        
//        UITabBar.appearance().isTranslucent = false
//        UITabBar.appearance().backgroundColor = UIColor.clear
//        UITabBar.appearance().backgroundImage = UIImage(named: "tab_bar_bg")
//        UITabBar.appearance().contentMode = .scaleToFill
        
        
        
        self.tabBar.items?[0].image = UIImage(named: "tab_findParking")!.withRenderingMode(.alwaysOriginal);
        
        
        
        
        self.tabBar.items?[1].image = UIImage(named: "tab_N")!.withRenderingMode(.alwaysOriginal);
        self.tabBar.items?[2].image = UIImage(named: "tab_sellParking")!.withRenderingMode(.alwaysOriginal);

        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.selectedIndex = 1
//        self.tabBarController?.selectedIndex = 1
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
