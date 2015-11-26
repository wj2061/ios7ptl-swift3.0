//
//  ViewController.swift
//  ScribbleLayout
//
//  Created by wj on 15/11/26.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("sample.txt", ofType: nil)
        guard let string = try? String(contentsOfFile: path!, encoding: NSUTF8StringEncoding) else{  return }
        let attributedString = NSAttributedString(string: string)
        
        let style  = NSMutableParagraphStyle()
        style.alignment = .Justified
        
        let text = PTLScribbleTextStorage()
        
        text.tokens = ["France" :[NSForegroundColorAttributeName:UIColor.blueColor()],
            "England":[NSForegroundColorAttributeName:UIColor.redColor()],
            "season" :[PTLDefault.RedactStyleAttributeName:true],
            "and"    :[PTLDefault.HighlightColorAttributeName:UIColor.yellowColor()],
            PTLDefault.TokenName: [ NSParagraphStyleAttributeName: style,
                NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)]
            ]
        
        text.setAttributedString(attributedString)
        
        let layoutManager = PTLScribbleLayoutManager()
        text.addLayoutManager(layoutManager)
        
        let textViewFrame = CGRectMake(30, 40, 708, 400)
        let textContainer = NSTextContainer(size: textViewFrame.size)
        layoutManager.addTextContainer(textContainer)
        
        let textView = UITextView(frame: textViewFrame, textContainer: textContainer)
        
        self.view.addSubview(textView)
    }
}

