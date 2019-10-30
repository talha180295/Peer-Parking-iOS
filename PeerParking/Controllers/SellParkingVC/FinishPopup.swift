//
//  FinishPopup.swift
//  PeerParking
//
//  Created by Apple on 29/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class FinishPopup: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func finish_btn(_ sender: UIButton) {

        print("DIS__")
 
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customVC")
        self.present(vc, animated: true, completion: nil)

        
    }
    
   

}
