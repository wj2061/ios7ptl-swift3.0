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
        contentMode = UIViewContentMode.redraw
    }
    
    @inline(__always) func  CGAffineTransformMakeScaleTranslate (_ sx:CGFloat,sy:CGFloat,dx:CGFloat,dy:CGFloat)->CGAffineTransform{
        return CGAffineTransform(a: sx, b: 0, c: 0, d: sy, tx: dx, ty: dy);
    }
   
    override func draw(_ rect: CGRect) {
        let size = bounds.size
        let margin:CGFloat = 10
        
        UIColor.red.set()
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: 0, y: -1), radius: 1, startAngle: CGFloat(-M_PI), endAngle: 0, clockwise: true)
        path.addArc(withCenter: CGPoint(x: 1, y: 0), radius: 1, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI_2), clockwise: true)
        path.addArc(withCenter: CGPoint(x: 0, y: 1), radius: 1, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: true)
        path.addArc(withCenter: CGPoint(x: -1, y: 0), radius: 1, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(-M_PI_2), clockwise: true)

        let scale = floor((min(size.height, size.width) - margin)/4 )
        let tranform = CGAffineTransformMakeScaleTranslate(scale, sy: scale, dx: size.width/2, dy: size.height/2)
        path.apply(tranform)
        path.fill()
    }
}
