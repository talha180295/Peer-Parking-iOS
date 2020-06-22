//
//  PrivateParkingDetailsVC.swift
//  PeerParking
//
//  Created by Apple on 31/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class PrivateParkingDetailsVC: UIViewController {

    //Intent Variables
    var privateSpot:PrivateParkingModel!
    
    
    //IBoutlets
    @IBOutlet weak var titleStr:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleStr.text = self.privateSpot.title ?? ""
        // Do any additional setup after loading the view.
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
