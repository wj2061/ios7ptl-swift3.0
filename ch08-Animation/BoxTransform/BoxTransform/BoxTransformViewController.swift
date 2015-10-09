//
//  BoxTransformViewController.swift
//  BoxTransform
//
//  Created by wj on 15/10/9.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class BoxTransformViewController: UIViewController {
    let kSize:CGFloat = 100
    let kPanScale:CGFloat = -1.0/100.0
    var contentLayer = CATransformLayer()
    
    
    func layer(x:CGFloat,y:CGFloat,z:CGFloat,color:UIColor,transform:CATransform3D)->CALayer{
        let layer = CALayer()
        layer.backgroundColor = color.CGColor
        layer.bounds = CGRectMake(0, 0, kSize, kSize)
        layer.position = CGPoint(x: x, y: y)
        layer.zPosition = z
        layer.transform = transform
        contentLayer.addSublayer(layer)
        return layer
    }
    
    func MakeSideRotation(x:CGFloat,y:CGFloat,z:CGFloat)->CATransform3D{
         return  CATransform3DMakeRotation(CGFloat( M_PI_2 ), x, y, z)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentLayer.frame = view.layer.bounds
        let  size = contentLayer.bounds.size
        contentLayer.transform = CATransform3DMakeTranslation(size.width/2, size.height/2, 0)
        view.layer.addSublayer(contentLayer)
        
        layer(0, y: -kSize/2, z: 0, color: UIColor.redColor(), transform: MakeSideRotation(1, y: 0, z: 0))
        
        layer(0, y: kSize/2, z: 0, color: UIColor.greenColor(), transform: MakeSideRotation(1, y: 0, z: 0))
        
        layer(kSize/2, y: 0, z: 0, color: UIColor.blueColor(), transform: MakeSideRotation(0 , y: 1, z: 0))
        
        layer(-kSize/2, y: 0, z: 0, color: UIColor.cyanColor(), transform: MakeSideRotation(0 , y: 1, z: 0))
        
        layer(0, y: 0, z: -kSize/2, color: UIColor.yellowColor(), transform: CATransform3DIdentity)
        
        layer(0, y: 0, z: kSize/2, color: UIColor.magentaColor(), transform: CATransform3DIdentity)

        let g = UIPanGestureRecognizer(target: self, action: Selector("pan:"))
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
