//
//  DraggableView.swift
//  TearOff
//
//  Created by wj on 15/11/19.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class DraggableView: UIView,NSCopying {
    var dynamicAnimator:UIDynamicAnimator
    var gestureRecognizer:UIPanGestureRecognizer!
    var snapBehavior:UISnapBehavior?
    
    init(frame:CGRect,animator:UIDynamicAnimator){
        dynamicAnimator = animator
        super.init(frame: frame)
        
        backgroundColor = UIColor.darkGrayColor()
        layer.borderWidth = 2
        
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        self.addGestureRecognizer(gestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handlePan(gesture: UIPanGestureRecognizer){
        switch gesture.state{
        case .Cancelled,  .Ended:
            stopDragging()
        default:
            let point = gesture.locationInView(superview!)
            dragToPoint(point)
        }
    }

    func copyWithZone(zone: NSZone) -> AnyObject {
        let newView = DraggableView(frame: CGRectZero, animator: dynamicAnimator)
        newView.bounds = bounds
        newView.center = center
        newView.transform = transform
        newView.alpha = alpha
        return newView
    }

    func dragToPoint(point:CGPoint){
        if let behavior = snapBehavior{
            dynamicAnimator.removeBehavior(behavior)
        }
        snapBehavior = UISnapBehavior(item: self, snapToPoint: point)
        snapBehavior?.damping = 0.25
        dynamicAnimator.addBehavior(snapBehavior!)
    }
    
    func stopDragging(){
        dynamicAnimator.removeBehavior(snapBehavior!)
        snapBehavior = nil
    }

}
