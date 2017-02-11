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
    var remoteURL:URL
    var image:UIImage?
    var downloadManager:PTLDownloadManager
    
    init(RemoteURL:URL,manager:PTLDownloadManager){
        downloadManager = manager
        remoteURL = RemoteURL
        super.init()
        if !FileManager.default.fileExists(atPath: manager.localURLForRemoteURL(RemoteURL).path){
            downloadManager.downloadURLToDocuments(RemoteURL)
            NotificationCenter.default.addObserver(self, selector: #selector(Picture.downloadManagerDidDownloadFile(_:)), name: NSNotification.Name(rawValue: cPTLDownloadManager.DidDownloadFileNotification), object: nil)
        }
        reloadImage()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func downloadManagerDidDownloadFile(_ note:Notification){
        if let dict = note.userInfo as? [String:URL]{
            let url = dict[cPTLDownloadManager.SourceURLKey]
            if  url == remoteURL{
                reloadImage()
            }
        }
    }
    
    func reloadImage(){
        DispatchQueue.global(qos:.default).async { () -> Void in
            let image = UIImage(contentsOfFile: self.localURL().path)
            DispatchQueue.main.async(execute: { () -> Void in
                self.image = image
            })
        }
    }
    
    func localURL()->URL{
      return  downloadManager.localURLForRemoteURL(remoteURL)
    }
    
}
