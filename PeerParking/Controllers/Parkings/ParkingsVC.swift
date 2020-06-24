//
//  ParkingHistoryVC.swift
//  PeerParking
//
//  Created by Apple on 28/01/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ParkingsVC: ButtonBarPagerTabStripViewController{

    
    //Child ViewConrtrollers
    let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpcomingParkingVC") as! UpcomingParkingVC
    let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingsHistoryVC") as! ParkingsHistoryVC
    
//    let blueInstagramColor = UIColor(red: 37/255.0, green: 111/255.0, blue: 206/255.0, alpha: 1.0)
    let blueInstagramColor = UIColor(named: "themeBlue")
    
    override func viewDidLoad() {
        
        setupTopBar()
        
        super.viewDidLoad()
    }
    
    
    func setupTopBar(){
        
        // change selected bar color
        
        settings.style.buttonBarBackgroundColor = .lightGray
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = blueInstagramColor!
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = self?.blueInstagramColor
        }
        
    }
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
      
        return [self.child_1, self.child_2]
    }
    
    

    @IBAction func filterBtn(_ sender: UIBarButtonItem) {
        
        
        let vc = ParkingFilterBS.instantiate(fromPeerParkingStoryboard: .ParkingDetails)
        
        Helper().bottomSheet(controller: vc, sizes: [.fixed(150)], cornerRadius: 0, handleColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), view_controller: self)

        
    }
    

}
