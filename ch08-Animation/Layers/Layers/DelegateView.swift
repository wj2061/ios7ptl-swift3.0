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
        print("1=\(layer.contentsScale)")
//        layer.contentsScale=UIScreen.mainScreen().scale
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.setNeedsDisplay()
        layer.contentsScale=UIScreen.mainScreen().scale
    }

    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
        print("2=\(layer.contentsScale)")

 
        UIGraphicsPushContext(ctx)
        UIColor.whiteColor().set()
        UIRectFill(layer.bounds)
        
        let font  = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        let color = UIColor.blackColor()
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.Center
        
        let attribs = [NSFontAttributeName: font,
            NSForegroundColorAttributeName: color,
             NSParagraphStyleAttributeName: style
                      ]
        
        let text  = NSAttributedString(string: "Pushing The Limits", attributes: attribs)
        
        text.drawInRect(CGRectInset(layer.bounds, 10, 100))
        UIGraphicsPopContext()
    }
    


}
