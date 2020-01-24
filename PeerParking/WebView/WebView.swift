//
//  WebView.swift
//  PeerParking
//
//  Created by Apple on 24/01/2020.
//  Copyright © 2020 Munzareen Atique. All rights reserved.
//

import UIKit
import WebKit

class WebView: UIViewController {

    @IBOutlet weak var webView: WKWebView!
//    var webView: WKWebView!
    var webUrl:String?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let url = URL(string: webUrl ?? "")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        // Do any additional setup after loading the view.
    }
    


}
