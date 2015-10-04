//
//  ViewController.swift
//  BlurryText
//
//  Created by wj on 15/10/4.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var label: UILabel!
    
    @IBAction func toggleBlur() {
        let scale = UIScreen.mainScreen().scale
        var x = label.frame.origin.x
        
        if x == floor(x){
            x = x + 0.5/scale
            print("11")
        }else{
            x = CGFloat( floor(x) )
            print("22")
        }
        label.frame.origin.x=x
    }
}

