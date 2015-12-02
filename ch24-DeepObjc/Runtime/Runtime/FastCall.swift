//
//  FastCall.swift
//  Runtime
//
//  Created by wj on 15/12/2.
//  Copyright © 2015年 wj. All rights reserved.
//

import Foundation

typealias voidIMP = @convention(c)(NSObject,Selector,String)->()

let kTotalCount = 100000000

func FastCall(){
    let string = NSMutableString()
    var totalTime:NSTimeInterval = 0
    
    // With objc_msgSend
    var start = NSDate()
    for _ in 0..<kTotalCount{
        string.setString("stuff")
    }
    
    totalTime = -start.timeIntervalSinceNow
    print("w/ objc_msgSend = \(totalTime)")
    
    // Skip objc_msgSend.
    start = NSDate()
    let selector = Selector("setString:")
    let setStringMethod:IMP =  string.methodForSelector("setString:")
    let callBack  =  unsafeBitCast(setStringMethod, voidIMP.self)
    for _ in 0..<kTotalCount{
       callBack(string,selector,"stuff")
    }
    totalTime = -start.timeIntervalSinceNow
    print("w/ objc_msgSend = \(totalTime)")
    
    
}