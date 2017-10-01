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

    @IBAction func go(_ sender: UIButton) {
        let source = DispatchSource.makeUserDataAddSource(queue: DispatchQueue.main)
        var totalComplete:UInt = 0
        source.setEventHandler { () -> Void in
            let value = source.data
            print(value)
            totalComplete += value
            self.progressView.progress = Float(totalComplete)/100
        }
        source.resume()
        
        let queue = DispatchQueue.global()
        
        queue.async { () -> Void in
            for  _ in 0...100{
                source.add(data: 1)
                usleep(20000)
            }
        }
    }
}

