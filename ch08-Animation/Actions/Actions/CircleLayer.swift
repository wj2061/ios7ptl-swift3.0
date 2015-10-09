//
//  CircleLayer.swift
//  Actions
//
//  Created by wj on 15/10/10.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class CircleLayer: CALayer {
    var radius:CGFloat = 0{ didSet{setNeedsDisplay()} }
    
    override init() {
        super.init()
        setNeedsDisplay()
    }
    override init(layer: AnyObject) {
        super.init()
        setNeedsDisplay()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNeedsDisplay()
        fatalError("init(coder:) has not been implemented")
    }

    override func drawInContext(ctx: CGContext) {
        CGContextSetFillColorWithColor(ctx, UIColor.redColor().CGColor)
        let rect = CGRect(x: (bounds.size.width-radius)/2,
                          y: (bounds.size.height-radius)/2,
                      width: radius,
                     height: radius)
        CGContextAddEllipseInRect(ctx, rect)
        CGContextFillPath(ctx)
    }
    
    override class func needsDisplayForKey(key: String) -> Bool{
        if key == "radius"{return true}
        return super.needsDisplayForKey(key)
    }
    
    override func actionForKey(event: String) -> CAAction? {
        if let layer = presentationLayer() {
            print(event)
            if event == "radius"{
                print("11")
                let anim = CABasicAnimation(keyPath: "radius")
                anim.fromValue = layer.valueForKey("radius")
                return anim
            }
        }
        return super.actionForKey(event)
    }
    
}
