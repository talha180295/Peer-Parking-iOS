//
//  OfferViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 14/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class OfferViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var viewOffer: UIView!
    @IBOutlet weak var tblinner: UITableView!
    @IBOutlet weak var tblOffer: UITableView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnNew: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        tblOffer.dataSource = self
        tblOffer.delegate = self
        
        tblOffer.register(UINib(nibName: "offerCell", bundle: nil), forCellReuseIdentifier: "offerItem")
        
        
        
        viewOffer.isHidden = true
        
        btnCancel.addShadowView(color: UIColor.lightGray)
        btnNew.addShadowView(color: UIColor.lightGray)
        btnAccept.addShadowView(color: btnAccept.backgroundColor!)
        // Do any additional setup after loading the view.
    }
    
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return transactionArr.count
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblOffer.dequeueReusableCell(withIdentifier: "offerItem") as! offerCell
        
        
        cell.btnOffer.addShadowView(color: UIColor.lightGray)
         cell.btnOffer.addTarget(self, action:#selector(setVC), for: .touchUpInside)
        cell.selectionStyle = .none
        return  cell;
    }
    
    @objc func setVC()
    {
         viewOffer.isHidden = false
       
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "navigateVC") as! NavigateViewController
//        vc.strVC = "find"
//        //
//        self.navigationController?.pushViewController(vc, animated: true)
        
       

    }
    
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.view.removeFromSuperview()
         viewOffer.isHidden = true
    }
  
    @IBAction func btnAccept(_ sender: Any) {
        
        NotificationCenter.default.post(name: Notification.Name("offerNotification"), object: nil, userInfo: ["Renish":"Dadhaniya"])
        self.view.removeFromSuperview()
    }
    @IBAction func btnNewOffer(_ sender: Any) {
        
        let alert = UIAlertController(title: "Offer", message: "Send your offer", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Enter offer"
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action) -> Void in
            //let textField = alert?.textFields![0] as! UITextField
          //  print("Text field: \(textField.text)")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) -> Void in
            
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func btnCancel(_ sender: Any) {
         viewOffer.isHidden = true
    }
    @IBAction func btnClose(_ sender: Any) {
         viewOffer.isHidden = true
    }
    
}
