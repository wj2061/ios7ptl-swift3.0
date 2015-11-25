//
//  ViewController.swift
//  Exclusion
//
//  Created by wj on 15/11/25.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSBundle.mainBundle().pathForResource("sample.txt", ofType: nil)
        var st:String?
        do {
             st  = try NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding) as String
        }catch let error as NSError{
            print(error.description)
            return
        }
        
        textView.text = st
        textView.textAlignment = .Justified
        
        let bounds = self.view.bounds
        let width  = CGRectGetWidth(bounds)
        let height = CGRectGetHeight(bounds)
        let rect   = CGRectInset(bounds, width/4, height/4)
        let exclusionPath = UIBezierPath(roundedRect: rect, cornerRadius: width/10)
        textView.textContainer.exclusionPaths = [exclusionPath]
    }
}

