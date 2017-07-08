//
//  MKMasonryLayout.swift
//  MasonryLayoutDemo
//
//  Created by wj on 15/9/27.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

protocol MKMasonryViewLayoutDelegate:UICollectionViewDelegate{
    func collectionView(_ collectionView:UICollectionView,layout:MKMasonryLayout,heightForItemAtIndexPath indexPath:IndexPath)->CGFloat
}

class MKMasonryLayout: UICollectionViewLayout {
    
    let numberOfColumns:Int = 3
    let interItemSpacing:CGFloat = 12.5
    weak var delegate:MKMasonryViewLayoutDelegate?
    
    fileprivate var lastYValueForColumn:[CGFloat] = [0,0,0]
    fileprivate var layoutInfo:[IndexPath:UICollectionViewLayoutAttributes] = [:]

    override func prepare() {        
        lastYValueForColumn = [0,0,0]
        layoutInfo = [:]

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
                
                lastYValueForColumn[currentColumn] = y
                
                //this was the original implemation of iOS7-ptl
//                currentColumn += 1
//                if currentColumn >= numberOfColumns{
//                    currentColumn=0
//                }
                
                //this is another interesting implemation
                currentColumn = nextColumn()
                layoutInfo[indexPath]=itemAttributes
                //end
            }
        }
    }
    
    fileprivate func nextColumn()->Int{
        var nextColumn = 0
        var minYValue = lastYValueForColumn[0]
        
        for (index,value) in lastYValueForColumn.enumerated() {
            if value < minYValue {
                nextColumn = index
                minYValue = value
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
        let maxHeight =  lastYValueForColumn.reduce(0) {
            $1 > $0 ? $1 : $0
        }
        return CGSize(width: collectionView!.frame.width, height: maxHeight)
    }
}
