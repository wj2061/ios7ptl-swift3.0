//
//  File.swift
//  PicDownload
//
//  Created by wj on 15/10/24.
//  Copyright © 2015年 wj. All rights reserved.
//

import Foundation

class PTLDownloadManager:NSObject, URLSessionDelegate{
    var backgroundSessionCompletionHandler:(()->Void)?
    
    static var downloadManagers = [String:PTLDownloadManager]()
  

    
    fileprivate let foregroundSession = Foundation.URLSession.shared
    fileprivate var backgroundSession:Foundation.URLSession!
    
    init(identifier:String){
        super.init()
        let configuration = URLSessionConfiguration.background(withIdentifier: identifier)
        backgroundSession = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    class func downloadManagerWithIdentifier(_ identifier:String)->PTLDownloadManager {
        var downloadManager = downloadManagers[identifier]
        if downloadManager == nil {
          downloadManager =  PTLDownloadManager(identifier: identifier)
          downloadManagers[identifier] = downloadManager
        }
        return downloadManager!
    }
    
    func fetchDataAtURL(_ url:URL,handle:@escaping (Data?,NSError?)->Void){
        print("\(#function):\(url)")
      
        let task = foregroundSession.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            handle(data, error as NSError?);
        }
 
        task.resume()
        print("exit:\(#function)")
    }
    
    func downloadURLToDocuments(_ url:URL){
        print("\(#function):\(url)")
        let task = backgroundSession.downloadTask(with: url)
        task.resume()
    }
    
    func localURLForRemoteURL(_ url:URL)->URL{
        let filename = url.lastPathComponent
        let lcurl = cPTLDownloadManager.documentDirectoryURL.appendingPathComponent(filename)
        return lcurl
    }
    
    func moveFileFromLocation(_ url:URL,task:URLSessionDownloadTask){
        let sourceURL = task.originalRequest?.url
        let destURL = localURLForRemoteURL(sourceURL!)
        
        let fm = FileManager.default
        if fm.fileExists(atPath: destURL.path){
            do {
                try  fm.removeItem(at: destURL)
            }catch{
                print("Could not delete file")
            }
        }
        
        do {
            try fm.moveItem(at: url, to: destURL)
            let center = NotificationCenter.default
            center.post(name: Notification.Name(rawValue: cPTLDownloadManager.DidDownloadFileNotification),
                                       object: self,
                                      userInfo: [cPTLDownloadManager.SourceURLKey:sourceURL!,
                                                 cPTLDownloadManager.DestinationURLKey:destURL])
            
        }catch{
            print("Could not move file")
        }
    }
    
    func  URLSession(_ session: Foundation.URLSession,  downloadTask: URLSessionDownloadTask, didFinishDownloadingToURL location: URL){
        print("\(#function)\(location)")
        moveFileFromLocation(location, task: downloadTask)
    }
    
    func URLSession(_ session: Foundation.URLSession,  task: URLSessionTask, didCompleteWithError error: NSError?){
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
    func downloadManager(_ manager: PTLDownloadManager,FromURL:URL, toURL:URL)
}

struct cPTLDownloadManager{
    static let DidDownloadFileNotification = "PTLDownloadManagerDidDownloadFileNotification"
    static let SourceURLKey = "PTLDownloadManagerSourceURLKey"
    static let DestinationURLKey = "PTLDownloadManagerDestinationURLKey"
    static let Identifier = "com.iosptl.PicDownloader.PictureCollection"
    static let documentDirectoryURL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!)
}



