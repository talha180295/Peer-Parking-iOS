//
//  PeerParkingStotyboards.swift
//  PeerParking
//
//  Created by Talha Ahmed on 10/06/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import Foundation
import UIKit


enum PeerParkingStotyboards : String {
    case ParkingDetails
    case Main
    case Chat
    case SellParking
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController> (viewControllerClass: T.Type) -> T {
        let storyboardID  = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(fromPeerParkingStoryboard peerParkingStoryboard : PeerParkingStotyboards) -> Self {
        return peerParkingStoryboard.viewController(viewControllerClass: self)
    }
}

