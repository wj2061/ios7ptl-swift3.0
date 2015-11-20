//
//  DragViewController.swift
//  CollectionDrag
//
//  Created by WJ on 15/11/19.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class DragViewController: UICollectionViewController {

    @IBAction func handleLongPress(sender: UILongPressGestureRecognizer) {
        let dragLayout = collectionViewLayout as! DragLayout
        let location = sender.locationInView(collectionView!)
        
        if  let indexPath = collectionView!.indexPathForItemAtPoint(location){
            let cell = collectionView!.cellForItemAtIndexPath(indexPath)!
            switch sender.state{
            case .Began:
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    cell.backgroundColor = UIColor.redColor()
                })
                dragLayout.startDraggingIndexPath(indexPath, fromPoint: location)
            case .Ended ,.Cancelled:
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    cell.backgroundColor = UIColor.lightGrayColor()
                })
                dragLayout.stopDraging()
            default:
                dragLayout.updateDragLocation(location)
            }
        }  
    }



    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        return cell
    }
}
