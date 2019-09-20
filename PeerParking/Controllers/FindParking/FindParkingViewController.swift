//
//  FindParkingViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 04/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import SideMenuController

class FindParkingViewController: UIViewController ,SideMenuControllerDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var mainSchedule: CardView!
    @IBOutlet weak var mainPicker: CardView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnSave: UIButton!
   
    @IBOutlet weak var placeView: UIView!
    
    
    @IBOutlet weak var tblLocation: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
      
//        self.tabBarController!.navigationItem.title = "Find Parking"
        self.tabBarController?.tabBar.items?[0].image = UIImage(named: "tab_findParking")!.withRenderingMode(.alwaysOriginal);
        self.tabBarController?.tabBar.items?[1].image = UIImage(named: "tab_N")!.withRenderingMode(.alwaysOriginal);
        self.tabBarController?.tabBar.items?[2].image = UIImage(named: "tab_sellParking")!.withRenderingMode(.alwaysOriginal);
        
        
         tabBarItem.selectedImage = UIImage(named: "tab_selected_findParking")?.withRenderingMode(.alwaysOriginal);
        
        mainPicker.isHidden = true
        mainSchedule.isHidden = true
        // tblLocation.isHidden = true
        placeView.isHidden = true
        btnSave.addShadowView(color: btnSave.backgroundColor!)
        
        btnConfirm.addShadowView(color: btnSave.backgroundColor!)
        btnCancel.addShadowView(color: UIColor.lightGray)
   
       
      //  loadView()
        
        tblLocation.dataSource = self
        tblLocation.delegate = self
        
        tblLocation.register(UINib(nibName: "LoacationCell", bundle: nil), forCellReuseIdentifier: "locationCell")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController!.navigationItem.title = "Find Parking"
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func locationBtn(_ sender: Any) {
        
       // tblLocation.isHidden = false
        placeView.isHidden = false
        mainPicker.isHidden = true
        mainSchedule.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return transactionArr.count
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblLocation.dequeueReusableCell(withIdentifier: "locationCell") as! LoacationCell
        
        
        cell.selectionStyle = .none
        return  cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        placeView.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "parkDetailVC") as! ParkingDetailViewController
        vc.strVC = "find"
        
        self.navigationController?.pushViewController(vc, animated: true)
//        self.addChild(vc)
        
//        view.addSubview(vc.view)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "parkDetailVC") as! ParkingDetailViewController
//         vc.strVC = "find"
//        self.addChild(vc)
//        view.addSubview(vc.view)
//      //   placeView.isHidden = true
//        placeView.isHidden = true
//        self.tabBarController?.tabBar.isHidden = true
//        self.navigationController?.navigationBar.isHidden = true
        
    }
    
  
    
    
    @IBAction func CancelClick(_ sender: Any) {
        // tblLocation.isHidden = true
        placeView.isHidden = true
        
         mainPicker.isHidden = true
        mainSchedule.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func SaveClick(_ sender: Any) {
       // tblLocation.isHidden = true
        placeView.isHidden = true
        mainPicker.isHidden = true
        mainSchedule.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
    }
    @IBAction func btnSchedule(_ sender: Any) {
        // tblLocation.isHidden = true
        placeView.isHidden = true
        mainSchedule.isHidden = false
        mainPicker.isHidden = true;
        self.tabBarController?.tabBar.isHidden = true
//        self.menuButton.isHidden = true
    }
    
    @IBAction func btnClickDate(_ sender: Any) {
//         tblLocation.isHidden = true
        placeView.isHidden = true
        mainPicker.isHidden = false
        mainSchedule.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
       
        
    }
    
 
    @IBAction func btnPlaceBack(_ sender: Any) {
        placeView.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func btnConfirmClick(_ sender: Any) {
        //tblLocation.isHidden = false
        placeView.isHidden = false
        mainPicker.isHidden = true
        mainSchedule.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "parkDetailVC") as! ParkingDetailViewController
        vc.strVC = "find"
         self.navigationController?.pushViewController(vc, animated: true)
       
        
    }
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            print("\(#function) -- \(self)")
        }
        
        @IBAction func presentAction() {
            present(ViewController.fromStoryboard, animated: true, completion: nil)
        }
        
        var randomColor: UIColor {
            let colors = [UIColor(hue:0.65, saturation:0.33, brightness:0.82, alpha:1.00),
                          UIColor(hue:0.57, saturation:0.04, brightness:0.89, alpha:1.00),
                          UIColor(hue:0.55, saturation:0.35, brightness:1.00, alpha:1.00),
                          UIColor(hue:0.38, saturation:0.09, brightness:0.84, alpha:1.00)]
            
            let index = Int(arc4random_uniform(UInt32(colors.count)))
            return colors[index]
        }
        
        func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
            print(#function)
        }
        
        func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
            print(#function)
        }

}
