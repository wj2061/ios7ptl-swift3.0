//
//  MKCollectionViewCell.swift
//  Cha5CollectionView
//
//  Created by wj on 15/9/19.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class MKCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        self.selectedBackgroundView=UIView(frame: self.frame)
        self.selectedBackgroundView?.backgroundColor=UIColor(white: 0.3, alpha: 0.5)
        
        self.photoView.layer.borderColor=UIColor.white.cgColor
        self.photoView.layer.borderWidth=5.0
        super.awakeFromNib()
    }
}
