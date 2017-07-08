//
//  MkCoverFlowLayout.swift
//  CoverFlowDemo
//
//  Created by wj on 15/9/27.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class MkCoverFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        scrollDirection=UICollectionViewScrollDirection.horizontal
        if let size = collectionView?.frame.size{
           itemSize = CGSize(width: size.width/4, height: size.height*0.7)
           sectionInset = UIEdgeInsetsMake(size.height*0.15, size.height*0.1, size.height*0.15, size.height*0.1)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    struct Constant  {
       static let zoomFactor:CGFloat = 0.35
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if  let allAttributesArray = super.layoutAttributesForElements(in: rect){
            var visibleRect:CGRect =  CGRect.zero
            visibleRect.origin=collectionView!.contentOffset
            visibleRect.size = collectionView!.bounds.size
            let collectionViewHalfFrame = collectionView!.frame.width/2
            
            for attribute in allAttributesArray{
                if rect.intersects(attribute.frame){
                    let distance = visibleRect.midX - attribute.frame.midX
                    let normalizeddistance =  distance/collectionViewHalfFrame
                    
                    if abs(distance)<collectionViewHalfFrame{
                        let zoom = 1 + Constant.zoomFactor*(1-abs( normalizeddistance))
                        var rotationAndPerspectiveTransform = CATransform3DIdentity
                        rotationAndPerspectiveTransform.m34 = 1/(-500.0)
                        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, normalizeddistance*CGFloat(Double.pi/4), 0, 1, 0)
                        let zoomTranform = CATransform3DMakeScale(zoom, zoom, 0)
                        attribute.transform3D = CATransform3DConcat(zoomTranform, rotationAndPerspectiveTransform)
                        attribute.zIndex = Int(abs(normalizeddistance)*10.0)
                        let alpha = (1-abs(normalizeddistance))+0.1
                        attribute.alpha=alpha
                    }else{
                        attribute.alpha=0
                    }
                }
            }
            return allAttributesArray
        }else {
           return nil
        }
    }
    

}
