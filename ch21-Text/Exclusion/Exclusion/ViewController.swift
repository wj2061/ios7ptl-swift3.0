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
        let path = Bundle.main.path(forResource: "sample.txt", ofType: nil)
        var st:String?
        do {
             st  = try NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue) as String
        }catch let error as NSError{
            print(error.description)
            return
        }
        
        textView.text = st
        textView.textAlignment = .justified
        
        let bounds = self.view.bounds
        let width  = bounds.width
        let height = bounds.height
        let rect   = bounds.insetBy(dx: width/4, dy: height/4)
        let exclusionPath = UIBezierPath(roundedRect: rect, cornerRadius: width/10)
        textView.textContainer.exclusionPaths = [exclusionPath]
    }
}

