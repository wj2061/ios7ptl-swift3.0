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
    
    fileprivate func copyColumnRects()->[CGRect]{
        let bounds = self.bounds.insetBy(dx: 20, dy: 20)
        
        var columnRects = Array.init(repeating: CGRect.zero, count: 3)
        
        let columnWidth = bounds.width / CGFloat( kColumnCount)
        
        for i in 0..<kColumnCount{
            columnRects[i] = CGRect(x: CGFloat(i)*columnWidth + bounds.minX, y: bounds.minY, width: columnWidth, height: bounds.height)
            columnRects[i] = columnRects[i].insetBy(dx: 10, dy: 10)
        }
        return columnRects
    }
    
    func copyPaths()->[CGPath]{
        var paths = [CGPath]()
        let columnRects = copyColumnRects()
        switch mode{
        case 0:
            for i in 0..<kColumnCount{
                let path = CGPath(rect: columnRects[i], transform: nil)
                paths.append(path)
            }
        case 1:
            let path = CGMutablePath()
            for i in 0..<kColumnCount{
                path.addRect(columnRects[i]);
            }
            paths.append(path)
        case 2:
            var path = CGMutablePath()
        
            path.move(to: CGPoint(x:30, y:0));
            path.addLine(to: CGPoint(x: 344, y: 30));// Bottom right
            
            path.addLine(to: CGPoint(x: 344, y: 400));
            path.addLine(to: CGPoint(x: 200, y: 400));
            path.addLine(to: CGPoint(x: 200, y: 800));
            path.addLine(to: CGPoint(x: 344, y: 800));
            
            path.addLine(to: CGPoint(x: 344, y: 944));// Top right
            path.addLine(to: CGPoint(x: 30, y: 944));// Top left
            
            path.closeSubpath()
            paths.append(path)
            
            path = CGMutablePath()
            
            path.move(to: CGPoint(x:700, y:30));
            path.addLine(to: CGPoint(x: 360, y: 30));
            
            path.addLine(to: CGPoint(x: 360, y: 400));
            path.addLine(to: CGPoint(x: 500, y: 400));
            path.addLine(to: CGPoint(x: 500, y: 800));
            path.addLine(to: CGPoint(x: 360, y: 800));
            
            path.addLine(to: CGPoint(x: 360, y: 944));// Top left
            path.addLine(to: CGPoint(x: 700, y: 944));// Top right
            
            path.closeSubpath()
            paths.append(path)
        case 3:
            let path = CGPath(ellipseIn: bounds.insetBy(dx: 30, dy: 30), transform: nil)
            paths.append(path)
        default:
            break
        }
        print(paths.count)
        return paths
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let  transform = CGAffineTransform(scaleX: 1, y: -1)
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
        if attributedString == nil {return}
        
        let context = UIGraphicsGetCurrentContext()
        context!.textMatrix = CGAffineTransform.identity
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        mode = (mode + 1)%4
        setNeedsDisplay()
    }

}
