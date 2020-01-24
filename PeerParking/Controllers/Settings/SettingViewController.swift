//
//  SettingViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 06/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var changePassBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.integer(forKey: "is_social_login") == 1{
            
              self.changePassBtn.isHidden = true
        }
   
        else
        {
            self.changePassBtn.isHidden = false
        }
        

       
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnChange(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "changeVC") as! ChangePassViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func aboutBtn(_ sender: UIButton) {
        openWebView(webPage: "about-peer-parking")
    }
    
    @IBAction func termsBtn(_ sender: UIButton) {
        openWebView(webPage: "terms-of-use")
    }
    
    
    @IBAction func privacyBtn(_ sender: UIButton) {
        openWebView(webPage: "privacy-policy")
    }
    
    @IBAction func rateBtn(_ sender: UIButton) {
        openWebView(webPage: "rate-this-app")
    }
    
    
    @IBAction func legalBtn(_ sender: UIButton) {
        openWebView(webPage: "legal-information")
    }
    
    @IBAction func creditsBtn(_ sender: UIButton) {
        
        openWebView(webPage: "credits")
    }
    
    
    
    func openWebView(webPage:String){
        
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebView") as! WebView
        vc.webUrl = APP_CONSTANT.PAGE_URL+webPage
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    
    
}
