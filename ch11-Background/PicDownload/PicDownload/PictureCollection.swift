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
        let url = FlickrFetcher.URLforRecentGeoreferencedPhotos()
       downloadManager.fetchDataAtURL(url) { (data, error ) -> Void in
        if let err = error {
            print("Error downloading metadata:\(err )")
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.updatePicturesWithMetadata(data!)
            })
        }
        }
    }
    
    func documentURLForPath(path:String)->NSURL{
        return cPTLDownloadManager.documentDirectoryURL.URLByAppendingPathComponent(path)
    }
    
    func updatePicturesWithMetadata(data:NSData){
        print("\(__FUNCTION__)")
        willChangeValueForKey("count")
        do {
             let dict = try NSJSONSerialization.JSONObjectWithData(data, options: [])
             let pictureInfos = dict.valueForKeyPath(FLICKR_RESULTS_PHOTOS) as! NSArray
            for pictureInfo in pictureInfos{
                let picURL = FlickrFetcher.URLforPhoto(pictureInfo as!  [NSObject : AnyObject], format: FlickrPhotoFormatOriginal)
              
                let picture = Picture(RemoteURL: picURL, manager: downloadManager)
                pictures.append(picture )
                print(pictures.count)
            }
        }catch{
            print("Error parsing metadata")
        }
        didChangeValueForKey("count")
    }
    
    func pictureAtIndex(index:Int)->Picture{
        return pictures[index]
    }
    
    func reset(){
        let fm = NSFileManager.defaultManager()
            for pic in pictures{
                do{
                try fm.removeItemAtURL(pic.localURL())
                }catch{}
            }
    }
    
}
