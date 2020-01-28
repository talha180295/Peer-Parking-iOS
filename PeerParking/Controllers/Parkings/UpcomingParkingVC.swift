//
//  UpcomingParkingVC.swift
//  PeerParking
//
//  Created by Apple on 28/01/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class UpcomingParkingVC: UIViewController,IndicatorInfoProvider {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: "HISTORY", accessibilityLabel: "HISTORY", image: #imageLiteral(resourceName: "tab_findParking"), highlightedImage: #imageLiteral(resourceName: "family_selected"), userInfo: nil)
    }
    
    
}
