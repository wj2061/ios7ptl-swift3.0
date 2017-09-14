//
//  CoreTextLabel.swift
//  SimpleLayout
//
//  Created by wj on 15/11/28.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class CoreTextLabel: UIView {
    
    var attributedString=NSAttributedString() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let transform = CGAffineTransform(scaleX: 1, y: -1)
        transform.translatedBy(x: 0, y: -self.bounds.size.height)
        self.transform = transform
        backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.textMatrix = CGAffineTransform.identity
        
        let path = CGPath(rect: self.bounds, transform: nil)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        CTFrameDraw(frame , context!)
    }
}
