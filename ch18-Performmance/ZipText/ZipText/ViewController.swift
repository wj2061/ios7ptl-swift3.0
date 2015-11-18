//
//  ViewController.swift
//  ZipText
//
//  Created by WJ on 15/11/18.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
let REVISION = 4

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("Lorem", ofType: "txt")!
        var text = ""
        do {
           text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
            print(text)
        }catch  let error as NSError{
            print("error : \(error)")
            return
        }
        var ztView :UIView
        switch REVISION{
        case 0:
            ztView = ZipTextView(frame: view.bounds, text:text)
        case 1:
            ztView = ZipTextView1(frame: view.bounds, text:text)
        case 2:
            ztView = ZipTextView2(frame: view.bounds, text:text)
        case 3:
            ztView = ZipTextView3(frame: view.bounds, text:text)
        case 4:
            ztView = ZipTextView4(frame: view.bounds, text:text)
        default:
            return
        }
        view.addSubview(ztView)
    }




}

