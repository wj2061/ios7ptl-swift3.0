//
//  PrintObjectMethods.swift
//  Runtime
//
//  Created by wj on 15/12/2.
//  Copyright © 2015年 wj. All rights reserved.
//

import Foundation

func PrintObjectMethods(){
    var count:UInt32 = 0
    let methods = class_copyMethodList(NSObject.self , &count)
    for i in 0..<Int( count ){
        let sel = method_getName(methods[i])
        let name = String.fromCString(sel_getName(sel) )!
        print(name)
    }
}