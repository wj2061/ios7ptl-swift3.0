//
//  ViewController.swift
//  SimpleLayout
//
//  Created by wj on 15/11/28.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let string = "Here is some simple text that includes bold and italics.\n \n We can even include some color."
        
        let attrString = CFAttributedStringCreateMutable(nil, 0)
        CFAttributedStringReplaceString(attrString, CFRangeMake(0, 0), string as CFString)
        
        let baseFont = CTFontCreateUIFontForLanguage(.system, 16, nil)
        let length   = CFStringGetLength(string as CFString)
        CFAttributedStringSetAttribute(attrString, CFRangeMake(0, length), kCTFontAttributeName, baseFont)
        
        let boldFont = CTFontCreateCopyWithSymbolicTraits(baseFont!, 0, nil, .boldTrait, .boldTrait)
        CFAttributedStringSetAttribute(attrString, CFStringFind(string as CFString, "bold" as CFString, []), kCTFontAttributeName, boldFont)
        
        let italicFont = CTFontCreateCopyWithSymbolicTraits(baseFont!, 0, nil, .italicTrait, .italicTrait)
        CFAttributedStringSetAttribute(attrString, CFStringFind(string as CFString, "italics" as CFString, []), kCTFontAttributeName, italicFont)
        
        let color = UIColor.red.cgColor
        CFAttributedStringSetAttribute(attrString, CFStringFind(string as CFString, "color" as CFString, []), kCTForegroundColorAttributeName, color)
        
        var alignment = CTTextAlignment.justified
        var  setting   = CTParagraphStyleSetting(spec: .alignment, valueSize: MemoryLayout<CTTextAlignment>.size, value: &alignment)
        
        let style = CTParagraphStyleCreate(&setting, 1)
        var lastLineRange = CFStringFind(string as CFString, "\n" as CFString, .compareBackwards)
        lastLineRange.location += 1
        
        lastLineRange.length = CFStringGetLength(string as CFString) - lastLineRange.location
        CFAttributedStringSetAttribute(attrString, lastLineRange, kCTParagraphStyleAttributeName, style)
        
        let label = CoreTextLabel(frame: self.view.bounds.insetBy(dx: 10, dy: 10))
        label.attributedString = attrString!
        
        view.addSubview(label)
    }
}

