//
//  SetClass.swift
//  ISASwizzle
//
//  Created by WJ on 15/12/3.
//  Copyright © 2015年 wj. All rights reserved.
//

import Foundation
extension NSObject{
    func setClass(aClass:AnyClass){
        assert(class_getInstanceSize(aClass) == class_getInstanceSize(object_getClass(self)),"Classes must be the same size to swizzle.")
        object_setClass(self, aClass)
    }
}