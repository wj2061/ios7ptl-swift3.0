//
//  PTLScribbleLayoutManager.swift
//  ScribbleLayout
//
//  Created by wj on 15/11/27.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class PTLScribbleLayoutManager: NSLayoutManager {
    override func drawGlyphsForGlyphRange(glyphsToShow: NSRange, atPoint origin: CGPoint) {
        let characterRange = characterRangeForGlyphRange(glyphsToShow, actualGlyphRange: nil)
        
        textStorage?.enumerateAttribute(PTLDefault.RedactStyleAttributeName, inRange: characterRange, options: [], usingBlock: { (value, attributeCharacterRange, stop) -> Void in
            if let value  = value as? Bool{
                self.redactCharacterRange(attributeCharacterRange, ifTrue: value, atPoint:origin)
            }
        })
    }
    
    
    func redactCharacterRange(characterRange:NSRange,ifTrue:Bool,atPoint origin:CGPoint){
        let glyphRange = glyphRangeForCharacterRange(characterRange, actualCharacterRange: nil)
        if ifTrue{
            let context = UIGraphicsGetCurrentContext()
            CGContextSaveGState(context)
            CGContextTranslateCTM(context , origin.x, origin.y)
            UIColor.blackColor().setStroke()
            
            let container = textContainerForGlyphAtIndex(glyphRange.location, effectiveRange: nil)
            enumerateEnclosingRectsForGlyphRange(glyphRange, withinSelectedGlyphRange: NSMakeRange(NSNotFound, 0), inTextContainer: container!, usingBlock: { (rect , stop ) -> Void in
                self.drawRedactionInRect(rect)
            })
            CGContextRestoreGState(context)
        }else{
            super.drawGlyphsForGlyphRange(glyphRange, atPoint: origin)
        }
    }
    
    func drawRedactionInRect(rect:CGRect){
        let path = UIBezierPath(rect: rect)
        let minX = CGRectGetMinX(rect)
        let minY = CGRectGetMinY(rect)
        let maxX = CGRectGetMaxX(rect)
        let maxY = CGRectGetMaxY(rect)
        path.moveToPoint(CGPointMake(minX, minY))
        path.addLineToPoint(CGPointMake(maxX, maxY))
        path.moveToPoint(CGPointMake(maxX, minY))
        path.addLineToPoint(CGPointMake(minX, maxY))
        path.stroke()
    }
    
    override func drawBackgroundForGlyphRange(glyphsToShow: NSRange, atPoint origin: CGPoint) {
        super.drawGlyphsForGlyphRange(glyphsToShow, atPoint: origin)
        
        let context = UIGraphicsGetCurrentContext()
        let characterRange = characterRangeForGlyphRange(glyphsToShow, actualGlyphRange: nil)
        
        textStorage?.enumerateAttribute(PTLDefault.HighlightColorAttributeName, inRange: characterRange, options: [], usingBlock: { (value , highlightedCharacterRange, stop) -> Void in
            if let color = value as? UIColor{
                self.highlightCharacterRange(highlightedCharacterRange, color: color, origin: origin, context: context!)
            }
        })
    }
    
    func highlightCharacterRange(highlightedCharacterRange:NSRange,color:UIColor,origin:CGPoint,context:CGContextRef){
        CGContextSaveGState(context)
        color.setFill()
        CGContextTranslateCTM(context, origin.x, origin.y)
        
        let highlightedGlyphRange = self.glyphRangeForCharacterRange(highlightedCharacterRange, actualCharacterRange: nil)
        let container = self.textContainerForGlyphAtIndex(highlightedGlyphRange.location, effectiveRange: nil)
        
        self.enumerateEnclosingRectsForGlyphRange(highlightedGlyphRange, withinSelectedGlyphRange: NSMakeRange(NSNotFound, 0), inTextContainer: container!) { (rect , stop ) -> Void in
            self.drawHighlightInRect(rect)
        }
        CGContextRestoreGState(context)
        
    }
    
    func drawHighlightInRect(rect :CGRect){
        let highlightRect = CGRectInset(rect , -3, -3)
        UIRectFill(highlightRect)
        UIBezierPath(ovalInRect: highlightRect).stroke()
    }
}
