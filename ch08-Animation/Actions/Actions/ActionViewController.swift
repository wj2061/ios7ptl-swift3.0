//
//  ActionViewController.swift
//  Actions
//
//  Created by wj on 15/10/10.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController {
    
    let circleLayer = CircleLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        circleLayer.radius = 20
        circleLayer.frame = view.bounds
        view.layer.addSublayer(circleLayer)
        
        let anim = CABasicAnimation(keyPath: "position")
        anim.duration = 2.0
        var actions = circleLayer.actions ?? [:]
                
        actions["position"] = anim
        
        let fadeanim = CABasicAnimation(keyPath: "opacity")
        fadeanim.fromValue = NSNumber(float: 0.4)
        fadeanim.toValue = NSNumber(float: 1)
        
        let growAnim = CABasicAnimation(keyPath: "transform.scale")
        growAnim.fromValue = NSNumber(float: 0.8)
        growAnim.toValue = NSNumber(float: 1)
        
        let group = CAAnimationGroup()
        group.animations = [fadeanim,growAnim]
        
        actions[kCAOnOrderIn] = group
        circleLayer.actions=actions
        
        let g = UITapGestureRecognizer(target: self, action: Selector("tap:"))
        view.addGestureRecognizer(g)
        
    }
    
    func tap(gesture:UITapGestureRecognizer){
     circleLayer.position = CGPoint(x: 100, y: 100)
     circleLayer.radius = 100

     CATransaction.setAnimationDuration(2)
    }

}
