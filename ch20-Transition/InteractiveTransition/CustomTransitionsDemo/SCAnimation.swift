//
//  SCAnimation.swift
//  InteractiveCustomTransitionsDemo
//
//  Created by wj on 15/11/21.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class SCAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var dismissal = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        print("an")
        let src = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let dest = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        var f = src.view.frame
        let originalSourceRect = f
        
        f.origin.y = f.size.height
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            src.view.frame = f
            }) { (_) -> Void in
                src.view.alpha = 0
                dest.view.alpha = 0
                dest.view.frame = f
                transitionContext.containerView()?.addSubview(dest.view)
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    dest.view.alpha = 1
                    dest.view.frame = originalSourceRect
                    }, completion: { (_ ) -> Void in
                        src.view.alpha = 1
                        transitionContext.completeTransition(true)
                })
        }
    }
    

}
