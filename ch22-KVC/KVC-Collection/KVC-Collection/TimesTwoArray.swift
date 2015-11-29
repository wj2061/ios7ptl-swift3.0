//
//  TimesTwoArray.swift
//  KVC-Collection
//
//  Created by wj on 15/11/29.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class TimesTwoArray: NSObject {
    private var count = 0
    
    func countOfNumbers()->Int{
        return count
    }
    
    func objectInNumbersAtIndex(index:Int)->AnyObject{
        return index*2
    }
    
    func incrementCount(){
        count++
    }

}
