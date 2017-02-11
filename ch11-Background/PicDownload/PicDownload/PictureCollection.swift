//
//  PictureCollection.swift
//  PicDownload
//
//  Created by wj on 15/10/24.
//  Copyright © 2015年 wj. All rights reserved.
//

import Foundation

class PictureCollection:NSObject{
    let downloadManager = PTLDownloadManager(identifier: cPTLDownloadManager.Identifier)
    var pictures = [Picture]()
    var count:Int{get{ return pictures.count}}
    
    override init(){
        super.init()
        updatePictures()
    }
    
    
    func updatePictures(){
        let url = FlickrFetcher.urLforRecentGeoreferencedPhotos()
       downloadManager.fetchDataAtURL(url!) { (data, error ) -> Void in
        if let err = error {
            print("Error downloading metadata:\(err )")
        }else{
            DispatchQueue.main.async(execute: { () -> Void in
                self.updatePicturesWithMetadata(data!)
            })
        }
        }
    }
    
    func documentURLForPath(_ path:String)->URL{
        return cPTLDownloadManager.documentDirectoryURL.appendingPathComponent(path)
    }
    
    func updatePicturesWithMetadata(_ data:Data){
        print("\(#function)")
        willChangeValue(forKey: "count")
        do {
             let dict = try JSONSerialization.jsonObject(with: data, options: [])
             let pictureInfos = (dict as AnyObject).value(forKeyPath: FLICKR_RESULTS_PHOTOS) as! NSArray
            for pictureInfo in pictureInfos{
                let picURL = FlickrFetcher.urLforPhoto(pictureInfo as!  [AnyHashable: Any], format: FlickrPhotoFormatOriginal)
              
                let picture = Picture(RemoteURL: picURL!, manager: downloadManager)
                pictures.append(picture )
                print(pictures.count)
            }
        }catch{
            print("Error parsing metadata")
        }
        didChangeValue(forKey: "count")
    }
    
    func pictureAtIndex(_ index:Int)->Picture{
        return pictures[index]
    }
    
    func reset(){
        let fm = FileManager.default
            for pic in pictures{
                do{
                try fm.removeItem(at: pic.localURL() as URL)
                }catch{}
            }
    }
    
}
