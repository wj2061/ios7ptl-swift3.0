//
//  DefaultBehavior.swift
//  TearOff
//
//  Created by wj on 15/11/19.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class DefaultBehavior: UIDynamicBehavior {
    let gravityBehavior = UIGravityBehavior()

    let collisionBehavior = UICollisionBehavior()

    override init(){
        super.init()
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        self.addChildBehavior(collisionBehavior)
        
        self.addChildBehavior(gravityBehavior)
    }
    
    func addItem(_ item:UIDynamicItem){
        gravityBehavior.addItem(item)
        collisionBehavior.addItem(item)
    }
    
    func removeItem(_ item:UIDynamicItem){
        gravityBehavior.removeItem(item)
        collisionBehavior.removeItem(item)
    }
}
