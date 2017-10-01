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
    
    lazy var semophore:DispatchSemaphore! = DispatchSemaphore(value: self.progressViews.count)
    let pendingQueue = DispatchQueue(label: "ProducerConsumer.pending", attributes: [])
    let workQueue    = DispatchQueue(label: "ProducerConsumer.work", attributes: DispatchQueue.Attributes.concurrent)
    var pendingJobCount = 0

    func adjustPendingJobCountBy(_ value:Int){
        DispatchQueue.main.async { () -> Void in
            self.pendingJobCount += value
            self.inQueueLabel.text = "\(self.pendingJobCount)"
        }
    }

    func reserveProgressView()->UIProgressView{
        var availableProgressView : UIProgressView!
        
        DispatchQueue.main.sync { () -> Void in
            for progressView in self.progressViews{
                if progressView.isHidden == true{
                    availableProgressView = progressView
                    break
                }
            }
            availableProgressView.isHidden = false
            availableProgressView.progress = 0
        }
        return availableProgressView
    }
    
    func releaseProgressView(_ view:UIProgressView){
        DispatchQueue.main.async { () -> Void in
            view.isHidden = true
        }
    }
    
    @IBAction func runProcess(_ sender: UIButton) {
        adjustPendingJobCountBy(1)
        
        pendingQueue.async { () -> Void in
            _ =  self.semophore.wait(timeout: DispatchTime.distantFuture)
            
            let availableProgressView = self.reserveProgressView()
            
            self.workQueue.async(execute: { () -> Void in
                self.performWorkWithProgressView(availableProgressView)
                
                self.releaseProgressView(availableProgressView)
                
                self.adjustPendingJobCountBy(-1)
                
                self.semophore.signal()
            })
        }
    }
    

    func performWorkWithProgressView(_ view:UIProgressView){
        for p in 0...100{
            DispatchQueue.main.sync(execute: { () -> Void in
                view.progress = Float(p)/100.0
            })
            usleep(50000)
        }
    }
}

