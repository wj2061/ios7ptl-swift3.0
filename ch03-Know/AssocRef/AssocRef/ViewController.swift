//
//  ViewController.swift
//  AssocRef
//
//  Created by wj on 15/9/30.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
import ObjectiveC

var kRepresentedObject:UInt8 = 0

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    @IBOutlet weak var button1: UIButton!{
        didSet{ objc_setAssociatedObject(button1, &kRepresentedObject, "button1",  objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet weak var button2: UIButton!{
        didSet{objc_setAssociatedObject(button2, &kRepresentedObject, "button2", objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet weak var buttonLabel: UILabel!
    
    
    @IBAction func doSomething(sender: UIButton) {
        let alertView = UIAlertController(title: "Alert",
                                        message: nil,
                                 preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (_ ) -> Void in
            let name = objc_getAssociatedObject(sender, &kRepresentedObject) as? String ?? ""
            self.buttonLabel.text=name
        }))
        
      presentViewController(alertView, animated: true, completion: nil)
        
        
    }
    
}

