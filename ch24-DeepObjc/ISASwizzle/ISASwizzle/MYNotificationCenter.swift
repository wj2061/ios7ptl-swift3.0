//
//  MYNotificationCenter.swift
//  ISASwizzle
//
//  Created by WJ on 15/12/3.
//  Copyright © 2015年 wj. All rights reserved.
//

import Foundation

class MYNotificationCenter:NSNotificationCenter{
    override func addObserver(observer: AnyObject, selector aSelector: Selector, name aName: String?, object anObject: AnyObject?) {
        print("Adding observer:\(observer)")
        super.addObserver(observer, selector: aSelector, name: aName, object: anObject)
    }
}