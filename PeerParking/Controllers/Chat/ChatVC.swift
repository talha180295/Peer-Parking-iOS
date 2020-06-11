//
//  ChatVC.swift
//  PeerParking
//
//  Created by APPLE on 6/9/20.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit

class ChatVC: UIViewController  {
    
    @IBOutlet weak var parkingDetailContent: CardView!
    @IBOutlet weak var parkingContentHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var parkingDetailHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bargainCountVoew: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var parkingDetailView: UIView!
    
    @IBOutlet weak var messageTextFieldLabel: UITextField!
    @IBOutlet weak var parkingDetailTopConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var headerHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var tv: UITableView!
    
    var isScroll : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tv.delegate = self
        tv.dataSource = self
        messageTextFieldLabel.setLeftPaddingPoints(7)
        
        self.tv.estimatedRowHeight = 200.0;
        self.tv.rowHeight = UITableView.automaticDimension;
        
        self.tv.separatorStyle = .none
        
        bargainCountVoew.isHidden = true
        
        tv.register(UINib(nibName: "chatTextCell", bundle: nil), forCellReuseIdentifier: "chatTextCell")
        tv.register(UINib(nibName: "chatOfferCell", bundle: nil), forCellReuseIdentifier: "chatOfferCell")
        
        
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        
        
        self.presentingViewController?.dismiss(animated: false, completion: nil)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSLog("Table view scroll detected at offset: %f", scrollView.contentOffset.y)
        
        
        isScroll = false
        
        if(scrollView.contentOffset.y > 30 ){
            
            self.headerHeightConstrain.constant = 75
            self.parkingDetailTopConstrain.constant = 0
            self.parkingContentHeightConstrain.constant = 0
            bargainCountVoew.isHidden = false
            //                self.parkingDetailContent.alpha = 0.0
            
            
            //                self.parkingDetailView.isHidden = true
            
            customAnimation()
  
        }
        
        if(scrollView.contentOffset.y < -30 ){
      
            self.headerHeightConstrain.constant = 180
            self.parkingDetailTopConstrain.constant = 100
            self.parkingContentHeightConstrain.constant = 88
            bargainCountVoew.isHidden = true
            //                self.parkingDetailContent.alpha = 1.0
            customAnimation()
      
        }
      
    }
    
    func customAnimation(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

}


extension ChatVC  : UITableViewDelegate,UITableViewDataSource  {
    
    
    
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//
//        var val : CGFloat  = 0.0
//
//        if(indexPath.row < 2)
//               {
//                val = 100.0
//
//        }
//        else
//        {
//            val = 100.0
//        }
//
//         return val
//    }
//
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //           let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath)
        //           cell.textLabel?.text = "row \(indexPath.row)"
        
        
        
          
        
        
        if(indexPath.row > 2)
        {
           let  cell = tv.dequeueReusableCell(withIdentifier: "chatTextCell") as! chatTextCell
            
            
            
            if(indexPath.row % 2 == 0){
                cell.setLayout(true)
            }
            else
            {
                cell.setLayout(false)
            }
            
             return cell
            
        }
        else
        {
            
             let  cell = tv.dequeueReusableCell(withIdentifier: "chatOfferCell") as! chatOfferCell
            if(indexPath.row > 1){
                  cell.setLayout(true)
            }
            else
            {
                 cell.setLayout(false)
            }
            
         
            
          
            
             return cell
        }
        
        
        
       
    }
   
}

