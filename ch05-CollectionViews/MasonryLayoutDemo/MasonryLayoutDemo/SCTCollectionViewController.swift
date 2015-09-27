//
//  SCTCollectionViewController.swift
//  MasonryLayoutDemo
//
//  Created by wj on 15/9/27.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SCTCollectionViewController: UICollectionViewController,MKMasonryViewLayoutDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView?.collectionViewLayout  as? MKMasonryLayout{
            layout.delegate=self
        }
    }
 
    // this will be called if our layout is UICollectionViewFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath)->CGSize{
        let randomHeight = 100.0 + CGFloat(random()%140)
        return CGSizeMake(100, randomHeight)
    }
    
    // this will be called if our layout is MKMasonryViewLayout
    // MARK: MKMasonryViewLayoutDelegate
    func collectionView(collectionView: UICollectionView, layout: MKMasonryLayout, heightForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let randomHeight = 100.0 + CGFloat(random()%140)
        return randomHeight
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        return cell
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("invalidateLayout")
      collectionView?.collectionViewLayout.invalidateLayout()
    }
    

}
