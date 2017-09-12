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
        
        backgroundColor = UIColor.darkGray
        layer.borderWidth = 2
        
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DraggableView.handlePan(_:)))
        self.addGestureRecognizer(gestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handlePan(_ gesture: UIPanGestureRecognizer){
        switch gesture.state{
        case .cancelled,  .ended:
            stopDragging()
        default:
            let point = gesture.location(in: superview!)
            dragToPoint(point)
        }
    }

    func copy(with zone: NSZone?) -> Any {
        let newView = DraggableView(frame: CGRect.zero, animator: dynamicAnimator)
        newView.bounds = bounds
        newView.center = center
        newView.transform = transform
        newView.alpha = alpha
        return newView
    }

    func dragToPoint(_ point:CGPoint){
        if let behavior = snapBehavior{
            dynamicAnimator.removeBehavior(behavior)
        }
        snapBehavior = UISnapBehavior(item: self, snapTo: point)
        snapBehavior?.damping = 0.25
        dynamicAnimator.addBehavior(snapBehavior!)
    }
    
    func stopDragging(){
        dynamicAnimator.removeBehavior(snapBehavior!)
        snapBehavior = nil
    }

}
