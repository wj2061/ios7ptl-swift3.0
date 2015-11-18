//
//  ZipTextView1.swift
//  ZipText
//
//  Created by WJ on 15/11/18.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ZipTextView1: ZipTextView {
    override  func appendNextCharacter(){
       let  i = self.index
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
        self.index++
        
        
    }



}
