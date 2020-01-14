//
//  SettingViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 06/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var btnChange: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.integer(forKey: "is_social_login") == 1{
            
              self.btnChange.isHidden = true
        }
   
        else
        {
            self.btnChange.isHidden = false
        }
        

       
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnChange(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "changeVC") as! ChangePassViewController
        self.present(vc, animated: true, completion: nil)
        
    }
    

}
