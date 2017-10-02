//
//  File.swift
//  MethodSwizzle
//
//  Created by WJ on 15/12/3.
//  Copyright © 2015年 wj. All rights reserved.
//

import Foundation

class MSNSNotificationCenter:NotificationCenter{
   var sOrigAddObserver:IMP?
    
    func MYAddObserver(){
        print("MYAddObserver")
    }
    
    class func swizzleAddObserver(){
        let origIMP = class_getMethodImplementation(self,  #selector(MSNSNotificationCenter.MYAddObserver))
        _ = MSNSNotificationCenter.swizzleSelector(#selector(NotificationCenter.addObserver(_:selector:name:object:)), newIMP: origIMP!)
    }

}

