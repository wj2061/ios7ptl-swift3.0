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


class MKViewController: UICollectionViewController ,UIAdaptivePresentationControllerDelegate{
    var  photoList:[String]?
    fileprivate var  photoOrientation=[PhotoOrientation]()
    fileprivate var  photosCache = [String:UIImage]()
    
    
    func photoDirectory()->String{
        return Bundle.main.resourcePath! + "/Photos"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(photoDirectory())
        var photosArray:[String]?
        do{
          try   photosArray=FileManager.default.contentsOfDirectory(atPath: photoDirectory())
        }catch{
        
        }
        if photosArray != nil{
            DispatchQueue.global(qos: .userInitiated).async { () -> Void in
                for  obj in photosArray!{
                    let path = self.photoDirectory() + "/" + obj
                    if let image  = UIImage(contentsOfFile: path){
                        let size = image.size
                        if size.width>size.height{
                            self.photoOrientation.append(PhotoOrientation.photoOrientationLandscape)
                        }else{
                            self.photoOrientation.append(PhotoOrientation.photoOrientationPortrait)
                        }
                    }
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.photoList=photosArray
                    self.collectionView?.reloadData()
                })
            }
        }
    }

    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainSegue"{
            let selectedIndexPath = sender as! IndexPath
            let photoName = photoList![(selectedIndexPath as NSIndexPath).row]
            let controller = segue.destination as! MKDetailsViewController
            controller.photoPath = photoDirectory()+"/"+photoName
            if let pc = controller.presentationController{
                pc.delegate=self
            }
        }
    }
    
    //MARK: -AdaptivePresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.photoList?.count ?? 0
    }

    fileprivate struct cellReuseIdentifier{
     static   let landscape="MKPhotoCellLandscape"
     static   let portrait="MKPhotoCellPortrait"
     static   let Supplementaryr="SupplementaryViewIdentifier"
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  orientation = self.photoOrientation[(indexPath as NSIndexPath).row]
        let identifier = orientation==PhotoOrientation.photoOrientationLandscape ? cellReuseIdentifier.landscape :cellReuseIdentifier.portrait
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MKCollectionViewCell
        let photoName = self.photoList?[(indexPath as NSIndexPath).row] ?? ""
        let photoFilePath = self.photoDirectory()+"/"+photoName
        cell.nameLabel.text = NSString(string: photoName).deletingPathExtension
        var thumbImage = self.photosCache[photoName]
        cell.photoView.image = thumbImage
        if thumbImage == nil{
           DispatchQueue.global(qos:.userInitiated).async(execute: { () -> Void in
            if let image = UIImage(contentsOfFile: photoFilePath){
                if orientation == PhotoOrientation.photoOrientationPortrait{
                    UIGraphicsBeginImageContext(CGSize(width: 180.0, height: 120.0))
                    image.draw(in: CGRect(x: 0, y: 0, width: 180.0, height: 120.0))
                    thumbImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                }else{
                    
                    UIGraphicsBeginImageContext(CGSize(width: 120.0, height: 180.0))
                    image.draw(in: CGRect(x: 0, y: 0, width: 120.0, height: 180.0))
                    thumbImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                }
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.photosCache[photoName] = thumbImage
                cell.photoView.image=thumbImage
            })
            
           })
        }
        return cell
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MainSegue", sender: indexPath)
    }
    
    // MARK: UICollectionViewDelegate

    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cellReuseIdentifier.Supplementaryr, for: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    

}
