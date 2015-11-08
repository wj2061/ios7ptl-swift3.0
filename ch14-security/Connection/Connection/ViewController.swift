//
//  ViewController.swift
//  Connection
//
//  Created by wj on 15/11/7.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit



class ViewController: UIViewController ,NSURLSessionDelegate,NSURLSessionDataDelegate{
    var connection: NSURLConnection!
    var session:NSURLSession?
    
    var task : NSURLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "https://encrypted.google.com")!
        
        let configure = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: configure, delegate: self, delegateQueue: nil)
        
        task =  session!.dataTaskWithURL(url)  {(data, response, error) in
            print("2")
        }
        task?.resume()
    }
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {

        print("Am in NSURLSessionDelegate didReceiveChallenge")
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust  {
            NSLog("yep authorised")
            let credential = NSURLCredential(trust: challenge.protectionSpace.serverTrust!)
            challenge.sender!.useCredential(credential, forAuthenticationChallenge: challenge)
        } else {
            NSLog("nope")
        }
        
        
        let credential = NSURLCredential(trust: challenge.protectionSpace.serverTrust!)

        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential,credential)

        print("trust: \(challenge.protectionSpace.authenticationMethod)")
        
    }
}

