//
//  StepThreeVC.swift
//  PeerParking
//
//  Created by Apple on 28/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class StepThreeVC: UIViewController {

    @IBOutlet weak var stackview: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.deleteViewsFromStack(index: 1)
        self.deleteViewsFromStack(index: 3)
        self.deleteViewsFromStack(index: 5)
    }
    

    @IBAction func per_hour_btn(_ sender: UIButton) {
    }
    
    @IBAction func s1(_ sender: UISwitch) {
       
        self.deleteViewsFromStack(index: 1)
        
    }
    
    @IBAction func s2(_ sender: UISwitch) {
        
        self.deleteViewsFromStack(index: 3)
    }
    @IBAction func s3(_ sender: UISwitch) {
        
        self.deleteViewsFromStack(index: 5)
    }
    
    
    func deleteViewsFromStack(index : Int)
    {
        UIView.animate(withDuration: 0.25) { () -> Void in
            let firstView = self.stackview.arrangedSubviews[index]
            firstView.isHidden = !firstView.isHidden
        }
    }
//    if(self.watchArray.count == 0)
//    {
//    self.deleteViewsFromStack(index: 3)
//    }
   

}
