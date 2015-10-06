//
//  CircleView.swift
//  ViewAnimation
//
//  Created by wj on 15/10/6.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        opaque = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        opaque = false
    }
    
    override func drawRect(rect: CGRect) {
         UIColor.redColor().setFill()
         UIBezierPath(ovalInRect: bounds).fill()
     }


}
