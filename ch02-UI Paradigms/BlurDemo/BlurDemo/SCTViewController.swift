//
//  ViewController.swift
//  BlurDemo
//
//  Created by WJ on 15/9/29.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class SCTViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
//    var layer = CALayer()
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))

    
    @IBAction func buttonAction() {
        /*
        layer.frame=CGRectMake(80, 100, 160, 160)
        view.layer.addSublayer(layer)
        let scale = UIScreen.mainScreen().scale
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, true, scale)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: false)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if  let imageref = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(layer.frame.origin.x*scale,
                                                                                  layer.frame.origin.y*scale,
                                                                                  layer.frame.size.width*scale,
                                                                                  layer.frame.size.height*scale))
        {
           image = UIImage(CGImage: imageref)
        }
        */
        // I gave up.
        
        if view.subviews.contains(blurEffectView){
            blurEffectView.removeFromSuperview()
        }else{
            blurEffectView.frame = CGRect(x: 80, y: 100, width: 160, height: 160)
            view.addSubview(blurEffectView)
        }
    }
}

