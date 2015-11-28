//
//  ViewController.swift
//  Columns
//
//  Created by wj on 15/11/28.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var kLipsum:String? =  {
        let path = NSBundle.mainBundle().pathForResource("Lipsum", ofType: "txt")!
        let st   = try? String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        return st
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var alignment = CTTextAlignment.Justified
        var  setting   = CTParagraphStyleSetting(spec: .Alignment, valueSize: sizeof(CTTextAlignment), value: &alignment)
        let style = CTParagraphStyleCreate(&setting, 1)
        
        let attrString = NSAttributedString(string: kLipsum!, attributes: [kCTParagraphStyleAttributeName as String:style])
        
        let columnView = ColumnView(frame: self.view.bounds)
        columnView.attributedString = attrString
        
        view.addSubview(columnView)
    }
}

