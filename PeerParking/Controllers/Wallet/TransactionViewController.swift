//
//  TransactionViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 06/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import NotificationCenter
class TransactionViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var transactions = [TransactionModel]()
    
    @IBOutlet weak var navBarView: UIView!
    
    @IBOutlet weak var tblTransaction: UITableView!
    @IBOutlet weak var imgBottom: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    let closeThresholdHeight: CGFloat = 150
    let openThreshold: CGFloat = UIScreen.main.bounds.height - 200
    let closeThreshold = UIScreen.main.bounds.height - 90 // same value as closeThresholdHeight
    var panGestureRecognizer: UIPanGestureRecognizer?
    var animator: UIViewPropertyAnimator?
    
    private var lockPan = false
    
    override func viewDidLoad() {
//        gotPanned(0)
        super.viewDidLoad()
        
        tblTransaction.tableFooterView = UIView()
        
        //        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(respondToPanGesture))
        //        view.addGestureRecognizer(gestureRecognizer)
        //        gestureRecognizer.delegate = self
        //        panGestureRecognizer = gestureRecognizer
        
        
        tblTransaction.dataSource =  self
        tblTransaction.delegate = self
        
        tblTransaction.register(UINib(nibName: "transactionCell", bundle: nil), forCellReuseIdentifier: "transactionCell")
        // Do any additional setup after loading the view.
        
        //        self.tblTransaction.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "headerCell")
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getTransactions()
        
    }
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 3
    //    }
    // return the number of rows in the specified section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        var rowCount = 0
        //        switch (section) {
        //        case 0:
        //            rowCount = 2
        //        case 1:
        //            rowCount = 2
        //        case 2:
        //            rowCount = 2
        //        default:
        //            rowCount = 0
        //        }
        
        return self.transactions.count
    }
    
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 70.0
    //    }
    // Header Cell
    //     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCell
    //
    //
    //
    //
    //        return headerCell
    //    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblTransaction.dequeueReusableCell(withIdentifier: "transactionCell") as! transactionCell
        
        let ammount = self.transactions[indexPath.row].amount ?? 0.0
        let preAmmount = self.transactions[indexPath.row].previousAmount ?? 0.0
        let date = self.transactions[indexPath.row].updatedAt ?? ""
        
        cell.selectionStyle = .none
        cell.parkingPrice.text = "$ \(ammount)"
        
        
        cell.date.text = Helper().getFormatedDate(dateStr: date)
        
        if(self.transactions[indexPath.row].type == 10){
            cell.transactionFeeLabel.isHidden = false
            cell.tranFee.isHidden = false
            
            if(self.transactions[indexPath.row].transactionType == 10){
                cell.parkingSoldOrBought.text = "Parking Sold"
                let bal = preAmmount + ammount
                cell.balance.text = "$ \(bal)"
            }
            else if(self.transactions[indexPath.row].transactionType == 10){
                cell.parkingSoldOrBought.text = "Parking Bought"
                let bal = preAmmount - ammount
                cell.balance.text = "$ \(bal)"
            }
            //             cell.tranFee.text
        }
        else if(self.transactions[indexPath.row].type == 20){
            cell.transactionFeeLabel.isHidden = true
            cell.tranFee.isHidden = true
            if(self.transactions[indexPath.row].transactionType == 10){
                cell.parkingSoldOrBought.text = "Top Up"
                
                let bal = preAmmount + ammount
                cell.balance.text = "$ \(bal)"
            }
            else if(self.transactions[indexPath.row].transactionType == 10){
                cell.parkingSoldOrBought.text = "Withdrawl"
                let bal = preAmmount - ammount
                cell.balance.text = "$ \(bal)"
            }
        }
        
        
        return  cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
