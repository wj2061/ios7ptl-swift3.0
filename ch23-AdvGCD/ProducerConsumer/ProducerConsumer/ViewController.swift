//
//  ViewController.swift
//  ProducerConsumer
//
//  Created by WJ on 15/11/30.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var inQueueLabel: UILabel!
    @IBOutlet var progressViews: [UIProgressView]!
    
    lazy var semophore:dispatch_semaphore_t! = dispatch_semaphore_create(self.progressViews.count)
    let pendingQueue = dispatch_queue_create("ProducerConsumer.pending", DISPATCH_QUEUE_SERIAL)
    let workQueue    = dispatch_queue_create("ProducerConsumer.work", DISPATCH_QUEUE_CONCURRENT)
    var pendingJobCount = 0

    func adjustPendingJobCountBy(value:Int){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.pendingJobCount += value
            self.inQueueLabel.text = "\(self.pendingJobCount)"
        }
    }

    func reserveProgressView()->UIProgressView{
        var availableProgressView : UIProgressView!
        
        dispatch_sync(dispatch_get_main_queue()) { () -> Void in
            for progressView in self.progressViews{
                if progressView.hidden == true{
                    availableProgressView = progressView
                    break
                }
            }
            availableProgressView.hidden = false
            availableProgressView.progress = 0
        }
        return availableProgressView
    }
    
    func releaseProgressView(view:UIProgressView){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            view.hidden = true
        }
    }
    
    @IBAction func runProcess(sender: UIButton) {
        adjustPendingJobCountBy(1)
        
        dispatch_async(pendingQueue) { () -> Void in
            dispatch_semaphore_wait(self.semophore, DISPATCH_TIME_FOREVER)
            
            let availableProgressView = self.reserveProgressView()
            
            dispatch_async(self.workQueue, { () -> Void in
                self.performWorkWithProgressView(availableProgressView)
                
                self.releaseProgressView(availableProgressView)
                
                self.adjustPendingJobCountBy(-1)
                
                dispatch_semaphore_signal(self.semophore)
            })
        }
    }
    

    func performWorkWithProgressView(view:UIProgressView){
        for p in 0...100{
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                view.progress = Float(p)/100.0
            })
            usleep(50000)
        }
    }
}

