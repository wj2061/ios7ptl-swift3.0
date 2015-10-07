//
//  LayerAnimationViewController.swift
//  LayerAnimation
//
//  Created by wj on 15/10/7.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class LayerAnimationViewController: UIViewController {
    private let squareLayer = CALayer()
    private let squareView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        squareLayer.backgroundColor = UIColor.redColor().CGColor
        squareLayer.frame = CGRect(x: 100, y: 100, width: 20, height: 20)
        view.layer.addSublayer(squareLayer)
        
        squareView.backgroundColor = UIColor.blueColor()
        squareView.frame = CGRect(x: 200, y: 100, width: 20, height: 20)
        view.addSubview(squareView)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("drop:")))
    }

     func drop(gesture:UIGestureRecognizer){
        CATransaction.setAnimationDuration(2.0)
        squareLayer.position = CGPoint(x: 200, y: 250)
        
        squareLayer.addAnim(NSNumber(double: 0), keypath: "opacity", duration: 2.0, delay: 0)
        
        squareView.center = CGPoint(x: 100, y: 250)
    }
}

  private extension CALayer{
     func addAnim(value:NSObject?,keypath:String,duration:CFTimeInterval,delay:CFTimeInterval){
         CATransaction.begin()
         CATransaction.setDisableActions(true)
         setValue(value, forKeyPath: keypath)
         let anim = CABasicAnimation(keyPath: keypath)
         anim.duration = duration
         anim.beginTime = CACurrentMediaTime()+delay
         anim.fillMode = kCAFillModeBoth
         anim.fromValue = presentationLayer()?.valueForKey(keypath)
         anim.toValue = value
         anim.autoreverses = true
         anim.repeatCount = Float.infinity
         addAnimation(anim, forKey: keypath)
         CATransaction.commit()
    }
}