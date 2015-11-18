//
//  ZipTextView2.swift
//  ZipText
//
//  Created by WJ on 15/11/18.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ZipTextView2: ZipTextView {
    override  func appendNextCharacter(){
        self.index++
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        for i in 0...self.index{
            if i < (text as NSString).length{
                let character = (text as NSString).substringWithRange(NSMakeRange(i , 1))
                let origin = originAtIndex(i, fontSize: kFontSize)
                (character as NSString).drawAtPoint(origin, withAttributes: [NSFontAttributeName:UIFont.systemFontOfSize(kFontSize)])
            }
        }
    }
}
