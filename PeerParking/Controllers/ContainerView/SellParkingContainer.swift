//
//  SellParkingContainer.swift
//  PeerParking
//
//  Created by Apple on 11/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit



class SellParkingContainer: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView(withIdentifier: "SellParkingInitaialVC")
     
    }
    


    func setUpView(withIdentifier:String){
        
        var vc:UIViewController!
        
        vc = storyboard!.instantiateViewController(withIdentifier: withIdentifier)

        addChild(vc)
        vc.view.frame = view.frame  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }

}

//extension SellParkingContainer:SellParkingProtocol{
//
//    func navigate(withIdentifier: String) {
//        setUpView(withIdentifier: withIdentifier)
//    }
//
//
//}
