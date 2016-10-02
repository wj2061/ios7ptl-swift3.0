//
//  MKMasonryLayout.swift
//  MasonryLayoutDemo
//
//  Created by wj on 15/9/27.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

protocol MKMasonryViewLayoutDelegate{
    func collectionView(_ collectionView:UICollectionView,layout:MKMasonryLayout,heightForItemAtIndexPath indexPath:IndexPath)->CGFloat
}

class MKMasonryLayout: UICollectionViewLayout {
    
    var numberOfColumns:Int = 3
    var interItemSpacing:CGFloat = 12.5
    var delegate:MKMasonryViewLayoutDelegate?
    
    fileprivate var lastYValueForColumn:[CGFloat] = [0,0,0]
    fileprivate var layoutInfo:[IndexPath:UICollectionViewLayoutAttributes] = [:]

    override func prepare() {
        print("prepare")
        
        lastYValueForColumn=[0,0,0]
        layoutInfo=[:]

        var currentColumn:Int = 0
        let fullWidth = collectionView!.frame.size.width
        let availableSpaceExcludingPadding = fullWidth-(interItemSpacing*CGFloat(numberOfColumns+1))
        let itemWidth = availableSpaceExcludingPadding/CGFloat(numberOfColumns)
        
        var indexPath=IndexPath(row: 0, section: 0)
        
        let numSections = collectionView!.numberOfSections
        
        for section in 0..<numSections{
            let numItems = collectionView!.numberOfItems(inSection: section)
            for item in 0..<numItems{
                indexPath=IndexPath(item: item, section: section)
                
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let x = interItemSpacing+(interItemSpacing+itemWidth)*CGFloat(currentColumn)
                var y = lastYValueForColumn[currentColumn]
                let height = delegate?.collectionView(collectionView!, layout: self, heightForItemAtIndexPath: indexPath) ?? itemWidth
                
                itemAttributes.frame = CGRect(x: x, y: y, width: itemWidth, height: height)
                y += height
                y += interItemSpacing
                
                lastYValueForColumn[currentColumn]=y
//                currentColumn++
//                if currentColumn>=numberOfColumns{ currentColumn=0 }
                currentColumn = nextColumn()
                layoutInfo[indexPath]=itemAttributes
            }
        }
    }
    
    fileprivate func nextColumn()->Int{
        var nextColumn = 0
        var minYValue = lastYValueForColumn[0]
        for column in 1..<numberOfColumns{
            if lastYValueForColumn[column]<minYValue{
                nextColumn = column
                minYValue = lastYValueForColumn[column]
            }
        }
        return nextColumn
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var allAttributes:[UICollectionViewLayoutAttributes]=[]
        for (_,attributes) in layoutInfo{
            if rect.intersects(attributes.frame){
                allAttributes.append(attributes)
            }
        }
        return allAttributes
    }
    
    override var collectionViewContentSize : CGSize {
        var maxHeight:CGFloat = 0.0
        for currentColumns in 0..<numberOfColumns{
            let y = lastYValueForColumn[currentColumns]
            maxHeight = max(y, maxHeight)
        }
        return CGSize(width: collectionView!.frame.width, height: maxHeight)
    }
}
