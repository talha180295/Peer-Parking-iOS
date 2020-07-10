//
//  WithdrawVC.swift
//  PeerParking
//
//  Created by talha on 10/07/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

import XLPagerTabStrip


class WithdrawVC: UIViewController,IndicatorInfoProvider {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: "Withdraw", accessibilityLabel: "Withdraw", image: UIImage(named: "historyUn"), highlightedImage: UIImage(named: "history"), userInfo: nil)
    }

}
