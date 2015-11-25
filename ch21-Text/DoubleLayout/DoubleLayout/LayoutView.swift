//
//  LayoutView.swift
//  DoubleLayout
//
//  Created by WJ on 15/11/25.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class LayoutView: UIView ,NSLayoutManagerDelegate{
    
    @IBOutlet weak var textView: UITextView!
    
    let textcontainer1 = NSTextContainer()
    let textcontainer2 = NSTextContainer()
    let layoutManager  = NSLayoutManager()
    
    override func awakeFromNib() {
        let size = CGSize(width: CGRectGetWidth(bounds), height: CGRectGetMidY(bounds)*0.75)
        textcontainer1.size = size
        textcontainer2.size = size
        
        layoutManager.delegate = self
        layoutManager.addTextContainer(textcontainer1)
        layoutManager.addTextContainer(textcontainer2)
        
        textView.textStorage.addLayoutManager(layoutManager)
    }
    
    func layoutManagerDidInvalidateLayout(sender: NSLayoutManager) {
        setNeedsDisplay()
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        drawText(textcontainer1, point: CGPointZero)
        
        let box2Corner = CGPointMake(CGRectGetMinX(bounds), CGRectGetMidY(bounds))
        
        drawText(textcontainer2, point: box2Corner)
    }
    
    private func drawText(textcontainer:NSTextContainer,point:CGPoint){
        let box = CGRect(origin: point, size: textcontainer.size)
        UIRectFrame(box)
        
        let range = layoutManager.glyphRangeForTextContainer(textcontainer)
        layoutManager.drawBackgroundForGlyphRange(range , atPoint: point)
        layoutManager.drawGlyphsForGlyphRange(range, atPoint: point)
    }

}
