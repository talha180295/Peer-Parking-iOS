//
//  homeParkingCell.swift
//  PeerParking
//
//  Created by Munzareen Atique on 10/10/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import Cosmos

class homeParkingCell: UICollectionViewCell {

    @IBOutlet weak var parking_title: UILabel!
    
    @IBOutlet weak var rating_view: CosmosView!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var barg_count: UIProgressView!
    
    @IBOutlet weak var price: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
//    func setData(taskObj:TaskListModel){
//
//
//
//        self.task_id.text = "Procedure # : \(taskObj.getId())"
//        self.doc_title.text="Doctor Name : \(taskObj.getDocTitle())"
//        self.patient_title.text="Patient Name : \(taskObj.getPatientTitle())"
//
//
//
//        print("(taskObj.getId()\((taskObj.getId()))")
//        getTaskProgress(url:"https://purpledimes.com/Diftech/webservices/task_progress.php?task_id=\(taskObj.getId())")
//
//        print("progress=\( self.pro)")
//        self.progress_percent.text = String(self.pro)
//        self.progress_bar.setProgress(Float(self.pro/100) , animated: true)
//        if(self.pro == 100){
//            //print(pro*100)
//            self.progress_bar.progressTintColor = UIColor(named: "dark-green")
//            self.task_status.text = "Completed"
//            self.task_status.textColor = UIColor(named: "dark-green")
//            self.progress_percent.textColor = UIColor(named: "dark-green")
//        }
//}

}
