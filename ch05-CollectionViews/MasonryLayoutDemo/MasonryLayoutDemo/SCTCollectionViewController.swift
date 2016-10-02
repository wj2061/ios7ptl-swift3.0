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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath)->CGSize{
        let randomHeight = 100.0 + CGFloat(arc4random()%140)
        return CGSize(width: 100, height: randomHeight)
    }
    
    // this will be called if our layout is MKMasonryViewLayout
    // MARK: MKMasonryViewLayoutDelegate
    func collectionView(_ collectionView: UICollectionView, layout: MKMasonryLayout, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        let randomHeight = 100.0 + CGFloat(arc4random()%140)
        return randomHeight
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("invalidateLayout")
      collectionView?.collectionViewLayout.invalidateLayout()
    }
    

}
