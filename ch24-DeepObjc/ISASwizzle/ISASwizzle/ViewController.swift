//
//  ViewController.swift
//  ISASwizzle
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
        
        let nc = NotificationCenter.default
        nc.setClass(MYNotificationCenter.self)
        
        let observer = Observer()
        NotificationCenter.default.addObserver(observer, selector: #selector(Observer.somthingHappened(_:)), name: NSNotification.Name(rawValue: "SomethingHappenedNotification"), object: nil)
    }

}