//    func gotPanned(_ percentage: Int) {
//        if animator == nil {
//            animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
//                // let scaleTransform = CGAffineTransform(scaleX: 1, y: 5).concatenating(CGAffineTransform(translationX: 0, y: 240))
//                //self.navBarView.transform = scaleTransform
//                // self.navBarView.alpha = 0
//                if(percentage >= 50)
//                {
//                    self.navBarView.backgroundColor = #colorLiteral(red: 0.9763647914, green: 0.9765316844, blue: 0.9763541818, alpha: 1)
//                    self.navBarView.borderColor = #colorLiteral(red: 0.9136260152, green: 0.9137827754, blue: 0.9136161804, alpha: 0.9334837148)
//                    self.navBarView.borderWidth = 1
//                    // self.imgBottom.isHidden = true
//                    self.btnBack.setImage(UIImage.init(named: "icon_up"), for: .normal )
//                }
//                else
//                {
//                    self.navBarView.backgroundColor = .white;
//                    self.navBarView.borderColor = .white;
//                    //self.imgBottom.isHidden = false
//                    self.btnBack.setImage(UIImage.init(named: "icon_down"), for: .normal )
//                }
//            })
//            animator?.isReversed = true
//            animator?.startAnimation()
//            animator?.pauseAnimation()
//        }
//        animator?.fractionComplete = CGFloat(percentage) / 100
//
//        if(percentage >= 50)
//        {
//            self.btnBack.setImage(UIImage.init(named: "icon_down"), for: .normal )
//        }
//        else
//        {
//            self.btnBack.setImage(UIImage.init(named: "icon_up"), for: .normal )
//        }
//        // print(animator?.fractionComplete)
//    }
    
//    // MARK: methods to make the view draggable
//
//    @objc func respondToPanGesture(recognizer: UIPanGestureRecognizer) {
//        guard !lockPan else { return }
//        if recognizer.state == .ended {
//
//            let maxY = UIScreen.main.bounds.height - CGFloat(openThreshold)
//
//            lockPan = true
//            if maxY > self.view.frame.minY {
//                maximize { self.lockPan = false }
//                print("::=maxY=\(maxY)")
//            } else {
//                minimize { self.lockPan = false }
//                print("::=minY=\(maxY)")
//            }
//            return
//        }
//        let translation = recognizer.translation(in: self.view)
//        moveToY(self.view.frame.minY + translation.y)
//        recognizer.setTranslation(.zero, in: self.view)
//    }
//
//    func maximize(completion: (() -> Void)?) {
//        UIView.animate(withDuration: 0.2, animations: {
//            self.moveToY(0)
//        }) { _ in
//            if let completion = completion {
//                completion()
//            }
//        }
//    }
//
//    func minimize(completion: (() -> Void)?) {
//        UIView.animate(withDuration: 0.2, animations: {
//            self.moveToY(self.closeThreshold)
//        }) { _ in
//            if let completion = completion {
//                completion()
//            }
//        }
//    }
//
//    private func moveToY(_ position: CGFloat) {
//        view.frame = CGRect(x: 0, y: position, width: view.frame.width, height: view.frame.height)
//
//        let maxHeight = view.frame.height - closeThresholdHeight
//        let percentage = Int(100 - ((position * 100) / maxHeight))
//
//        print("percentage=\(percentage)")
//        gotPanned(percentage)
//
//        let name = NSNotification.Name(rawValue: "BottomViewMoved")
//        NotificationCenter.default.post(name: name, object: nil, userInfo: ["percentage": percentage])
//    }
//
    
    func getTransactions(){
        
        let params:[String:Any] = ["is_mine" : 1]
        
        APIClient.serverRequest(url: APIRouter.getTransactions(params), path: APIRouter.getTransactions(params).getPath(), dec: ResponseData<[TransactionModel]>.self) { (response, error) in
            
            if(response != nil){
                
                if (response?.success) != nil {
                    
                    Helper().showToast(message: response?.message ?? "No Response", controller: self)
                    if let val = response?.data {
                        
                        self.transactions = val
                        print(val)
                        self.tblTransaction.reloadData()
                    }
                }
                else{
                    Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                }
            }
            else if(error != nil){
                Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
            }
            else{
                Helper().showToast(message: "Nor Response and Error!!", controller: self)
            }
        }
        
    }
}
