//
//  LayoutView.swift
//  DuplicateLayout
//
//  Created by WJ on 15/11/25.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class LayoutView: UIView ,NSLayoutManagerDelegate{
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer()
    
    @IBOutlet   weak var textView: UITextView!
    
    override func awakeFromNib() {
        var size = bounds.size
        size.width /= 2
        textContainer.size = size
        
        layoutManager.delegate = self
        layoutManager.addTextContainer(textContainer)
        
        textView.textStorage.addLayoutManager(layoutManager)
    }
    
    //MARK:- NSLayoutManagerDelegate
    func layoutManagerDidInvalidateLayout(sender: NSLayoutManager) {
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let range = layoutManager.glyphRangeForTextContainer(textContainer)
        let point = CGPointZero
        layoutManager.drawBackgroundForGlyphRange(range, atPoint: point)
        layoutManager.drawGlyphsForGlyphRange(range , atPoint: point)
        
    }



}
