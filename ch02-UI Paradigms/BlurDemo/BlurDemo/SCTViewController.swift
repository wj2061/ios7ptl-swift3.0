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
    
    var blurLayer = CALayer()
    
    
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))

    
    @IBAction func buttonAction() {
        
        if (view.layer.sublayers?.contains(blurLayer))! {
            blurLayer.removeFromSuperlayer()
        }else{
            if (blurLayer.contents == nil) {
                self.constructBlurLayer()
            }
            view.layer.addSublayer(blurLayer)
            
        }
        
        // since iOS 8.0, use UIVisualEffectView instead
        
        if view.subviews.contains(blurEffectView){
            blurEffectView.removeFromSuperview()
        }else{
            blurEffectView.frame = CGRect(x: 120, y: 300, width: 160, height: 160)
            view.addSubview(blurEffectView)
        }
    }
    
    func constructBlurLayer() {
        blurLayer.frame=CGRect(x: 80, y: 100, width: 160, height: 160)
        view.layer.addSublayer(blurLayer)
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(blurLayer.frame.size, true, scale)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: false)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if  let imageref = image!.cgImage!.cropping(to: CGRect(x:blurLayer.frame.origin.x*scale,
                                                               y:blurLayer.frame.origin.y*scale,
                                                               width:blurLayer.frame.size.width*scale,
                                                               height:blurLayer.frame.size.height*scale))
        {
            image = UIImage(cgImage: imageref)
//            image = image!.applyBlur(withRadius: 50, tintColor: UIColor(red:0, green:1, blue:0, alpha:0.1), saturationDeltaFactor: 2, maskImage: nil)
            image = image!.applyBlur(blurRadius:50, tintColor:UIColor(red:0, green:1, blue:0, alpha:0.1),  saturationDeltaFactor:2, maskImage: nil)
            self.blurLayer.contents = image!.cgImage
        }
    }
}

