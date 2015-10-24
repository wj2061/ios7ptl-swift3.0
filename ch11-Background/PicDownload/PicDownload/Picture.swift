//
//  Picture.swift
//  PicDownload
//
//  Created by wj on 15/10/24.
//  Copyright © 2015年 wj. All rights reserved.
//

import Foundation
import UIKit
class Picture:NSObject{
    var remoteURL:NSURL
    var image:UIImage?
    var downloadManager:PTLDownloadManager
    
    init(RemoteURL:NSURL,manager:PTLDownloadManager){
        downloadManager = manager
        remoteURL = RemoteURL
        super.init()
        if !NSFileManager.defaultManager().fileExistsAtPath(manager.localURLForRemoteURL(RemoteURL).path!){
            downloadManager.downloadURLToDocuments(RemoteURL)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("downloadManagerDidDownloadFile:"), name: cPTLDownloadManager.DidDownloadFileNotification, object: nil)
        }
        reloadImage()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func downloadManagerDidDownloadFile(note:NSNotification){
        if let dict = note.userInfo as? [String:NSURL]{
            let url = dict[cPTLDownloadManager.SourceURLKey]
            if  url == remoteURL{
                reloadImage()
            }
        }
    }
    
    func reloadImage(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let image = UIImage(contentsOfFile: self.localURL().path!)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.image = image
            })
        }
    }
    
    func localURL()->NSURL{
      return  downloadManager.localURLForRemoteURL(remoteURL)
    }
    
}