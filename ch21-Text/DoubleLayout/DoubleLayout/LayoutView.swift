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
        let size = CGSize(width: bounds.width, height: bounds.midY*0.75)
        textcontainer1.size = size
        textcontainer2.size = size
        
        layoutManager.delegate = self
        layoutManager.addTextContainer(textcontainer1)
        layoutManager.addTextContainer(textcontainer2)
        
        textView.textStorage.addLayoutManager(layoutManager)
    }
    
    func layoutManagerDidInvalidateLayout(_ sender: NSLayoutManager) {
        setNeedsDisplay()
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        drawText(textcontainer1, point: CGPoint.zero)
        
        let box2Corner = CGPoint(x: bounds.minX, y: bounds.midY)
        
        drawText(textcontainer2, point: box2Corner)
    }
    
    fileprivate func drawText(_ textcontainer:NSTextContainer,point:CGPoint){
        let box = CGRect(origin: point, size: textcontainer.size)
        UIRectFrame(box)
        
        let range = layoutManager.glyphRange(for: textcontainer)
        layoutManager.drawBackground(forGlyphRange: range , at: point)
        layoutManager.drawGlyphs(forGlyphRange: range, at: point)
    }

}
