//
//  ViewController.swift
//  MethodSwizzle
//
//  Created by WJ on 15/12/3.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class Observer:NSObject{
    func somthingHappened(note:NSNotification){
        print("Something happened")
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        MSNSNotificationCenter.swizzleAddObserver()

        let observar = Observer()
        MSNSNotificationCenter.defaultCenter().addObserver(observar, selector: "somthingHappened", name: "SomethingHappenedNotification", object: nil)
    }
}

