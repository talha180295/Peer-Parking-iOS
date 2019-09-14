//
//  ParkedViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 13/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class ParkedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.popViewController(animated: true)
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
