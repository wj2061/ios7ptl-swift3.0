//
//  ViewController.swift
//  MethodSwizzle
//
//  Created by WJ on 15/12/3.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class Observer:NSObject{
    func somthingHappened(_ note:Notification){
        print("Something happened")
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        MSNSNotificationCenter.swizzleAddObserver()

        let observar = Observer()
        MSNSNotificationCenter.default.addObserver(observar, selector: Selector(("somthingHappened")), name: NSNotification.Name(rawValue: "SomethingHappenedNotification"), object: nil)
    }
}

