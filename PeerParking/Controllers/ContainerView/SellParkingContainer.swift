//
//  SellParkingContainer.swift
//  PeerParking
//
//  Created by Apple on 11/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class SellParkingContainer: UIViewController {

    var publicParkingVC:UIViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        publicParkingVC = storyboard!.instantiateViewController(withIdentifier: "PublicParkingVC")
        
        addChild(publicParkingVC)
        publicParkingVC.view.frame = view.frame  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
        view.addSubview(publicParkingVC.view)
        publicParkingVC.didMove(toParent: self)
        //         init_controllers()
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
