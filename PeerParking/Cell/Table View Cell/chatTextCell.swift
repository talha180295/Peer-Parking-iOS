//
//  chatTextCell.swift
//  PeerParking
//
//  Created by APPLE on 6/11/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class chatTextCell: UITableViewCell {

   
    @IBOutlet weak var chatText: UILabel!
    @IBOutlet weak var textView: CardView!
    
    @IBOutlet weak var dateLabel: UILabel!
   
    

    @IBOutlet weak var leadingTextConstrain: NSLayoutConstraint!
    @IBOutlet weak var trailingTextConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var leadingDateConstrain: NSLayoutConstraint!
    @IBOutlet weak var trailingDateConstrain: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setLayout(_ isRight : Bool){
        
        if(isRight){
            
            trailingTextConstrain.constant = 8
            leadingTextConstrain.isActive = false
            
            leadingDateConstrain.isActive = false
            trailingDateConstrain.constant = 8
            
            dateLabel.textAlignment = .right
            
        }
        
        else
        {
            
            trailingTextConstrain.isActive = false
            leadingTextConstrain.constant = 8
            
            leadingDateConstrain.constant = 8
            trailingDateConstrain.isActive = false
            
            dateLabel.textAlignment = .left
            
        }
        
            
        
        
        
        
        
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
