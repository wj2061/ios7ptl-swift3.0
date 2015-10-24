//
//  PictureCell.swift
//  PicDownload
//
//  Created by wj on 15/10/25.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var picture:Picture?{
        willSet{
            if let pic = picture{
                pic.removeObserver(self, forKeyPath: "image")
            }
        }
        
        
        didSet{
            if let pic = picture{
                pic.addObserver(self, forKeyPath: "image", options: [], context: nil)
            }
            reloadImageView()
        }
    }
    
    
    func reloadImageView(){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.imageView.image = self.picture?.image
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        print("reload")
        reloadImageView()
    }
    
}
