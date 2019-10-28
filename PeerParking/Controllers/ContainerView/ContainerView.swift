//
//  ContainerView.swift
//  PeerParking
//
//  Created by Apple on 27/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class ContainerView: UIViewController {

    var counter = 0
    
    var controller1:UIViewController!
    var controller2:UIViewController!
    var controller3:UIViewController!
    var controller4:UIViewController!
    var controller5:UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        // Do any additional setup after loading the view.
        controller1 = storyboard!.instantiateViewController(withIdentifier: "one")
        controller2 = storyboard!.instantiateViewController(withIdentifier: "two")
        controller3 = storyboard!.instantiateViewController(withIdentifier: "three")
        controller4 = storyboard!.instantiateViewController(withIdentifier: "four")
        controller5 = storyboard!.instantiateViewController(withIdentifier: "five")
        
        addChild(controller1)
        controller1.view.frame = view.frame  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
        view.addSubview(controller1.view)
        controller1.didMove(toParent: self)
        
       
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.btn_tap(notification:)), name: NSNotification.Name(rawValue: "btn_tap"), object: nil)
        
       
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
    }

    
    func change_page(){
        
        if(counter == 0){
            
            
           // let controller = storyboard!.instantiateViewController(withIdentifier: "one")
            addChild(controller1)
            controller1.view.frame = view.frame  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            view.addSubview(controller1.view)
            controller1.didMove(toParent: self)
            
            
            
        }
        else if(counter == 1){
            
            
            //let controller = storyboard!.instantiateViewController(withIdentifier: "two")
            addChild(controller2)
            controller2.view.frame = view.frame  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            view.addSubview(controller2.view)
            controller2.didMove(toParent: self)
            
            
            
        }
            
        else if(counter == 2){
            
            
            //let controller = storyboard!.instantiateViewController(withIdentifier: "three")
            addChild(controller3)
            controller3.view.frame = view.frame  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            view.addSubview(controller3.view)
            controller3.didMove(toParent: self)
            
            
            
        }
        else if(counter == 3){
            
            
            //let controller = storyboard!.instantiateViewController(withIdentifier: "four")
            addChild(controller4)
            controller4.view.frame = view.frame  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            view.addSubview(controller4.view)
            controller4.didMove(toParent: self)
            
            
            
        }
        else if(counter == 4){
            
            
            //let controller = storyboard!.instantiateViewController(withIdentifier: "five")
            addChild(controller5)
            controller5.view.frame = view.frame  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
            view.addSubview(controller5.view)
            controller5.didMove(toParent: self)
            
            
            
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
