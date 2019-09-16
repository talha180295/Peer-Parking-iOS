//
//  RateViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 14/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnLater(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "parkedVC") as! ParkedViewController
        //
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnSkip(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "parkedVC") as! ParkedViewController
        //
        self.navigationController?.pushViewController(vc, animated: true)
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
