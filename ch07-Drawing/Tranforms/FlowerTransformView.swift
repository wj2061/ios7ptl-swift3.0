//
//  FlowerTransformView.swift
//  Tranforms
//
//  Created by wj on 15/10/2.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class FlowerTransformView: UIView {
    override func awakeFromNib() {
        contentMode = UIViewContentMode.Redraw
    }
    
    @inline(__always) func  CGAffineTransformMakeScaleTranslate (sx:CGFloat,sy:CGFloat,dx:CGFloat,dy:CGFloat)->CGAffineTransform{
        return CGAffineTransformMake(sx, 0, 0, sy, dx, dy);
    }
   
    override func drawRect(rect: CGRect) {
        let size = bounds.size
        let margin:CGFloat = 10
        
        UIColor.redColor().set()
        let path = UIBezierPath()
        path.addArcWithCenter(CGPointMake(0, -1), radius: 1, startAngle: CGFloat(-M_PI), endAngle: 0, clockwise: true)
        path.addArcWithCenter(CGPointMake(1, 0), radius: 1, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI_2), clockwise: true)
        path.addArcWithCenter(CGPointMake(0, 1), radius: 1, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: true)
        path.addArcWithCenter(CGPointMake(-1, 0), radius: 1, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(-M_PI_2), clockwise: true)

        let scale = floor((min(size.height, size.width) - margin)/4 )
        let tranform = CGAffineTransformMakeScaleTranslate(scale, sy: scale, dx: size.width/2, dy: size.height/2)
        path.applyTransform(tranform)
        path.fill()
    }
}
