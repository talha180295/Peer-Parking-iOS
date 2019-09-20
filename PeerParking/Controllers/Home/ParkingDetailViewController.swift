//
//  ParkingDetailViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 12/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class ParkingDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource{

     var indexRow = 0
    var strVC : String!
    var isNavigate = false
    var isAccept = false
    var isOffer = false
    @IBOutlet weak var btnViewOffer: UIButton!
    @IBOutlet weak var btnLast: UIButton!
     @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var parkingCollection: UICollectionView!
    @IBOutlet weak var viewChangeVehicle: UIView!
   
  
    @IBOutlet weak var viewVehicle: UIView!//100
  
    
    @IBOutlet weak var tblVehicle: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        parkingCollection.delegate = self
        parkingCollection.dataSource = self
        
        let nibName = UINib(nibName: "ParkingCell", bundle:nil)
        
        parkingCollection.register(nibName, forCellWithReuseIdentifier: "parkingCell")
        
        if(strVC.elementsEqual("find"))
        {
            btnLast.isUserInteractionEnabled = false
            btnLast.setTitle("Go", for: .normal)
//            btnLast.backgroundColor = #colorLiteral(red: 0.943634212, green: 0.191254735, blue: 0.2677332461, alpha: 1)
//            btnLast.addShadowView(color: btnLast.backgroundColor!)
//
        }
        if(strVC.elementsEqual("navigate"))
        {
            isNavigate = true
        }
//            btnLast.setTitle("Navigate", for: .normal)
//            btnLast.backgroundColor = #colorLiteral(red: 0.2591760755, green: 0.6798272133, blue: 0.8513383865, alpha: 1)
//            btnLast.addShadowView(color: btnLast.backgroundColor!)
//
//        }
        btnViewOffer.addShadowView(color: UIColor.lightGray)
        btnLast.addShadowView(color: btnLast.backgroundColor!)
         btnCancel.addShadowView(color: UIColor.lightGray)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ParkingDetailViewController.setOfferVC(notfication:)), name: Notification.Name("offerNotification"), object: nil)
        
        


        
        // Do any additional setup after loading the view.
        tblVehicle.dataSource =  self
        tblVehicle.delegate = self
        
        tblVehicle.register(UINib(nibName: "vehicleCell", bundle: nil), forCellReuseIdentifier: "vehicleCell")
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return transactionArr.count
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVehicle.dequeueReusableCell(withIdentifier: "vehicleCell") as! vehicleCell
        if(indexPath.row == indexRow)
        {
            cell.btnCheck.setImage(UIImage.init(named: "btn_radioSelected"), for: .normal)
        }
        else{
            cell.btnCheck.setImage(UIImage.init(named: "btn_radio"), for: .normal)
        }
        
        cell.selectionStyle = .none
        return  cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indexRow = indexPath.row
        tblVehicle.reloadData()
        
    }
    @objc func setOfferVC(notfication: NSNotification) {
       
        
        
        isAccept = true
        btnLast.isUserInteractionEnabled = true

        btnLast.setTitle("Go", for: .normal)
        btnLast.backgroundColor = #colorLiteral(red: 0.2591760755, green: 0.6798272133, blue: 0.8513383865, alpha: 1)
        btnLast.addShadowView(color: btnLast.backgroundColor!)
    }
    
    @IBAction func btnChangeVehicle(_ sender: Any) {
        
        viewChangeVehicle.isHidden = false
        viewVehicle.isHidden = true
       
    }
    
    @IBAction func btnSaveVehicle(_ sender: Any) {
        
        viewChangeVehicle.isHidden = true
        viewVehicle.isHidden = false
     
        
    
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        
        let alert = UIAlertController(title: "Cancel", message: "Are you sure, you want to cancel this parking?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler:{ action in
            self.navigationController?.popViewController(animated: true)
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.navigationBar.isHidden = false
        }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
        
        
        //alert and close
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        //        [collectionView.collectionViewLayout invalidateLayout];
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return 10;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = parkingCollection.dequeueReusableCell(withReuseIdentifier: "parkingCell", for: indexPath) as! ParkingCell
        
        
        return  cell;
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "placeVC") as! PlaceViewController;
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
       
        // let yourHeight = yourWidth
        
        
        return CGSize(width: 141, height: 180)
        
    }

    @IBAction func btnOffer(_ sender: Any) {
        //login
        
        ///after login open navigate
        isOffer = true
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "offerVC") as! OfferViewController
       
        self.addChild(vc)
        view.addSubview(vc.view)
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "offerVC") as! OfferViewController
//
//        //
//        self.navigationController?.pushViewController(vc, animated: true)
        //self.tabBarController?.tabBar.isHidden = false
       // self.navigationController?.navigationBar.isHidden = false
        // self.view.removeFromSuperview()
        
    }
    @IBAction func btnMain(_ sender: Any) {
        if(!isAccept)
        {
        if(isNavigate)
        {
            //navigate screen
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "navigateVC") as! NavigateViewController
            vc.strVC = "navigate"
            //
            self.navigationController?.pushViewController(vc, animated: true)
            
            //self.tabBarController?.tabBar.isHidden = false
           // self.navigationController?.navigationBar.isHidden = false
            // self.view.removeFromSuperview()
            
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
           // self.view.removeFromSuperview()
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.navigationBar.isHidden = false
        }
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "navigateVC") as! NavigateViewController
            vc.strVC = "find"
            //
            self.navigationController?.pushViewController(vc, animated: true)
            
            //self.tabBarController?.tabBar.isHidden = false
            // self.navigationController?.navigationBar.isHidden = false
            //self.view.removeFromSuperview()
        }
    }
    @IBAction func btnClose(_ sender: Any) {
       // self.view.removeFromSuperview()
          self.navigationController?.popViewController(animated: true)
         self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    @IBAction func btnShowMap(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "placeVC") as! PlaceViewController;
        
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
