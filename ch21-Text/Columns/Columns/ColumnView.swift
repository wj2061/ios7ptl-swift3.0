//
//  ColumnView.swift
//  Columns
//
//  Created by wj on 15/11/28.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
let kColumnCount = 3

class ColumnView: UIView {
    var mode = 0
    var attributedString:NSAttributedString?
    
    private func copyColumnRects()->[CGRect]{
        let bounds = CGRectInset(self.bounds, 20, 20)
        
        var columnRects = Array.init(count: 3, repeatedValue: CGRectZero)
        
        let columnWidth = CGRectGetWidth(bounds) / CGFloat( kColumnCount)
        
        for i in 0..<kColumnCount{
            columnRects[i] = CGRectMake(CGFloat(i)*columnWidth + CGRectGetMinX(bounds), CGRectGetMinY(bounds), columnWidth, bounds.height)
            columnRects[i] = CGRectInset(columnRects[i], 10, 10)
        }
        return columnRects
    }
    
    func copyPaths()->[CGPathRef]{
        var paths = [CGPathRef]()
        let columnRects = copyColumnRects()
        switch mode{
        case 0:
            for i in 0..<kColumnCount{
                let path = CGPathCreateWithRect(columnRects[i], nil)
                paths.append(path)
            }
        case 1:
            let path = CGPathCreateMutable()
            for i in 0..<kColumnCount{
                CGPathAddRect(path, nil, columnRects[i])
            }
            paths.append(path)
        case 2:
            var path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 30, 0)
            CGPathAddLineToPoint(path, nil, 344, 30)  // Bottom right
            
            CGPathAddLineToPoint(path, nil, 344, 400)
            CGPathAddLineToPoint(path, nil, 200, 400)
            CGPathAddLineToPoint(path, nil, 200, 800)
            CGPathAddLineToPoint(path, nil, 344, 800)
            
            CGPathAddLineToPoint(path, nil, 344, 944) // Top right
            CGPathAddLineToPoint(path, nil, 30, 944) // Top left
            CGPathCloseSubpath(path)
            paths.append(path)
            
            path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 700, 30)// Bottom right
            CGPathAddLineToPoint(path, nil, 360, 30)  // Bottom left
            
            CGPathAddLineToPoint(path, nil, 360, 400)
            CGPathAddLineToPoint(path, nil, 500, 400)
            CGPathAddLineToPoint(path, nil, 500, 800)
            CGPathAddLineToPoint(path, nil, 360, 800)
            
            CGPathAddLineToPoint(path, nil, 360, 944) // Top left
            CGPathAddLineToPoint(path, nil, 700, 944) // Top right
            CGPathCloseSubpath(path)
            paths.append(path)
        case 3:
            let path = CGPathCreateWithEllipseInRect(CGRectInset(bounds, 30, 30), nil)
            paths.append(path)
        default:
            break
        }
        print(paths.count)
        return paths
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let  transform = CGAffineTransformMakeScale(1, -1)
        CGAffineTransformTranslate(transform, 0, -self.bounds.size.height)
        self.transform = transform
        backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        if attributedString == nil {return}
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetTextMatrix(context, CGAffineTransformIdentity)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString!)
        let paths = copyPaths()
        var charIndex = 0
        for i in 0..<paths.count{
            let path = paths[i]
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(charIndex, 0), path, nil)
            CTFrameDraw(frame, context!)
            let frameRange = CTFrameGetVisibleStringRange(frame)
            charIndex += frameRange.length
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        mode = (mode + 1)%4
        setNeedsDisplay()
    }

}
