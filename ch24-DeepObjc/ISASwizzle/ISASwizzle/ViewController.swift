//
//  ViewController.swift
//  ISASwizzle
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
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.setClass(MYNotificationCenter)
        
        let observer = Observer()
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: "somthingHappened:", name: "SomethingHappenedNotification", object: nil)
    }

}

