//
//  DelegateView.swift
//  Layers
//
//  Created by wj on 15/10/7.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class DelegateView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.setNeedsDisplay()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.setNeedsDisplay()
    }

    override func draw(_ layer: CALayer, in ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        UIColor.white.set()
        UIRectFill(layer.bounds)
        
        let font  = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        let color = UIColor.black
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let attribs = [NSFontAttributeName: font,
            NSForegroundColorAttributeName: color,
             NSParagraphStyleAttributeName: style
                      ]
        
        let text  = NSAttributedString(string: "Pushing The Limits", attributes: attribs)
        
        text.draw(in: layer.bounds.insetBy(dx: 10, dy: 100))
        UIGraphicsPopContext()
    }
    


}
