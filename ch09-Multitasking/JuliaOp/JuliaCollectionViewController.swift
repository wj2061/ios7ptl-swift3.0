//
//  JuliaCollectionViewController.swift
//  JuliaOp
//
//  Created by wj on 15/10/15.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Julia"

class JuliaCollectionViewController: UICollectionViewController {
    let queue = NSOperationQueue()
    var scales = [CGFloat]()
    
    private func useAllScales(){
        let maxScale = UIScreen.mainScreen().scale
        let kIterations = 6.0
        let minScale = maxScale / CGFloat( pow(2.0, kIterations) )
        
        
        var temScales = [CGFloat]()

        for var scale = minScale ;scale<=maxScale; scale *= 2{
            temScales.append(scale)
        }
        scales = temScales
    }
    
    private func useMinimumScales(){
        scales = [scales.first!]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        useAllScales()
    }


    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! JuliaCell
        cell.configureWith(indexPath.row, queue: queue, scales: scales)
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        queue.cancelAllOperations()
        useMinimumScales()
    }
    
    override func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        useAllScales()
    }

  


}
