//
//  CircleTextContainer.swift
//  CircleLayout
//
//  Created by WJ on 15/11/26.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class CircleTextContainer: NSTextContainer {
    override func lineFragmentRectForProposedRect(proposedRect: CGRect, atIndex characterIndex: Int, writingDirection baseWritingDirection: NSWritingDirection, remainingRect: UnsafeMutablePointer<CGRect>) -> CGRect {
        let rect = super.lineFragmentRectForProposedRect(proposedRect, atIndex: characterIndex, writingDirection: baseWritingDirection, remainingRect: remainingRect)
        let radius = fmin(size.width, size.height)/2
        let ypos   = fabs((proposedRect.origin.y+proposedRect.size.height / 2.0)-radius)
        let width  = (ypos < radius) ? 2.0 * sqrt(radius * radius - ypos * ypos) : 0.0
        let circleRect = CGRectMake(radius - width / 2.0,proposedRect.origin.y,width, proposedRect.size.height)
        
        return CGRectIntersection(rect, circleRect)  
    }

}
