//
//  MKViewController.swift
//  CollectionViewDemo
//
//  Created by wj on 15/9/22.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit


private enum PhotoOrientation{
    case  PhotoOrientationLandscape
    case  PhotoOrientationPortrait
}


class MKViewController: UICollectionViewController ,UICollectionViewDelegateFlowLayout{
    var  photoList:[String]?
    private var  photoOrientation=[PhotoOrientation]()
    private var  photosCache = NSCache()
    
    func photoDirectory()->String{
        return NSBundle.mainBundle().resourcePath!.stringByAppendingString("/Photos")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(photoDirectory())
        var photosArray:[String]?
        do{
          try   photosArray=NSFileManager.defaultManager().contentsOfDirectoryAtPath(photoDirectory())
        }catch{
        
        }
        if photosArray != nil{
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                for  obj in photosArray!{
                    let path = self.photoDirectory() + "/" + obj
                    if let image  = UIImage(contentsOfFile: path){
                        let size = image.size
                        if size.width>size.height{
                            self.photoOrientation.append(PhotoOrientation.PhotoOrientationLandscape)
                        }else{
                            self.photoOrientation.append(PhotoOrientation.PhotoOrientationPortrait)
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.photoList=photosArray
                    self.collectionView?.reloadData()
                })
            }
        }
    }

    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.photoList?.count ?? 0
    }

    private struct cellReuseIdentifier{
     static   let landscape="MKPhotoCell"
     static   let portrait="MKPhotoCell"
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let  orientation = self.photoOrientation[indexPath.row]
        let identifier = orientation==PhotoOrientation.PhotoOrientationLandscape ? cellReuseIdentifier.landscape :cellReuseIdentifier.portrait
        let size = orientation==PhotoOrientation.PhotoOrientationLandscape ? CGSizeMake(200, 300):CGSizeMake(300, 200)
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! MKCollectionViewCell
        let photoName = self.photoList?[indexPath.row] ?? ""
        let photoFilePath = self.photoDirectory()+"/"+photoName
        var thumbImage = self.photosCache.objectForKey(photoName) as? UIImage
        cell.photoView.image = thumbImage
        if thumbImage == nil{
           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            if let image = UIImage(contentsOfFile: photoFilePath){
                
//                let layout = collectionView.collectionViewLayout as! MkCoverFlowLayout
                let scale = UIScreen.mainScreen().scale
                UIGraphicsBeginImageContextWithOptions(size, true, scale)
                image.drawInRect(CGRectMake(0, 0, size.width, size.height))
                thumbImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.photosCache.setObject(thumbImage!, forKey: photoName)
                cell.photoView.image=thumbImage
            })
            
           })
        }
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout

     func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let orientation = photoOrientation[indexPath.row]
        if orientation == PhotoOrientation.PhotoOrientationPortrait{
            return CGSizeMake(200 , 300)
        }else {
            return CGSizeMake(300 , 200)
        }
    }

    

}
