//
//  FlowerView.swift
//  Paths
//
//  Created by wj on 15/10/1.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class FlowerView: UIView {
    override func awakeFromNib() {
        contentMode = UIViewContentMode.Redraw
    }
    
    override func drawRect(rect: CGRect) {
        let size = bounds.size
        let margin:CGFloat = 10
        let radius = rint( min(size.width-margin, size.height-margin)/4 )
        
        let offset = rint( (size.height-size.width)/2 )
        let xOffset = offset>0 ?  rint(margin/2) : -offset
        let yOffset = offset>0 ? offset : rint(margin/2)
        
        UIColor.redColor().setFill()
        let path = UIBezierPath()
        path.addArcWithCenter(CGPoint(x: radius * 2 + xOffset,
                                      y: radius + yOffset),
                              radius: radius,
                          startAngle: CGFloat(-M_PI),
                            endAngle: 0,
                           clockwise: true)
        path.addArcWithCenter(CGPoint(x: radius * 3 + xOffset,
                                      y: radius * 2 + yOffset),
                             radius: radius,
                         startAngle: CGFloat(-M_PI_2),
                           endAngle: CGFloat(M_PI_2),
                          clockwise: true)
        path.addArcWithCenter(CGPoint(x: radius * 2 + xOffset,
                                      y: radius * 3 + yOffset),
                              radius: radius,
                          startAngle: 0,
                            endAngle: CGFloat(M_PI),
                           clockwise: true)
        path.addArcWithCenter(CGPoint(x: radius + xOffset,
                                      y: radius * 2 + yOffset),
                            radius: radius,
                        startAngle: CGFloat(M_PI_2),
                          endAngle: CGFloat(-M_PI_2),
                         clockwise: true)
        path.closePath()
        path.fill()
    }
}
