//
//  ViewController.swift
//  AssocRef
//
//  Created by wj on 15/9/30.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
import ObjectiveC

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonLabel: UILabel!
    

    @IBAction func doSomething(_ sender: UIButton) {
        var  kRepresentedObject = Selector(("doSomething"))
        
        let alertView = UIAlertController(title: "Alert",
                                          message: nil,
                                          preferredStyle: UIAlertControllerStyle.alert)
        
        let okAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction ) -> Void in
            let button = objc_getAssociatedObject(alertAction, &kRepresentedObject) as! UIButton
            self.buttonLabel.text = button.title(for:.normal)
        });
        
        objc_setAssociatedObject(okAlertAction, &kRepresentedObject, sender, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        alertView.addAction(okAlertAction)

        
        present(alertView, animated: true, completion: nil)
    }
}

