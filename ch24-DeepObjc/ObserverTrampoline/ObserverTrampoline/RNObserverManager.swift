//
//  RNObserverManager.swift
//  ObserverTrampoline
//
//  Created by WJ on 15/12/3.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class RNObserverManager: NSObject {
    var observers:Set<NSObject> = []
    var pt :Protocol!
    
    init(pt:Protocol,observers:Set<NSObject>){
        super.init()
        self.pt = pt
        self.observers = observers
    }
    
    func addObserver(observer:NSObject){
        assert(observer.conformsToProtocol(pt), "Observer must conform to protocol.")
        observers.insert(observer)
    }
    
    func removeObserver(observer:NSObject){
        observers.remove(observer)
    }
    
    override func doesNotRecognizeSelector(aSelector: Selector){
        var isRecognized = false
        for observer in observers{
            if observer.respondsToSelector(aSelector){
                observer.performSelector(aSelector)
                isRecognized = true
            }
        }
        if  !isRecognized{
            super.doesNotRecognizeSelector(aSelector)
        }
    }
}
