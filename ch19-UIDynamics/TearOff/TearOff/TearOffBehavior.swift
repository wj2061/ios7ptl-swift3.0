//
//  TearOffBehavior.swift
//  TearOff
//
//  Created by wj on 15/11/19.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class TearOffBehavior: UIDynamicBehavior {
    var active = true
    
    init(view:DraggableView,anchor:CGPoint,handler:(tornView:DraggableView,newPinView:DraggableView)->Void){
        super.init()
        let snapBehavior = UISnapBehavior(item: view, snapToPoint: anchor)
        addChildBehavior(snapBehavior)
        
        let distance = min(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds))
        
        action = {
            if !self.pointsAreWithinDistance(view.center, p2: anchor, distance: distance){
                if self.active{
                    let newView = view.copy() as! DraggableView
                    view.superview?.addSubview(newView)
                    let newTearoffBehavior = TearOffBehavior(view: newView, anchor: anchor, handler: handler)
                    newTearoffBehavior.active = false
                    self.dynamicAnimator?.addBehavior(newTearoffBehavior)
                    handler(tornView: view, newPinView: newView)
                    self.dynamicAnimator?.removeBehavior(self)
                }
            }else{
                self.active = true
            }
        }
    }
    
    func pointsAreWithinDistance(p1:CGPoint,p2:CGPoint,distance:CGFloat)->Bool{
        let dx = Float( p1.x - p2.x)
        let dy = Float( p1.y - p2.y)
        let currentDistance = hypotf(dx,dy)
        return currentDistance < Float(distance)
    }

}
