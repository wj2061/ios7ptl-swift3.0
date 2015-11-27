//
//  ViewController.swift
//  CurvyText
//
//  Created by WJ on 15/11/27.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let curvyTextView = CurvyTextView(frame: view.bounds)
        view.addSubview(curvyTextView)
        
        let string = "You can display text along a curve, with bold, color, and big text."
        
        let attriString = NSMutableAttributedString(string: string, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(16)])
        attriString.addAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(16)], range: (string as NSString).rangeOfString("bold"))
        attriString.addAttributes([NSForegroundColorAttributeName:UIColor.redColor()], range: (string as NSString).rangeOfString("color"))
        attriString.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(32)], range: (string as NSString).rangeOfString("big text"))
        
        curvyTextView.attributedString = attriString
    }

}

