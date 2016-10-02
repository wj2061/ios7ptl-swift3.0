//
//  MKViewController.swift
//  CollectionViewDemo
//
//  Created by wj on 15/9/22.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit


private enum PhotoOrientation{
    case  photoOrientationLandscape
    case  photoOrientationPortrait
}


class MKViewController: UICollectionViewController ,UICollectionViewDelegateFlowLayout{
    var  photoList:[String]?
    fileprivate var  photoOrientation = [PhotoOrientation]()
    fileprivate var  photosCache = [String:UIImage]()
    
    func photoDirectory()->String{
        return Bundle.main.resourcePath! + "/Photos"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var photosArray:[String]!
        do{
            try   photosArray = FileManager.default.contentsOfDirectory(atPath: photoDirectory())
        }catch(let error){
            print("There is an error when init photos: \(error.localizedDescription)")
            return;
        }
        
        DispatchQueue.global(qos: .`default`).async { () -> Void in
            photosArray.forEach({ (obj) in
                let path = self.photoDirectory() + "/" + obj
                if let image  = UIImage(contentsOfFile: path){
                    let size = image.size
                    if size.width>size.height{
                        self.photoOrientation.append(.photoOrientationLandscape)
                    }else{
                        self.photoOrientation.append(.photoOrientationPortrait)
                    }
                }
            })
            DispatchQueue.main.async{ () -> Void in
                self.photoList = photosArray
                self.collectionView?.reloadData()
            };
        }
    }

    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.photoList?.count ?? 0
    }

    fileprivate struct cellReuseIdentifier{
     static   let landscape="MKPhotoCell"
     static   let portrait="MKPhotoCell"
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  orientation = self.photoOrientation[(indexPath as NSIndexPath).row]
        let identifier = orientation==PhotoOrientation.photoOrientationLandscape ? cellReuseIdentifier.landscape :cellReuseIdentifier.portrait
        let size = orientation==PhotoOrientation.photoOrientationLandscape ? CGSize(width: 200, height: 300):CGSize(width: 300, height: 200)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MKCollectionViewCell
        let photoName = self.photoList?[(indexPath as NSIndexPath).row] ?? ""
        let photoFilePath = self.photoDirectory()+"/"+photoName
        var thumbImage = self.photosCache[photoName]
        cell.photoView.image = thumbImage
        if thumbImage == nil{
           DispatchQueue.global(qos: .default).async(execute: { () -> Void in
            if let image = UIImage(contentsOfFile: photoFilePath){
                
//                let layout = collectionView.collectionViewLayout as! MkCoverFlowLayout
                let scale = UIScreen.main.scale
                UIGraphicsBeginImageContextWithOptions(size, true, scale)
                image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                thumbImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.photosCache[photoName] = thumbImage
                cell.photoView.image=thumbImage
            })
            
           })
        }
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let orientation = photoOrientation[indexPath.row]
        if orientation == PhotoOrientation.photoOrientationPortrait{
            return CGSize(width: 200 , height: 300)
        }else {
            return CGSize(width: 300 , height: 200)
        }
    }

    

}
