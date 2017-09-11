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
        self.index += 1
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        for i in 0...self.index{
            if i < (text as NSString).length{
                let character = (text as NSString).substring(with: NSMakeRange(i , 1))
                let origin = originAtIndex(i, fontSize: kFontSize)
                (character as NSString).draw(at: origin, withAttributes: [NSFontAttributeName:UIFont.systemFont(ofSize: kFontSize)])
            }
        }
    }
}
