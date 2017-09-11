//
//  ZipTextView3.swift
//  ZipText
//
//  Created by WJ on 15/11/18.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ZipTextView3: ZipTextView2 {
    var locations = [CGPoint.zero]
    
    override    func originAtIndex(_ index:Int,fontSize:CGFloat)->CGPoint{
        if  locations.count > index{
            return locations[index]
        }
        var origin = self.originAtIndex(index-1, fontSize: fontSize )
        let prevCharacter = (text as NSString).substring(with: NSMakeRange(index-1, 1))
        let prevCharacterSize = (prevCharacter as NSString).size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: fontSize)])
        origin.x += prevCharacterSize.width
        if origin.x > self.bounds.width{
            origin.x = 0
            origin.y += prevCharacterSize.height
        }
        locations.append(origin)
        return origin
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
