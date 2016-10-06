//
//  LayerViewController.swift
//  Layers
//
//  Created by wj on 15/10/7.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class LayerViewController: UIViewController {
    
    var delegateView = DelegateView()

    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named:"pushing")
        view.layer.contentsScale=UIScreen.main.scale
        view.layer.contentsGravity = kCAGravityCenter
        view.layer.contents = image?.cgImage
        
        let flipGesture = UITapGestureRecognizer(target: self, action: #selector(LayerViewController.performFlip(_:)))
        view.addGestureRecognizer(flipGesture)
        
        delegateView.frame = view.frame
        let flipBackGesture =  UITapGestureRecognizer(target: self, action: #selector(LayerViewController.performFlipback(_:)))
        
        delegateView.addGestureRecognizer(flipBackGesture)    
    }
    
    func performFlip(_ gesture:UIGestureRecognizer){
        UIView.transition(from: view, to: delegateView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight){ (_) -> Void in
        }
    }
    
    
    func performFlipback(_ gesture:UIGestureRecognizer){
        UIView.transition(from: delegateView, to: view, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight){ (_) -> Void in
        }

        
    }
}
