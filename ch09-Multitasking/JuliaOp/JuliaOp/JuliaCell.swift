//
//  JuliaCell.swift
//  JuliaOp
//
//  Created by wj on 15/10/15.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class JuliaCell: UICollectionViewCell {
    func  configureWith(seed:Int, queue:NSOperationQueue, scales:[CGFloat]){
        let maxScale = UIScreen.mainScreen().scale
        contentScaleFactor = maxScale
        
        let kIterations = 6.0
        let minScale = maxScale / CGFloat( pow(2.0, kIterations) )
        
        var preOp :JuliaOperation?
        for var scale = minScale ;scale<maxScale; scale *= 2{
            let op = operationForScale(scale, seed: seed)
            if preOp != nil{
                op.addDependency(preOp!)
            }
            operations.append(op)
            queue.addOperation(op)
            preOp = op
        }
    }
    
    func operationForScale(scale:CGFloat,seed:Int)->JuliaOperation{
        let  op = JuliaOperation()
        op.contentScaleFactor = scale
        
        op.width = Int( CGRectGetWidth(bounds) * scale )
        op.height = Int( CGRectGetHeight(bounds) * scale )
        
        srandom(UInt32(seed))
        
        op.c = Double(random()%100) / 100.0 + Double(random()%100)/100.0.i
        op.blowup = Double( random() ) + Double( random() ).i 
        op.rScale = random()%20
        op.gScale = random()%20
        op.bScale = random()%20
        
       
        weak  var weakOp  = op
        op.completionBlock = {
            if !weakOp!.cancelled{
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    let strongop = weakOp
                    if (strongop != nil &&  self.operations.contains(strongop!) ){
                        self.imageView.image = strongop?.image
                        self.label.text = strongop?.description
                        let k = self.operations.indexOf(strongop!)
                        self.operations.removeAtIndex(k!)
                    }
                })
            }
        }
        
        if scale<0.5{
            op.queuePriority = NSOperationQueuePriority.Low
        }else if scale <=  1{
            op.queuePriority = NSOperationQueuePriority.High
        }else{
            op.queuePriority = NSOperationQueuePriority.Normal
        }
        return op
    }
    
    override func prepareForReuse() {
        for  operation in operations{
            operation.cancel()
        }
        operations.removeAll()
        imageView.image = nil
        label.text = ""
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    var operations = [NSOperation]()
}
