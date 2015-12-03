//
//  File.swift
//  MethodSwizzle
//
//  Created by WJ on 15/12/3.
//  Copyright © 2015年 wj. All rights reserved.
//

import Foundation

class MSNSNotificationCenter:NSNotificationCenter{
   var sOrigAddObserver:IMP?
    
    func MYAddObserver(){
        print("MYAddObserver")
    }
    
    class func swizzleAddObserver(){
        NSNotificationCenter.swizzleSelector("kk",newIMP:COpaquePointer())
//        let origmet = class_getInstanceMethod(self, "MYAddObserver")
        let origIMP = class_getMethodImplementation(self,  "MYAddObserver")
        MSNSNotificationCenter.swizzleSelector("addObserver:selector:name:object:", newIMP: origIMP)
    }

}

