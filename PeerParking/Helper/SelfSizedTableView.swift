//
//  SelfSizedTableView.swift
//  AdjustableTableView
//
//  Created by Dushyant Bansal on 25/02/18.
//  Copyright © 2018 db42.in. All rights reserved.
//
import UIKit

class SelfSizedTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}
