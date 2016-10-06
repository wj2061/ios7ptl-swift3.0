//
//  LayerAnimationViewController.swift
//  LayerAnimation
//
//  Created by wj on 15/10/7.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class LayerAnimationViewController: UIViewController {
    fileprivate let squareLayer = CALayer()
    fileprivate let squareView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        squareLayer.backgroundColor = UIColor.red.cgColor
        squareLayer.frame = CGRect(x: 100, y: 100, width: 20, height: 20)
        view.layer.addSublayer(squareLayer)
        
        squareView.backgroundColor = UIColor.blue
        squareView.frame = CGRect(x: 200, y: 100, width: 20, height: 20)
        view.addSubview(squareView)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LayerAnimationViewController.drop(_:))))
    }

     func drop(_ gesture:UIGestureRecognizer){
        CATransaction.setAnimationDuration(2.0)
        squareLayer.position = CGPoint(x: 200, y: 250)
        
        squareLayer.addAnim(NSNumber(value: 0 as Double), keypath: "opacity", duration: 2.0, delay: 0)
        
        squareView.center = CGPoint(x: 100, y: 250)
    }
}

  private extension CALayer{
     func addAnim(_ value:NSObject?,keypath:String,duration:CFTimeInterval,delay:CFTimeInterval){
         CATransaction.begin()
         CATransaction.setDisableActions(true)
         setValue(value, forKeyPath: keypath)
         let anim = CABasicAnimation(keyPath: keypath)
         anim.duration = duration
         anim.beginTime = CACurrentMediaTime()+delay
         anim.fillMode = kCAFillModeBoth
         anim.fromValue = presentation()?.value(forKey: keypath)
         anim.toValue = value
         anim.autoreverses = true
         anim.repeatCount = Float.infinity
         add(anim, forKey: keypath)
         CATransaction.commit()
    }
}
