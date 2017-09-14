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
        
        let attriString = NSMutableAttributedString(string: string, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)])
        attriString.addAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 16)], range: (string as NSString).range(of: "bold"))
        attriString.addAttributes([NSForegroundColorAttributeName:UIColor.red], range: (string as NSString).range(of: "color"))
        attriString.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 32)], range: (string as NSString).range(of: "big text"))
        
        curvyTextView.attributedString = attriString
    }

}

