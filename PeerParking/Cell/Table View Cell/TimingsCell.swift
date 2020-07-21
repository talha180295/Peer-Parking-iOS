//
//  TimingsCell.swift
//  PeerParking
//
//  Created by Apple on 23/03/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

protocol TimePop {
    func setTime(index:Int)
}
class TimingsCell: UITableViewCell {

//    @IBOutlet weak var checkBoxOutlet:UIButton!{
//        didSet{
//            checkBoxOutlet.setImage(UIImage(named:"uncheckbox"), for: .normal)
//            checkBoxOutlet.setImage(UIImage(named:"checkbox"), for: .selected)
//        }
//    }
    @IBOutlet weak var day:UILabel!
    @IBOutlet weak var startTime:UILabel!
    @IBOutlet weak var endTime:UILabel!
    @IBOutlet weak var timingStackView:UIStackView!
    @IBOutlet weak var checkBoxOutlet:UIButton!
    
    var index:Int!
    var delegate:TimePop!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        timingStackView.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        if(checkBoxOutlet.isSelected){
//           print("helloooooo")
            delegate.setTime(index: self.index)
        }
//        Helper().popUp(controller: <#T##UIViewController#>, view_controller: self)
    }
    //IBAction
    @IBAction func checkbox(_ sender: UIButton){
//        sender.checkboxAnimation {
//            //print("I'm done")
//        }
    }
//    
}
