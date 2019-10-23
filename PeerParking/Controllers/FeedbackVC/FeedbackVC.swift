//
//  FeedbackVC.swift
//  PeerParking
//
//  Created by Apple on 24/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import Cosmos

class FeedbackVC: UIViewController {

    @IBOutlet weak var emoji: UIImageView!
    @IBOutlet weak var rating_bar: CosmosView!
    @IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Called when user finishes changing the rating by lifting the finger from the view.
        // This may be a good place to save the rating in the database or send to the server.
        rating_bar.didFinishTouchingCosmos = { rating in
            
            print("Rating=\(rating)")
            if(rating >= 3.0){
                self.emoji.image = UIImage(named: "happy")
                self.label.text = "Ok Ok!"
            }
            else{
                self.emoji.image = UIImage(named: "sad")
                self.label.text = "No No!"
            }
        }
    }
    
    @IBAction func share_btn(_ sender: UIButton) {
    }
    
   

}
