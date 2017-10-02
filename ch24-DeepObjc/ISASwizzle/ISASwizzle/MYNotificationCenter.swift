//
//  MYNotificationCenter.swift
//  ISASwizzle
//
//  Created by WJ on 15/12/3.
//  Copyright © 2015年 wj. All rights reserved.
//

import Foundation

class MYNotificationCenter:NotificationCenter{
    override func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {
        print("Adding observer:\(observer)")
        super.addObserver(observer, selector: aSelector, name: aName, object: anObject)
    }
}
