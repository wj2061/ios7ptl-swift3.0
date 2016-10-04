//
//  ViewController.swift
//  TimeConsuming
//
//  Created by wj on 15/10/1.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    func dosomethingTimeconsuming(){
        Thread.sleep(forTimeInterval: 5)
    }
    
    @IBAction func dosomething(_ sender: UIButton) {
        sender.isEnabled=false
        activity.startAnimating()
        let bgQueue = DispatchQueue.global(qos: .default)
        bgQueue.async { () -> Void in
            self.dosomethingTimeconsuming()
            
            DispatchQueue.main.async{ () -> Void in
                self.activity.stopAnimating()
                sender.isEnabled=true
            }
        }
    }
}

