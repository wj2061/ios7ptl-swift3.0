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


class MKViewController: UICollectionViewController ,UIAdaptivePresentationControllerDelegate{
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

    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MainSegue"{
            let selectedIndexPath = sender as! NSIndexPath
            let photoName = photoList![selectedIndexPath.row]
            let controller = segue.destinationViewController as! MKDetailsViewController
            controller.photoPath = photoDirectory()+"/"+photoName
            if let pc = controller.presentationController{
                pc.delegate=self
            }
        }
    }
    
    //MARK: -AdaptivePresentationControllerDelegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.photoList?.count ?? 0
    }

    private struct cellReuseIdentifier{
     static   let landscape="MKPhotoCellLandscape"
     static   let portrait="MKPhotoCellPortrait"
     static   let Supplementaryr="SupplementaryViewIdentifier"
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let  orientation = self.photoOrientation[indexPath.row]
        let identifier = orientation==PhotoOrientation.PhotoOrientationLandscape ? cellReuseIdentifier.landscape :cellReuseIdentifier.portrait
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! MKCollectionViewCell
        let photoName = self.photoList?[indexPath.row] ?? ""
        let photoFilePath = self.photoDirectory()+"/"+photoName
        cell.nameLabel.text = NSString(string: photoName).stringByDeletingPathExtension
        var thumbImage = self.photosCache.objectForKey(photoName) as? UIImage
        cell.photoView.image = thumbImage
        if thumbImage == nil{
           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            if let image = UIImage(contentsOfFile: photoFilePath){
                if orientation == PhotoOrientation.PhotoOrientationPortrait{
                    UIGraphicsBeginImageContext(CGSizeMake(180.0, 120.0))
                    image.drawInRect(CGRectMake(0, 0, 180.0, 120.0))
                    thumbImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                }else{
                    
                    UIGraphicsBeginImageContext(CGSizeMake(120.0, 180.0))
                    image.drawInRect(CGRectMake(0, 0, 120.0, 180.0))
                    thumbImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.photosCache.setObject(thumbImage!, forKey: photoName)
                cell.photoView.image=thumbImage
            })
            
           })
        }
        return cell
    }

    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("MainSegue", sender: indexPath)
    }
    
    // MARK: UICollectionViewDelegate

    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: cellReuseIdentifier.Supplementaryr, forIndexPath: indexPath)
    }
    
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

}
