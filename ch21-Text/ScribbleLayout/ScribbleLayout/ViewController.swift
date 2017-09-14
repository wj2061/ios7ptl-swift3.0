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
        
        let path = Bundle.main.path(forResource: "sample.txt", ofType: nil)
        guard let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8) else{  return }
        let attributedString = NSAttributedString(string: string)
        
        let style  = NSMutableParagraphStyle()
        style.alignment = .justified
        
        let text = PTLScribbleTextStorage()
        
        text.tokens = ["France" :[NSForegroundColorAttributeName:UIColor.blue],
            "England":[NSForegroundColorAttributeName:UIColor.red],
            "season" :[PTLDefault.RedactStyleAttributeName:true],
            "and"    :[PTLDefault.HighlightColorAttributeName:UIColor.yellow],
            PTLDefault.TokenName: [ NSParagraphStyleAttributeName: style,
                NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2)]
            ]
        
        text.setAttributedString(attributedString)
        
        let layoutManager = PTLScribbleLayoutManager()
        text.addLayoutManager(layoutManager)
        
        let textViewFrame = CGRect(x: 30, y: 40, width: 708, height: 400)
        let textContainer = NSTextContainer(size: textViewFrame.size)
        layoutManager.addTextContainer(textContainer)
        
        let textView = UITextView(frame: textViewFrame, textContainer: textContainer)
        
        self.view.addSubview(textView)
    }
}

