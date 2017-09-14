//
//  PTLScribbleLayoutManager.swift
//  ScribbleLayout
//
//  Created by wj on 15/11/27.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class PTLScribbleLayoutManager: NSLayoutManager {
    override func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        let characterRange = self.characterRange(forGlyphRange: glyphsToShow, actualGlyphRange: nil)
        
        textStorage?.enumerateAttribute(PTLDefault.RedactStyleAttributeName, in: characterRange, options: [], using: { (value, attributeCharacterRange, stop) -> Void in
            if let value  = value as? Bool{
                self.redactCharacterRange(attributeCharacterRange, ifTrue: value, atPoint:origin)
            }
        })
    }
    
    
    func redactCharacterRange(_ characterRange:NSRange,ifTrue:Bool,atPoint origin:CGPoint){
        let glyphRange = self.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
        if ifTrue{
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            context?.translateBy(x: origin.x, y: origin.y)
            UIColor.black.setStroke()
            
            let container = textContainer(forGlyphAt: glyphRange.location, effectiveRange: nil)
            enumerateEnclosingRects(forGlyphRange: glyphRange, withinSelectedGlyphRange: NSMakeRange(NSNotFound, 0), in: container!, using: { (rect , stop ) -> Void in
                self.drawRedactionInRect(rect)
            })
            context?.restoreGState()
        }else{
            super.drawGlyphs(forGlyphRange: glyphRange, at: origin)
        }
    }
    
    func drawRedactionInRect(_ rect:CGRect){
        let path = UIBezierPath(rect: rect)
        let minX = rect.minX
        let minY = rect.minY
        let maxX = rect.maxX
        let maxY = rect.maxY
        path.move(to: CGPoint(x: minX, y: minY))
        path.addLine(to: CGPoint(x: maxX, y: maxY))
        path.move(to: CGPoint(x: maxX, y: minY))
        path.addLine(to: CGPoint(x: minX, y: maxY))
        path.stroke()
    }
    
    override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)
        
        let context = UIGraphicsGetCurrentContext()
        let characterRange = self.characterRange(forGlyphRange: glyphsToShow, actualGlyphRange: nil)
        
        textStorage?.enumerateAttribute(PTLDefault.HighlightColorAttributeName, in: characterRange, options: [], using: { (value , highlightedCharacterRange, stop) -> Void in
            if let color = value as? UIColor{
                self.highlightCharacterRange(highlightedCharacterRange, color: color, origin: origin, context: context!)
            }
        })
    }
    
    func highlightCharacterRange(_ highlightedCharacterRange:NSRange,color:UIColor,origin:CGPoint,context:CGContext){
        context.saveGState()
        color.setFill()
        context.translateBy(x: origin.x, y: origin.y)
        
        let highlightedGlyphRange = self.glyphRange(forCharacterRange: highlightedCharacterRange, actualCharacterRange: nil)
        let container = self.textContainer(forGlyphAt: highlightedGlyphRange.location, effectiveRange: nil)
        
        self.enumerateEnclosingRects(forGlyphRange: highlightedGlyphRange, withinSelectedGlyphRange: NSMakeRange(NSNotFound, 0), in: container!) { (rect , stop ) -> Void in
            self.drawHighlightInRect(rect)
        }
        context.restoreGState()
        
    }
    
    func drawHighlightInRect(_ rect :CGRect){
        let highlightRect = rect.insetBy(dx: -3, dy: -3)
        UIRectFill(highlightRect)
        UIBezierPath(ovalIn: highlightRect).stroke()
    }
}
