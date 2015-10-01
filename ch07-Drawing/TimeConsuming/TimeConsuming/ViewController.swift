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
        NSThread.sleepForTimeInterval(5)
    }
    
    @IBAction func dosomething(sender: UIButton) {
        sender.enabled=false
        activity.startAnimating()
        let bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(bgQueue) { () -> Void in
            self.dosomethingTimeconsuming()
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.activity.stopAnimating()
                sender.enabled=true
            })
        }
    }
}

