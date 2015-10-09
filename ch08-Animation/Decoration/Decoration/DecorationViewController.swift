//
//  DecorationViewController.swift
//  Decoration
//
//  Created by wj on 15/10/9.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class DecorationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var layer = CALayer()
        layer.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        layer.cornerRadius = 10
        layer.backgroundColor = UIColor.redColor().CGColor
        layer.borderColor = UIColor.blueColor().CGColor
        layer.borderWidth = 5
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.addSublayer(layer)
        
        layer = CALayer()
        layer.frame = CGRect(x: 150, y: 150, width: 100, height: 100)
        layer.cornerRadius = 10
        layer.backgroundColor = UIColor.greenColor().CGColor
        layer.borderWidth = 5
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.addSublayer(layer)
    }
}
