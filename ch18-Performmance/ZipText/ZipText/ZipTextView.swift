//
//  ZipTextView.swift
//  ZipText
//
//  Created by WJ on 15/11/18.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
let kFontSize:CGFloat = 16.0

class ZipTextView: UIView {
    var index = 0
    var text = ""
    var timer:NSTimer!
    
    init(frame:CGRect,text:String){
        super.init(frame: frame)
        self.backgroundColor = UIColor.redColor()
        self.text = text
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "appendNextCharacter", userInfo: nil, repeats: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func appendNextCharacter(){
        for i in 0...self.index{
            if i < (text as NSString).length{
            let label = UILabel()
            label.text = (text as NSString).substringWithRange(NSMakeRange(i , 1))
            label.sizeToFit()
            label.opaque = false
            var frame = label.frame
            frame.origin = originAtIndex(i, fontSize: label.font.pointSize)
            label.frame = frame
            self.addSubview(label)
            }
        }
        self.index++
    }
    
    func originAtIndex(index:Int,fontSize:CGFloat)->CGPoint{
        if index == 0{
            return CGPointZero
        }
        var origin = self.originAtIndex(index-1, fontSize: fontSize )
        let prevCharacter = (text as NSString).substringWithRange(NSMakeRange(index-1, 1))
        let prevCharacterSize = (prevCharacter as NSString).sizeWithAttributes([NSFontAttributeName:UIFont.systemFontOfSize(fontSize)])
        origin.x += prevCharacterSize.width
        if origin.x > CGRectGetWidth(self.bounds){
            origin.x = 0
            origin.y += prevCharacterSize.height
        }
        return origin
    }
}
