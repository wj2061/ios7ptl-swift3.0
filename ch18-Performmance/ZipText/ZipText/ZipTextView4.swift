//
//  ZipTextView4.swift
//  ZipText
//
//  Created by WJ on 15/11/18.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ZipTextView4: ZipTextView3{
    override  func appendNextCharacter(){
        self.index += 1
        if self.index < ( text as NSString).length{
            var dirtyRect = CGRect()
            dirtyRect.origin = originAtIndex(index, fontSize: kFontSize)
            dirtyRect.size = CGSize(width: kFontSize, height: kFontSize)
            setNeedsDisplay(dirtyRect)
        }
        self.setNeedsDisplay()
    }


}
