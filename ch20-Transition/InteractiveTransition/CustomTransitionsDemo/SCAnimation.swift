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
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        print("an")
        let src = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let dest = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        var f = src.view.frame
        let originalSourceRect = f
        
        f.origin.y = f.size.height
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            src.view.frame = f
            }, completion: { (_) -> Void in
                src.view.alpha = 0
                dest.view.alpha = 0
                dest.view.frame = f
                transitionContext.containerView.addSubview(dest.view)
                
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    dest.view.alpha = 1
                    dest.view.frame = originalSourceRect
                    }, completion: { (_ ) -> Void in
                        src.view.alpha = 1
                        transitionContext.completeTransition(true)
                })
        }) 
    }
    

}
