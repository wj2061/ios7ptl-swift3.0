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
    
    func addObserver(_ observer:NSObject){
        assert(observer.conforms(to: pt), "Observer must conform to protocol.")
        observers.insert(observer)
    }
    
    func removeObserver(_ observer:NSObject){
        observers.remove(observer)
    }
    
    override func doesNotRecognizeSelector(_ aSelector: Selector){
        var isRecognized = false
        for observer in observers{
            if observer.responds(to: aSelector){
                observer.perform(aSelector)
                isRecognized = true
            }
        }
        if  !isRecognized{
            super.doesNotRecognizeSelector(aSelector)
        }
    }
}
