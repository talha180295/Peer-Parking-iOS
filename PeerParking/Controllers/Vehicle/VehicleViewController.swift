//
//  VehicleViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 06/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class VehicleViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{

    var indexRow = 0
    @IBOutlet weak var tblVehcle: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        tblVehcle.dataSource =  self
        tblVehcle.delegate = self
        
        tblVehcle.register(UINib(nibName: "vehicleCell", bundle: nil), forCellReuseIdentifier: "vehicleCell")
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return transactionArr.count
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVehcle.dequeueReusableCell(withIdentifier: "vehicleCell") as! vehicleCell
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
        tblVehcle.reloadData()
       
    }
    

    @IBAction func btnVehicleAdd(_ sender: Any) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "addVehicleVC") as! AddVehicleViewController
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
