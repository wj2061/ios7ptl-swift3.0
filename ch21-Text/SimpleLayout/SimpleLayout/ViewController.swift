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
        CFAttributedStringReplaceString(attrString, CFRangeMake(0, 0), string)
        
        let baseFont = CTFontCreateUIFontForLanguage(.System, 16, nil)
        let length   = CFStringGetLength(string)
        CFAttributedStringSetAttribute(attrString, CFRangeMake(0, length), kCTFontAttributeName, baseFont)
        
        let boldFont = CTFontCreateCopyWithSymbolicTraits(baseFont!, 0, nil, .BoldTrait, .BoldTrait)
        CFAttributedStringSetAttribute(attrString, CFStringFind(string, "bold", []), kCTFontAttributeName, boldFont)
        
        let italicFont = CTFontCreateCopyWithSymbolicTraits(baseFont!, 0, nil, .ItalicTrait, .ItalicTrait)
        CFAttributedStringSetAttribute(attrString, CFStringFind(string, "italics", []), kCTFontAttributeName, italicFont)
        
        let color = UIColor.redColor().CGColor
        CFAttributedStringSetAttribute(attrString, CFStringFind(string, "color", []), kCTForegroundColorAttributeName, color)
        
        var alignment = CTTextAlignment.Justified
        var  setting   = CTParagraphStyleSetting(spec: .Alignment, valueSize: sizeof(CTTextAlignment), value: &alignment)
        
        let style = CTParagraphStyleCreate(&setting, 1)
        var lastLineRange = CFStringFind(string, "\n", .CompareBackwards)
        ++lastLineRange.location
        
        lastLineRange.length = CFStringGetLength(string) - lastLineRange.location
        CFAttributedStringSetAttribute(attrString, lastLineRange, kCTParagraphStyleAttributeName, style)
        
        let label = CoreTextLabel(frame: CGRectInset(self.view.bounds,10, 10))
        label.attributedString = attrString
        
        view.addSubview(label)
    }
}

