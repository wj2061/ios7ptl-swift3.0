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
   
    let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
    
    @inline(__always) func CGAffineTransformMakeScaleTranslate(_ sx:CGFloat,sy:CGFloat,dx:CGFloat,dy:CGFloat)->CGAffineTransform{
        return CGAffineTransform(a: sx, b: 0, c: 0, d: sy, tx: dx, ty: dy)
    }
    
    override func awakeFromNib() {
        contentMode = UIViewContentMode.right
        weak var weakself = self
     
        timer.scheduleRepeating(deadline: DispatchTime.now(), interval: DispatchTimeInterval.milliseconds(250), leeway: DispatchTimeInterval.seconds(0))

        timer.setEventHandler { () -> Void in
            weakself!.updateValues()
        }
        timer.resume()
    }
    
    fileprivate struct KScale  {
       static let x:CGFloat = 5.0
       static let y:CGFloat = 100.0
    }
    
    func updateValues(){
        let nextValue = sin(CFAbsoluteTimeGetCurrent()) + Double(arc4random())/Double(RAND_MAX)
        values.append(CGFloat(nextValue))
        print("\(nextValue) = \(values.count)")
        let size = bounds.size
        //ptl  original way to calculate maxDimension
//        let maxDimension = max(size.width, size.height)
        
        //use width instead to make the Graph move as soon as possible
        let maxDimension = size.width
        
        let maxValues = Int( maxDimension/KScale.x )
        
        if values.count > maxValues {
            values.removeSubrange((0 ..< values.count-maxValues))
        }
        
        setNeedsDisplay()
    }
    
    deinit{
        print("deinit")
        timer.cancel()
    }
    
    override func draw(_ rect: CGRect) {
        if var  y = values.first{
            let ctx = UIGraphicsGetCurrentContext()
            ctx?.setStrokeColor(UIColor.red.cgColor)
            ctx?.setLineJoin(CGLineJoin.round)
            ctx?.setLineWidth(5.0)
            
            let pathref = CGMutablePath()
            let yOffset = bounds.size.height/2
            
            let transform = CGAffineTransformMakeScaleTranslate(KScale.x, sy: KScale.y, dx: 0, dy: yOffset)
            
            pathref.move(to:CGPoint(x:0,y:y), transform:transform)
            for x in 1..<values.count{
               y = values[x]
               pathref.addLine(to:CGPoint(x:CGFloat( x ), y:y), transform: transform)
            }
            
            ctx?.addPath(pathref)
            ctx?.strokePath()
      
        }
    }
    

}
