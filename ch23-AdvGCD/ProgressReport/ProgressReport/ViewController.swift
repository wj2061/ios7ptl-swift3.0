//
//  ViewController.swift
//  ProgressReport
//
//  Created by wj on 15/11/30.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func go(sender: UIButton) {
        let source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD
            , 0, 0, dispatch_get_main_queue())
        var totalComplete:UInt = 0
        dispatch_source_set_event_handler(source) { () -> Void in
            let value = dispatch_source_get_data(source)
            print(value)
            totalComplete += value
            self.progressView.progress = Float(totalComplete)/100
        }
        dispatch_resume(source)
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(queue) { () -> Void in
            for  _ in 0...100{
                dispatch_source_merge_data(source, 1)
                usleep(20000)
            }
        }
    }
}

