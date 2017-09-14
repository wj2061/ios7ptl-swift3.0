//
//  CurvyTextView.swift
//  CurvyText
//
//  Created by WJ on 15/11/27.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

let kControlPointSize:CGFloat = 13
let kStep:CGFloat = 0.001

class CurvyTextView: UIView {
    
    var P0 = CGPoint.zero
    var P1 = CGPoint.zero
    var P2 = CGPoint.zero
    var P3 = CGPoint.zero
    
    let layoutManager = NSLayoutManager()
    var textStorage   = NSTextStorage()
    
    func updateControlPoints(){
        let subviews = self.subviews
        P0 = subviews[0].center
        P1 = subviews[1].center
        P2 = subviews[2].center
        P3 = subviews[3].center
        setNeedsDisplay()
    }
    
    func addControlPoint(_ point:CGPoint,color:UIColor){
        let fullRect = CGRect(x: 0, y: 0, width: kControlPointSize*3, height: kControlPointSize*3)
        let  rect    = fullRect.insetBy(dx: kControlPointSize, dy: kControlPointSize)
        let shapeLayer = CAShapeLayer()
        let path     = CGPath(ellipseIn: rect , transform: nil)
        shapeLayer.path = path
        shapeLayer.fillColor = color.cgColor
        
        let view = UIView(frame: fullRect)
        view.layer.addSublayer(shapeLayer)
        
        let g = UIPanGestureRecognizer(target: self, action: #selector(CurvyTextView.pan(_:)))
        view.addGestureRecognizer(g)
        self.addSubview(view)
        view.center = point
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addControlPoint(CGPoint(x: 50, y: 500), color: UIColor.green)
        addControlPoint(CGPoint(x: 300, y: 300), color: UIColor.black)
        addControlPoint(CGPoint(x: 400, y: 700), color: UIColor.black)
        addControlPoint(CGPoint(x: 650, y: 500), color: UIColor.red)
        updateControlPoints()
        
        let textContainer = NSTextContainer()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pan(_ g:UIPanGestureRecognizer){
        g.view?.center = g.location(in: self)
        updateControlPoints()
    }
    
    var attributedString:NSAttributedString {
        get{
            return textStorage
        }
        set{
            textStorage.setAttributedString(newValue)
        }
    }
    
    func drawpath(){
        let path = UIBezierPath()
        path.move(to: P0)
        path.addCurve(to: P3, controlPoint1: P1, controlPoint2: P2)
        UIColor.blue.setStroke()
        path.stroke()
    }
    
    static func Bezier(_ t:CGFloat, P0:CGFloat,P1:CGFloat, P2:CGFloat,P3:CGFloat)->CGFloat{
        return
            (1-t)*(1-t)*(1-t)         * P0
                + 3 *       (1-t)*(1-t) *     t * P1
                + 3 *             (1-t) *   t*t * P2
                +                         t*t*t * P3
    }
    
    func pointForOffset(_ t:CGFloat)->CGPoint{
        let x =  CurvyTextView.Bezier(t, P0: P0.x, P1: P1.x, P2: P2.x, P3: P3.x)
        let y =  CurvyTextView.Bezier(t, P0: P0.y, P1: P1.y, P2: P2.y, P3: P3.y)
        return CGPoint(x: x, y: y)
    }
    
    static func BezierPrime(_ t:CGFloat, P0:CGFloat,P1:CGFloat, P2:CGFloat,P3:CGFloat)->CGFloat{
        return
               -3 * (1-t)*(1-t) * P0
                + (3 * (1-t)*(1-t) * P1) - (6 * t * (1-t) * P1)
                - (3 *         t*t * P2) + (6 * t * (1-t) * P2)
                +  3 * t*t * P3
    }
    
    func angleForOffset(_ t:CGFloat)->CGFloat{
        let x =  CurvyTextView.BezierPrime(t, P0: P0.x, P1: P1.x, P2: P2.x, P3: P3.x)
        let y =  CurvyTextView.BezierPrime(t, P0: P0.y, P1: P1.y, P2: P2.y, P3: P3.y)
        return atan2(y, x)
    }
    
    static func Distance(_ a:CGPoint,b:CGPoint)->CGFloat{
        let dx = a.x - b.x
        let dy = a.y - b.y
        return hypot(dx, dy)
    }
    
    func offsetAtDistance(_ aDistance:CGFloat,aPoint:CGPoint,anOffset:CGFloat)->CGFloat{
        var newDistance:CGFloat = 0
        var newOffset:CGFloat   = anOffset + kStep
        while newDistance <= aDistance && newOffset < 1.0{
            newOffset += kStep
            newDistance = CurvyTextView.Distance(aPoint, b: pointForOffset(newOffset))
        }
        return newOffset
    }
    
    func drawText(){
        if attributedString.length  == 0 {
            return
        }
        
        let context = UIGraphicsGetCurrentContext()
        var glyphRange:NSRange = NSRange()
        let lineRect = layoutManager.lineFragmentRect(forGlyphAt: 0, effectiveRange: &glyphRange)
        
        var offset:CGFloat   = 0
        var lastGlyphPoint:CGPoint = P0
        var lastX:CGFloat  = 0
        for glyphIndex in glyphRange.location..<NSMaxRange(glyphRange){
            context?.saveGState()
            
            let location = layoutManager.location(forGlyphAt: glyphIndex)
            let distance = location.x - lastX
            offset = offsetAtDistance(distance, aPoint: lastGlyphPoint, anOffset: offset)
            
            let glyphPoint:CGPoint = pointForOffset(offset)
            let angle      = angleForOffset(offset)
            print(glyphPoint)
            lastGlyphPoint = glyphPoint
            lastX          = location.x
            
            context?.translateBy(x: glyphPoint.x, y: glyphPoint.y)
            context?.rotate(by: angle )

            layoutManager.drawGlyphs(forGlyphRange: NSMakeRange(glyphIndex, 1),
                                                 at: CGPoint(x: -(lineRect.origin.x + location.x),
                                                                      y: -(lineRect.origin.y + location.y)))
            context?.restoreGState()
        }
    }
    
    override func draw(_ rect: CGRect) {
        drawpath()
        drawText()
    }
}
