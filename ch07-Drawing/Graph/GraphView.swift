//
//  GraphView.swift
//  Graph
//
//  Created by wj on 15/10/2.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class GraphView: UIView {
   var values = [CGFloat]()
   
    let timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue())
    
    @inline(__always) func CGAffineTransformMakeScaleTranslate(sx:CGFloat,sy:CGFloat,dx:CGFloat,dy:CGFloat)->CGAffineTransform{
        return CGAffineTransformMake(sx, 0, 0, sy, dx, dy)
    }
    
    override func awakeFromNib() {
        contentMode = UIViewContentMode.Right
        weak var weakself = self
        let delay:UInt64 = UInt64( Double(NSEC_PER_SEC)*0.25 )
        dispatch_source_set_timer(timer, dispatch_walltime(nil  , 0), delay, 0)
        dispatch_source_set_event_handler(timer) { () -> Void in
            weakself!.updateValues()
        }
        dispatch_resume(timer)
    }
    
    private struct KScale  {
       static let x:CGFloat = 5.0
       static let y:CGFloat = 100.0
    }
    
    func updateValues(){
        let nextValue = sin(CFAbsoluteTimeGetCurrent()) + Double(rand())/Double(RAND_MAX)
        values.append(CGFloat(nextValue))
        print("\(nextValue) = \(values.count)")
        let size = bounds.size
        let maxDimension = max(size.width, size.height)
        let maxValues = Int( maxDimension/KScale.x )
        
        if values.count > maxValues {
            values.removeRange(Range(start: 0,end: values.count-maxValues))
        }
        
        setNeedsDisplay()
    }
    
    deinit{
        print("deinit")
        dispatch_source_cancel(timer)
    }
    
    override func drawRect(rect: CGRect) {
        if var  y = values.first{
            let ctx = UIGraphicsGetCurrentContext()
            CGContextSetStrokeColorWithColor(ctx, UIColor.redColor().CGColor)
            CGContextSetLineJoin(ctx, CGLineJoin.Round)
            CGContextSetLineWidth(ctx, 5.0)
            
            let pathref = CGPathCreateMutable()
            let yOffset = bounds.size.height/2
            
            var transform = CGAffineTransformMakeScaleTranslate(KScale.x, sy: KScale.y, dx: 0, dy: yOffset)
            
            CGPathMoveToPoint(pathref, &transform, 0, y)
            for x in 1..<values.count{
               y = values[x]
                CGPathAddLineToPoint(pathref, &transform, CGFloat( x ), y)
            }
            
            CGContextAddPath(ctx, pathref)
            CGContextStrokePath(ctx)
      
        }
    }
    

}
