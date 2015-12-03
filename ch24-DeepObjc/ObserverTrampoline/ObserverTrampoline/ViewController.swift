//
//  ViewController.swift
//  ObserverTrampoline
//
//  Created by WJ on 15/12/3.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

@objc protocol MyProtocol{
    func doSomething()
}

class MyClass:NSObject, MyProtocol{
    func doSomething(){
        print("doSomething :\(self)")
    }
}


class ViewController: UIViewController {
    var observerManager: NSObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        let observers: Set<MyClass> = [MyClass(),MyClass()]
        
        observerManager = RNObserverManager(pt: MyProtocol.self, observers: observers)
        
        observerManager?.performSelector("doSomething")
        
        

        
   }



}

