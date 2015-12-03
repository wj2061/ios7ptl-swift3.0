//
//  RNSwizzle.swift
//  MethodSwizzle
//
//  Created by WJ on 15/12/3.
//  Copyright © 2015年 wj. All rights reserved.
//

import Foundation
extension NSObject{
    class func swizzleSelector(origSelector:Selector,newIMP:IMP)->IMP{
        let origMethod = class_getInstanceMethod(self, origSelector)
        let origIMP    = method_getImplementation(origMethod)
        if !class_addMethod(self, origSelector, newIMP, method_getTypeEncoding(origMethod)){
            method_setImplementation(origMethod, newIMP)
        }
        return origIMP
    }
}