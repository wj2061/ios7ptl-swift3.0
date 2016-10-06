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
        isOpaque = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isOpaque = false
    }
    
    override func draw(_ rect: CGRect) {
         UIColor.red.setFill()
         UIBezierPath(ovalIn: bounds).fill()
     }


}
