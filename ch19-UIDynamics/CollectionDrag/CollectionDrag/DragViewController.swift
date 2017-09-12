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

    @IBAction func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        let dragLayout = collectionViewLayout as! DragLayout
        let location = sender.location(in: collectionView!)
        
        if  let indexPath = collectionView!.indexPathForItem(at: location){
            let cell = collectionView!.cellForItem(at: indexPath)!
            switch sender.state{
            case .began:
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    cell.backgroundColor = UIColor.red
                })
                dragLayout.startDraggingIndexPath(indexPath, fromPoint: location)
            case .ended ,.cancelled:
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    cell.backgroundColor = UIColor.lightGray
                })
                dragLayout.stopDraging()
            default:
                dragLayout.updateDragLocation(location)
            }
        }  
    }



    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}
