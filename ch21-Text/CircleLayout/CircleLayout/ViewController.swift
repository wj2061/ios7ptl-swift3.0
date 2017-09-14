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
        let path = Bundle.main.path(forResource: "sample.txt", ofType: nil)
        guard  let st   =  try? String(contentsOfFile: path!, encoding: String.Encoding.utf8) else {return}
        let style = NSMutableParagraphStyle()
        
        let text = NSTextStorage(string: st, attributes: [NSParagraphStyleAttributeName:style,NSFontAttributeName:UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2)])
        let manager = NSLayoutManager()
        text.addLayoutManager(manager)
        
        let textViewFrame = view.bounds.insetBy(dx: 15, dy: 15)
        let textContainer = CircleTextContainer()
        textContainer.size = textViewFrame.size
        
        textContainer.exclusionPaths = [UIBezierPath(ovalIn: CGRect(x: 100, y:100, width: 80, height: 80))]
        manager.addTextContainer(textContainer)
        
        let textView = UITextView(frame: textViewFrame, textContainer: textContainer)
        textView.allowsEditingTextAttributes = true
        
        view.addSubview(textView)
        
        
        
        
        
        
        
    }



}

