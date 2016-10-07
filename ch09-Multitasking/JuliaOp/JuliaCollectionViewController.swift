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
    let queue = OperationQueue()
    var scales = [CGFloat]()
    
    fileprivate func useAllScales(){
        let maxScale = UIScreen.main.scale
        let kIterations = 6.0
        let minScale = maxScale / CGFloat( pow(2.0, kIterations) )
        
        
        var temScales = [CGFloat]()
        
        var scale = minScale
        repeat{
            temScales.append(scale)
            scale *= 2
        }while scale <= maxScale
        
//        for scale in stride(from: 0, to: 10, by: 1) {
//            
//        }

//        for var scale = minScale ;scale<=maxScale; scale *= 2{
//            temScales.append(scale)
//        }
        scales = temScales
    }
    
    fileprivate func useMinimumScales(){
        scales = [scales.first!]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        useAllScales()
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! JuliaCell
        cell.configureWith((indexPath as NSIndexPath).row, queue: queue, scales: scales)
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        queue.cancelAllOperations()
        useMinimumScales()
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        useAllScales()
    }

  


}
