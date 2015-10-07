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
    
    private func layer(color:UIColor,transform:CATransform3D)->CALayer{
        let  layer = CALayer()
        layer.backgroundColor = color.CGColor
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
        layer(UIColor.redColor(), transform: transform)
        
        transform = CATransform3DMakeTranslation(0, kSize/2, 0)
        transform = CATransform3DRotate(transform,CGFloat( M_PI_2 ), 1, 0, 0)
        layer(UIColor.greenColor(), transform: transform)
        
        transform = CATransform3DMakeTranslation(kSize/2, 0 , 0)
        transform = CATransform3DRotate(transform,CGFloat( M_PI_2 ), 0, 1, 0)
        layer(UIColor.blueColor(), transform: transform)
        
        transform = CATransform3DMakeTranslation(-kSize/2, 0 , 0)
        transform = CATransform3DRotate(transform,CGFloat( M_PI_2 ), 0, 1, 0)
        layer(UIColor.cyanColor(), transform: transform)
        
        transform = CATransform3DMakeTranslation(0 , 0, -kSize/2)
        transform = CATransform3DRotate(transform,CGFloat( M_PI_2 ), 0, 0, 0)
        layer(UIColor.yellowColor(), transform: transform)
        
        transform = CATransform3DMakeTranslation(0, 0, kSize/2)
        transform = CATransform3DRotate(transform,CGFloat( M_PI_2 ), 0, 0, 0)
        layer(UIColor.magentaColor(), transform: transform)
        
        view.layer.sublayerTransform = MakePerspetiveTransform
        
        let g  = UIPanGestureRecognizer(target: self, action: Selector("pan:"))
        view.addGestureRecognizer(g)
    }

    func pan(gesture:UIPanGestureRecognizer){
        switch gesture.state {
        case .Changed :
            let  translation = gesture.translationInView(view)
            var transform = view.layer.sublayerTransform
            transform = CATransform3DRotate(transform, kPanScale*translation.x, 0, 1, 0)
            transform = CATransform3DRotate(transform, -kPanScale*translation.y, 1, 0, 0)
            view.layer.sublayerTransform = transform
            gesture.setTranslation(CGPointZero, inView: view)
            
        default :
            break
        }
    }

}

