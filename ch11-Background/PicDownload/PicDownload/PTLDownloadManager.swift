//
//  File.swift
//  PicDownload
//
//  Created by wj on 15/10/24.
//  Copyright © 2015年 wj. All rights reserved.
//

import Foundation

class PTLDownloadManager:NSObject, NSURLSessionDelegate{
    var backgroundSessionCompletionHandler:(()->Void)?
    
    static var downloadManagers = [String:PTLDownloadManager]()
  

    
    private let foregroundSession = NSURLSession.sharedSession()
    private var backgroundSession:NSURLSession!
    
    init(identifier:String){
        super.init()
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(identifier)
        backgroundSession = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    class func downloadManagerWithIdentifier(identifier:String)->PTLDownloadManager {
        var downloadManager = downloadManagers[identifier]
        if downloadManager == nil {
          downloadManager =  PTLDownloadManager(identifier: identifier)
          downloadManagers[identifier] = downloadManager
        }
        return downloadManager!
    }
    
    func fetchDataAtURL(url:NSURL,handle:(NSData?,NSError?)->Void){
        print("\(__FUNCTION__):\(url)")
      
        let task = foregroundSession.dataTaskWithURL(url) { (data , response , error ) -> Void in
            handle(data,error )
        }
        task.resume()
        print("exit:\(__FUNCTION__)")
    }
    
    func downloadURLToDocuments(url:NSURL){
        print("\(__FUNCTION__):\(url)")
        let task = backgroundSession.downloadTaskWithURL(url)
        task.resume()
    }
    
    func localURLForRemoteURL(url:NSURL)->NSURL{
        let filename = url.lastPathComponent
        let lcurl = cPTLDownloadManager.documentDirectoryURL.URLByAppendingPathComponent(filename!)
        return lcurl
    }
    
    func moveFileFromLocation(url:NSURL,task:NSURLSessionDownloadTask){
        let sourceURL = task.originalRequest?.URL
        let destURL = localURLForRemoteURL(sourceURL!)
        
        let fm = NSFileManager.defaultManager()
        if fm.fileExistsAtPath(destURL.path!){
            do {
                try  fm.removeItemAtURL(destURL)
            }catch{
                print("Could not delete file")
            }
        }
        
        do {
            try fm.moveItemAtURL(url, toURL: destURL)
            let center = NSNotificationCenter.defaultCenter()
            center.postNotificationName(cPTLDownloadManager.DidDownloadFileNotification,
                                       object: self,
                                      userInfo: [cPTLDownloadManager.SourceURLKey:sourceURL!,
                                                 cPTLDownloadManager.DestinationURLKey:destURL])
            
        }catch{
            print("Could not move file")
        }
    }
    
    func  URLSession(session: NSURLSession,  downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL){
        print("\(__FUNCTION__)\(location)")
        moveFileFromLocation(location, task: downloadTask)
    }
    
    func URLSession(session: NSURLSession,  task: NSURLSessionTask, didCompleteWithError error: NSError?){
        backgroundSession.getTasksWithCompletionHandler { (datatasks , uploadtasks, downloadtasks ) -> Void in
            let count = datatasks.count + uploadtasks.count + downloadtasks.count
            if count == 0{
                if let handle =  self.backgroundSessionCompletionHandler{
                    self.backgroundSessionCompletionHandler = nil
                    handle()
                }
            }
        }
        
    }
}

protocol PTLDownloadManagerDelegate{
    func downloadManager(manager: PTLDownloadManager,FromURL:NSURL, toURL:NSURL)
}

struct cPTLDownloadManager{
    static let DidDownloadFileNotification = "PTLDownloadManagerDidDownloadFileNotification"
    static let SourceURLKey = "PTLDownloadManagerSourceURLKey"
    static let DestinationURLKey = "PTLDownloadManagerDestinationURLKey"
    static let Identifier = "com.iosptl.PicDownloader.PictureCollection"
    static let documentDirectoryURL = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!)
}



