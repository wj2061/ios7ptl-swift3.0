//
//  LayerViewController.swift
//  Layers
//
//  Created by wj on 15/10/7.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class LayerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named:"pushing")
        view.layer.contentsScale=UIScreen.mainScreen().scale
        view.layer.contentsGravity = kCAGravityCenter
        view.layer.contents = image?.CGImage
        
        let g = UITapGestureRecognizer(target: self, action: Selector("performFlip:"))
        view.addGestureRecognizer(g)
    }
    
    func performFlip(gesture:UIGestureRecognizer){
        let delegateView = DelegateView(frame: view.frame)
        UIView.transitionFromView(view, toView: delegateView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight){ (_) -> Void in
        }
    }
}
