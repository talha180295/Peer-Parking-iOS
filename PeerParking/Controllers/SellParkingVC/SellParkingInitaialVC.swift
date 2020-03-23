//
//  SellParkingInitaialVC.swift
//  PeerParking
//
//  Created by Apple on 16/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

//protocol SellParkingProtocol{
//
//    func navigate(withIdentifier:String)
//
//}
class SellParkingInitaialVC: UIViewController {

//    var delegate:SellParkingProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        // Do any additional setup after loading the view.
    }
    

    @IBAction func publicParkingBtn(_ sender:UIButton){
        
        setUpView(withIdentifier: "PublicParkingVC")
        
    }
    @IBAction func privateParkingBtn(_ sender:UIButton){
           
        setUpView(withIdentifier: "PrivateParkingVC")
           
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
