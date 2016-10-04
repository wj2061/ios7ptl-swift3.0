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
        let scale = UIScreen.main.scale
        var x = label.frame.origin.x
        
        if x == floor(x){
            x = x + 0.5/scale
            print("blur")
        }else{
            x = CGFloat( floor(x) )
            print("unblur")
        }
        label.frame.origin.x=x
    }
}

