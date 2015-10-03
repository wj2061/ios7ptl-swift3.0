//
//  MYView.swift
//  Drawing
//
//  Created by wj on 15/10/3.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class MYView: UIView {
    private struct kImageSize{
        static let width = 200
        static let height = 200
    }
    
    func reverseImageForText(text:String)->UIImage?{
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        let color = UIColor.redColor()
        
        UIGraphicsBeginImageContext(CGSize(width: kImageSize.width,height: kImageSize.height))
        
        NSString(string: text).drawInRect(CGRect(x: 0, y: 0, width: kImageSize.width, height: kImageSize.height), withAttributes: [NSFontAttributeName: font,NSForegroundColorAttributeName: color])
        let textImage = UIGraphicsGetImageFromCurrentImageContext().CGImage
        
        UIGraphicsEndImageContext()
        
        if (textImage != nil)  {
          let image = UIImage(CGImage: textImage!, scale: 1, orientation: UIImageOrientation.UpMirrored)
          return image
        }
        return nil
    }
   
    override func drawRect(rect: CGRect) {
       UIColor(red: 0, green: 0, blue: 1, alpha: 0.1).set()
        if  let image = reverseImageForText("Hello World"){
            image .drawAtPoint(CGPoint(x: 50, y: 150))
        }
        UIRectFillUsingBlendMode(CGRect(x: 100, y: 100, width: 100, height: 100), CGBlendMode.Normal)
    }
}
