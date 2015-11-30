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
        let URL = NSURL(string: "http://iosptl.com")!
        
        var location:NSURL?
        var error:NSError?
        
        let semaphore = dispatch_semaphore_create(0)
        
        NSURLSession.sharedSession().downloadTaskWithURL(URL) { (l, r , e) -> Void in
            location = l
            error = e
            dispatch_semaphore_signal(semaphore)
        }.resume()
        
        let timeoutInSeconds:Double = 2.0
        let timeout = dispatch_time(DISPATCH_TIME_NOW, Int64(timeoutInSeconds) * Int64(NSEC_PER_SEC))
        
        let timeoutResult = dispatch_semaphore_wait(semaphore, timeout)
        
        XCTAssertEqual(timeoutResult, 0, "timeout")
        XCTAssertNil(error, "Received an error:\(error)")
        XCTAssertNotNil(location, "Did not get a location")
  
    }
    
}
