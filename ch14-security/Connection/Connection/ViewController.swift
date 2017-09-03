//
//  ViewController.swift
//  Connection
//
//  Created by wj on 15/11/7.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit



class ViewController: UIViewController ,URLSessionDelegate,URLSessionDataDelegate{
    var connection: NSURLConnection!
    var session:Foundation.URLSession?
    
    var task : URLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://encrypted.google.com")!
        
        let configure = URLSessionConfiguration.default
        session = Foundation.URLSession(configuration: configure, delegate: self, delegateQueue: nil)
        
        task =  session!.dataTask(with: url, completionHandler: {(data, response, error) in
            print("2")
        })  
        task?.resume()
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        print("Am in NSURLSessionDelegate didReceiveChallenge")
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust  {
            NSLog("yep authorised")
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            challenge.sender!.use(credential, for: challenge)
        } else {
            NSLog("nope")
        }
        
        
        let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

        completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential,credential)

        print("trust: \(challenge.protectionSpace.authenticationMethod)")
        
    }
}

