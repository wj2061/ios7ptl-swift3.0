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
        view.layer.contentsScale=UIScreen.main.scale
        view.layer.contentsGravity = kCAGravityCenter
        view.layer.contents = image?.cgImage
        
        let g = UITapGestureRecognizer(target: self, action: #selector(LayerViewController.performFlip(_:)))
        view.addGestureRecognizer(g)
    }
    
    func performFlip(_ gesture:UIGestureRecognizer){
        let delegateView = DelegateView(frame: view.frame)
        UIView.transition(from: view, to: delegateView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight){ (_) -> Void in
        }
    }
}
