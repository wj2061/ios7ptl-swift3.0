//
//  CircleTextContainer.swift
//  CircleLayout
//
//  Created by WJ on 15/11/26.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class CircleTextContainer: NSTextContainer {
    
    override func lineFragmentRect(forProposedRect proposedRect: CGRect, at characterIndex: Int, writingDirection baseWritingDirection: NSWritingDirection, remaining remainingRect: UnsafeMutablePointer<CGRect>?) -> CGRect{
    
        let rect = super.lineFragmentRect(forProposedRect: proposedRect, at: characterIndex, writingDirection: baseWritingDirection, remaining: remainingRect)
        
        let radius = fmin(size.width, size.height)/2
        let ypos   = fabs((proposedRect.origin.y+proposedRect.size.height / 2.0)-radius)
        let width  = (ypos < radius) ? 2.0 * sqrt(radius * radius - ypos * ypos) : 0.0
        let circleRect = CGRect(x: radius - width / 2.0,y: proposedRect.origin.y,width: width, height: proposedRect.size.height)
        
        return rect.intersection(circleRect)

    }

}
