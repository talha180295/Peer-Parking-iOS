//
//  TabbarViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 04/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import SideMenuController

//Global Variable
var tab_index = 1




class TabbarViewController: UITabBarController ,SideMenuControllerDelegate , UITabBarControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        self.delegate = self
        
        
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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//
        
        
        
     
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!
        if selectedIndex == 0 {
            
          NotificationCenter.default.post(name: Notification.Name("refreshView"), object: nil)
            
           
            
            
            
           

        } else {
            print("first tab bar was selected")
            //do whatever
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
       self.selectedIndex = tab_index
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
