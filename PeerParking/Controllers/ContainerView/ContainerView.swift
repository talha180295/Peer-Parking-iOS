//
//  ContainerView.swift
//  PeerParking
//
//  Created by Apple on 27/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit


var cam = false

class ContainerView: UIViewController {

    var counter = 0
    
   
    
    var controller1:UIViewController!
    var controller2:UIViewController!
    var controller3:UIViewController!
    var controller4:StepFourVC!
    var controller5:UIViewController!
    var controllerLoc:UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        init_controllers()
        
       
       
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        if(GLOBAL_VAR.PARKING_POST_DONE){
            init_controllers()
            counter = 0
            GLOBAL_VAR.PARKING_POST_DONE = false
        }
//
        print("::--=viewWillAppear|Container")
        NotificationCenter.default.addObserver(self, selector: #selector(self.btn_tap(notification:)), name: NSNotification.Name(rawValue: "btn_tap"), object: nil)
        
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("::--=viewDidAppear|Container")
        NotificationCenter.default.addObserver(self, selector: #selector(self.btn_tap(notification:)), name: NSNotification.Name(rawValue: "btn_tap"), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        print("::--=viewWillDisappear|Container")
        
        NotificationCenter.default.removeObserver(self)
    }

    func init_controllers(){
        
        // Do any additional setup after loading the view.
        controller1 = storyboard!.instantiateViewController(withIdentifier: "one")
        controller2 = storyboard!.instantiateViewController(withIdentifier: "two")
        controller3 = storyboard!.instantiateViewController(withIdentifier: "three")
        controller4 = storyboard!.instantiateViewController(withIdentifier: "four") as! StepFourVC
        controller5 = storyboard!.instantiateViewController(withIdentifier: "five")
        controllerLoc = storyboard!.instantiateViewController(withIdentifier: "LocationStepVC")
        addChild(controller2)
        controller2.view.frame = view.frame  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
        view.addSubview(controller2.view)
        controller2.didMove(toParent: self)
    }
    
    func change_page(){
        
        if(counter == 0){
            
            self.addChild(self.controller2)
            self.controller2.view.frame = self.view.frame  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            self.view.addSubview(self.controller2.view)
            self.controller2.didMove(toParent: self)
            
            
        }
        else if(counter == 1){
            
          
            self.addChild(self.controller4)
            self.controller4.view.frame = self.view.frame  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            self.view.addSubview(self.controller4.view)
            self.controller4.didMove(toParent: self)
            
            
        }
            
        else if(counter == 2) {//&& self.controller4.amount_tf.hasText{
            
            //let controller = storyboard!.instantiateViewController(withIdentifier: "three")
            self.addChild(self.controller1)
            self.controller1.view.frame = self.view.frame  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            self.view.addSubview(self.controller1.view)
            self.controller1.didMove(toParent: self)
           
            
        }
        else if(counter == 3){
            
            
            //let controller = storyboard!.instantiateViewController(withIdentifier: "four")
            self.addChild(self.controller3)
            self.controller3.view.frame = self.view.frame  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            self.view.addSubview(self.controller3.view)
            self.controller3.didMove(toParent: self)
            
            
        }
        else if(counter == 4){
            
            
            //let controller = storyboard!.instantiateViewController(withIdentifier: "four")
            self.addChild(self.controllerLoc)
            self.controllerLoc.view.frame = self.view.frame  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            self.view.addSubview(self.controllerLoc.view)
            self.controllerLoc.didMove(toParent: self)
            
            
        }
        else if(counter == 5){
            
            //let controller = storyboard!.instantiateViewController(withIdentifier: "five")
            self.addChild(self.controller5)
            self.controller5.view.frame = self.view.frame  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            self.view.addSubview(self.controller5.view)
            self.controller5.didMove(toParent: self)
            
           
            
        }
    }
    @objc func btn_tap(notification: NSNotification) {
        
        print("Accept button")
        
        if let dict = notification.userInfo as NSDictionary? {
            if let count = dict["counter"] as? Int{
                
                print(count)
                counter = count

                change_page()
//                //super.viewDidLoad()
//                NotificationCenter.default.removeObserver(self)
//                self.viewWillAppear(true)
            }
        }
    }
}

