//
//  ViewAnimationViewController.swift
//  ViewAnimation
//
//  Created by wj on 15/10/6.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ViewAnimationViewController: UIViewController {
    var circleView  = CircleView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        circleView.center=CGPoint(x: 100, y: 40)
        view.addSubview(circleView)
        
        let g = UITapGestureRecognizer(target: self, action:Selector("dropAnimate:"))
        view.addGestureRecognizer(g)
    }

    func dropAnimate(recognizer:UIGestureRecognizer){
        UIView.animateWithDuration(3, animations: { () -> Void in
            recognizer.enabled=false
            self.circleView.center=CGPoint(x: 100, y: 300)
            }) { (_) -> Void in
                UIView.animateWithDuration(1, animations: { () -> Void in
                    self.circleView.center=CGPoint(x: 250, y: 300)
                    }, completion: { (_) -> Void in
                        recognizer.enabled=true
                })
        }
    }
}
