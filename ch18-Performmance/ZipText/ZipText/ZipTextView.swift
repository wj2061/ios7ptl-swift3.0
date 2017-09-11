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
    var timer:Timer!
    
    init(frame:CGRect,text:String){
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        self.text = text
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ZipTextView.appendNextCharacter), userInfo: nil, repeats: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func appendNextCharacter(){
        for i in 0...self.index{
            if i < (text as NSString).length{
            let label = UILabel()
            label.text = (text as NSString).substring(with: NSMakeRange(i , 1))
            label.sizeToFit()
            label.isOpaque = false
            var frame = label.frame
            frame.origin = originAtIndex(i, fontSize: label.font.pointSize)
            label.frame = frame
            self.addSubview(label)
            }
        }
        self.index += 1
    }
    
    func originAtIndex(_ index:Int,fontSize:CGFloat)->CGPoint{
        if index == 0{
            return CGPoint.zero
        }
        var origin = self.originAtIndex(index-1, fontSize: fontSize )
        let prevCharacter = (text as NSString).substring(with: NSMakeRange(index-1, 1))
        let prevCharacterSize = (prevCharacter as NSString).size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: fontSize)])
        origin.x += prevCharacterSize.width
        if origin.x > self.bounds.width{
            origin.x = 0
            origin.y += prevCharacterSize.height
        }
        return origin
    }
}
