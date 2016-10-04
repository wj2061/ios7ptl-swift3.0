//
//  MYView.swift
//  Drawing
//
//  Created by wj on 15/10/3.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class MYView: UIView {
    fileprivate struct kImageSize{
        static let width = 200
        static let height = 200
    }
    
    func reverseImageForText(_ text:String)->UIImage?{
        let font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        let color = UIColor.red
        
        UIGraphicsBeginImageContext(CGSize(width: kImageSize.width,height: kImageSize.height))
        
        NSString(string: text).draw(in: CGRect(x: 0,
                                               y: 0,
                                               width: kImageSize.width,
                                               height: kImageSize.height),
                                    withAttributes: [NSFontAttributeName: font,
                                                     NSForegroundColorAttributeName: color])
        let textImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        
        UIGraphicsEndImageContext()
        
        if (textImage != nil)  {
          let image = UIImage(cgImage: textImage!, scale: 1, orientation: .upMirrored)
          return image
        }
        return nil
    }
   
    override func draw(_ rect: CGRect) {
        if  let image = reverseImageForText("Hello World"){
            image .draw(at: CGPoint(x: 50, y: 150))
        }
        
        UIColor(red: 0, green: 0, blue: 1, alpha: 0.1).setFill()
        UIRectFillUsingBlendMode(CGRect(x: 100, y: 100, width: 100, height: 100), CGBlendMode.normal)
    }
}
