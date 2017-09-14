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
        let path = Bundle.main.path(forResource: "Lipsum", ofType: "txt")!
        let st   = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        return st
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var alignment = CTTextAlignment.justified
        var  setting   = CTParagraphStyleSetting(spec: .alignment, valueSize: MemoryLayout<CTTextAlignment>.size, value: &alignment)
        let style = CTParagraphStyleCreate(&setting, 1)
        
        let attrString = NSAttributedString(string: kLipsum!, attributes: [kCTParagraphStyleAttributeName as String:style])
        
        let columnView = ColumnView(frame: self.view.bounds)
        columnView.attributedString = attrString
        
        view.addSubview(columnView)
    }
}

