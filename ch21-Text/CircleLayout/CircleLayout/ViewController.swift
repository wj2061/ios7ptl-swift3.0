//
//  ViewController.swift
//  CircleLayout
//
//  Created by WJ on 15/11/26.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSBundle.mainBundle().pathForResource("sample.txt", ofType: nil)
        guard  let st   =  try? String(contentsOfFile: path!, encoding: NSUTF8StringEncoding) else {return}
        let style = NSMutableParagraphStyle()
        
        let text = NSTextStorage(string: st, attributes: [NSParagraphStyleAttributeName:style,NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)])
        let manager = NSLayoutManager()
        text.addLayoutManager(manager)
        
        let textViewFrame = CGRectInset(view.bounds, 15, 15)
        let textContainer = CircleTextContainer()
        textContainer.size = textViewFrame.size
        
        textContainer.exclusionPaths = [UIBezierPath(ovalInRect: CGRect(x: 100, y:100, width: 80, height: 80))]
        manager.addTextContainer(textContainer)
        
        let textView = UITextView(frame: textViewFrame, textContainer: textContainer)
        textView.allowsEditingTextAttributes = true
        
        view.addSubview(textView)
        
        
        
        
        
        
        
    }



}

