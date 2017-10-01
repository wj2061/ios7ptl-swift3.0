//
//  ViewController.swift
//  Box
//
//  Created by wj on 15/10/8.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let kSize:CGFloat = 100
    let kPanScale:CGFloat = 1.0/100.0
    
    var topLayer:CALayer?
    var bottomLayer:CALayer?
    var leftLayer:CALayer?
    var rightLayer:CALayer?
    var frontLayer:CALayer?
    var backLayer:CALayer?

    
    
    fileprivate func layer(_ color:UIColor,transform:CATransform3D)->CALayer{
        let  layer = CALayer()
        layer.backgroundColor = color.cgColor
        layer.bounds = CGRect(x: 0, y: 0, width: kSize, height: kSize)
        layer.position = view.center
        layer.transform = transform
        view.layer.addSublayer(layer)
        return layer
    }
    
    var MakePerspetiveTransform:CATransform3D {
        get{ var perspective = CATransform3DIdentity
            perspective.m34 = -1.0/2000.0
            return perspective
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        var transform = CATransform3DMakeTranslation(0, -kSize/2, 0)
        transform = CATransform3DRotate(transform,CGFloat( M_PI_2 ), 1, 0, 0)
        topLayer = layer(UIColor.red, transform: transform)
        
        transform = CATransform3DMakeTranslation(0, kSize/2, 0)
        transform = CATransform3DRotate(transform,CGFloat( M_PI_2 ), 1, 0, 0)
        bottomLayer = layer(UIColor.green, transform: transform)
        
        transform = CATransform3DMakeTranslation(kSize/2, 0 , 0)
        transform = CATransform3DRotate(transform,CGFloat( M_PI_2 ), 0, 1, 0)
        rightLayer = layer(UIColor.blue, transform: transform)
        
        transform = CATransform3DMakeTranslation(-kSize/2, 0 , 0)
        transform = CATransform3DRotate(transform,CGFloat( M_PI_2 ), 0, 1, 0)
        leftLayer = layer(UIColor.cyan, transform: transform)
        
        transform = CATransform3DMakeTranslation(0 , 0, -kSize/2)
        transform = CATransform3DRotate(transform,CGFloat( M_PI_2 ), 0, 0, 0)
        backLayer = layer(UIColor.yellow, transform: transform)
        
        transform = CATransform3DMakeTranslation(0, 0, kSize/2)
        transform = CATransform3DRotate(transform,CGFloat( M_PI_2 ), 0, 0, 0)
        frontLayer = layer(UIColor.magenta, transform: transform)
        
        view.layer.sublayerTransform = MakePerspetiveTransform
        
        let g  = UIPanGestureRecognizer(target: self, action: #selector(ViewController.pan(_:)))
        view.addGestureRecognizer(g)
    }

    @objc func pan(_ gesture:UIPanGestureRecognizer){
        switch gesture.state {
        case .changed :
            let  translation = gesture.translation(in: view)
            var transform = view.layer.sublayerTransform
            transform = CATransform3DRotate(transform, kPanScale*translation.x, 0, 1, 0)
            transform = CATransform3DRotate(transform, -kPanScale*translation.y, 1, 0, 0)
            view.layer.sublayerTransform = transform
            gesture.setTranslation(CGPoint.zero, in: view)
            
        default :
            break
        }
    }

}

