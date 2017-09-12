//
//  DragLayout.swift
//  CollectionDrag
//
//  Created by WJ on 15/11/19.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class DragLayout: UICollectionViewFlowLayout {
    var indexPath:IndexPath?
    lazy var animatar: UIDynamicAnimator? = {
        return    UIDynamicAnimator(collectionViewLayout: self)
    }()
    var behaivor:UIAttachmentBehavior?
    
    func startDraggingIndexPath(_ indexpath:IndexPath,fromPoint:CGPoint){
        animatar?.removeAllBehaviors()

        self.indexPath = indexpath
        
        let attributes = super.layoutAttributesForItem(at: indexpath)
        attributes!.zIndex += 1
        
        behaivor = UIAttachmentBehavior(item: attributes!, attachedToAnchor: fromPoint)
        behaivor?.length = 0
        behaivor?.frequency = 10
        animatar?.addBehavior(behaivor!)
        
        let dynamicItem = UIDynamicItemBehavior(items: [attributes!])
        dynamicItem.resistance = 10
        animatar?.addBehavior(dynamicItem)
        
        updateDragLocation(fromPoint)
    }
    
    func updateDragLocation(_ point:CGPoint){
        behaivor?.anchorPoint = point
    }

    func stopDraging(){
        if let  index = indexPath{
        let attributes = super.layoutAttributesForItem(at: index)
        updateDragLocation(attributes!.center)
        indexPath = nil
        behaivor = nil
        }
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let existingAttributes = super.layoutAttributesForElements(in: rect)
        var allAttributes = [UICollectionViewLayoutAttributes]()
        for attribute in existingAttributes!{
            if attribute.indexPath != indexPath{
                allAttributes.append(attribute)
            }
//            else{
//                allAttributes.appendContentsOf( [animatar!.layoutAttributesForCellAtIndexPath(indexPath!)!])
//            }
        } 
//        animatar!.layoutAttributesForCellAtIndexPath(indexPath!)
        allAttributes.append(contentsOf: animatar!.items(in: rect) as! [UICollectionViewLayoutAttributes])
     return allAttributes
    }
    
    
}
