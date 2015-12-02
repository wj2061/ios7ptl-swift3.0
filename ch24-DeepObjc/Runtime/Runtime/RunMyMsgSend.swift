//
//  RunMyMsgSend.swift
//  Runtime
//
//  Created by wj on 15/12/3.
//  Copyright © 2015年 wj. All rights reserved.
//

import Foundation

typealias MyvoidIMP = @convention(c)(NSObject,Selector)->()


func myMsgSend(receiver:NSObject,name:String){
    let selector = sel_registerName(name)
    let methodIMP = class_getMethodImplementation(receiver.classForCoder, selector)
    let callBack  =  unsafeBitCast(methodIMP, MyvoidIMP.self)
    return callBack(receiver,Selector( name))
}

func RunMyMsgSend(){
//    let cla = objc_getClass("NSObject") as! AnyClass
    let object = NSObject()
    myMsgSend(object, name: "init")
    
    let description = object.description
    
    let cstr = description.utf8
    
    print(cstr)   
}