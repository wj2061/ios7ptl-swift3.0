//
//  JuliaCell.swift
//  JuliaOp
//
//  Created by wj on 15/10/15.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class JuliaCell: UICollectionViewCell {
    func  configureWith(_ seed:Int, queue:OperationQueue, scales:[CGFloat]){
        let maxScale = UIScreen.main.scale
        contentScaleFactor = maxScale
        
        let kIterations = 6.0
        let minScale = maxScale / CGFloat( pow(2.0, kIterations) )
        
        var preOp :JuliaOperation?
        
        var scale = minScale
        repeat{
            let op = operationForScale(scale, seed: seed)
            if preOp != nil{
                op.addDependency(preOp!)
            }
            operations.append(op)
            queue.addOperation(op)
            preOp = op
            scale *= 2
        }while scale <= maxScale
        
        
//        for var scale = minScale ;scale<maxScale; scale *= 2{
//            let op = operationForScale(scale, seed: seed)
//            if preOp != nil{
//                op.addDependency(preOp!)
//            }
//            operations.append(op)
//            queue.addOperation(op)
//            preOp = op
//        }
    }
    
    func operationForScale(_ scale:CGFloat,seed:Int)->JuliaOperation{
        let  op = JuliaOperation()
        op.contentScaleFactor = scale
        
        op.width = Int( bounds.width * scale )
        op.height = Int( bounds.height * scale )
        
        srandom(UInt32(seed))
        
        op.c = Double(Int(arc4random())/Int.max) + Double(Int(arc4random())/Int.max).i
        op.blowup = Double( arc4random() ) + 0.i
        op.rScale = Int(arc4random())%20
        op.gScale = Int(arc4random())%20
        op.bScale = Int(arc4random())%20
        
       
        weak  var weakOp  = op
        op.completionBlock = {
            if !weakOp!.isCancelled{
                OperationQueue.main.addOperation({ () -> Void in
                    let strongop = weakOp
                    if (strongop != nil &&  self.operations.contains(strongop!) ){
                        self.imageView.image = strongop?.image
                        self.label.text = strongop?.description
                        let k = self.operations.index(of: strongop!)
                        self.operations.remove(at: k!)
                    }
                })
            }
        }
        
        if scale<0.5{
            op.queuePriority = Operation.QueuePriority.low
        }else if scale <=  1{
            op.queuePriority = Operation.QueuePriority.high
        }else{
            op.queuePriority = Operation.QueuePriority.normal
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
    
    var operations = [Operation]()
}
