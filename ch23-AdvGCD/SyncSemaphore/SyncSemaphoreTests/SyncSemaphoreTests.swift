//
//  SyncSemaphoreTests.swift
//  SyncSemaphoreTests
//
//  Created by WJ on 15/11/30.
//  Copyright © 2015年 wj. All rights reserved.
//

import XCTest
@testable import SyncSemaphore

class SyncSemaphoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDownload(){
        let URL = Foundation.URL(string: "http://iosptl.com")!
        
        var location:Foundation.URL?
        var error:NSError?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.downloadTask(with: URL, completionHandler: { (l, r , e) -> Void in
            location = l
            error = e! as NSError
            semaphore.signal()
        }) .resume()
        
        let timeoutInSeconds:Double = 2.0
        let timeout = DispatchTime.now() + Double(Int64(timeoutInSeconds) * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        
        let timeoutResult = semaphore.wait(timeout: timeout)
        
        XCTAssertEqual(timeoutResult, .success, "timeout")
        XCTAssertNil(error, "Received an error:\(String(describing: error))")
        XCTAssertNotNil(location, "Did not get a location")
  
    }
    
}
