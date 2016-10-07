//
//  AppDelegate.swift
//  CoreFoundation
//
//  Created by wj on 15/10/18.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
import CoreFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //MARK: - Core Foundation Types

    func testTypeMismatch(){
        print("\(#function):")
        let errName:CFString = "error" as CFString
        let error = CFErrorCreate(kCFAllocatorDefault, errName, 0, nil)
        let  propertyList = error as CFPropertyList
        print("typeid(propertyList): \(CFGetTypeID(propertyList)) == typeid(Error): \(CFErrorGetTypeID())")
    }
    
    //MARK: - Creating Strings
    func testCString(){
        print("\(#function):")
        let  string = "Hello World!" as CFString
        CFShow(string)
    }
    
    func testPascalString(){
        print("\(#function):")
     
        let str = "test"
        var byteArray = [UInt8](str.utf8)
        print("k=\(byteArray)")

        let  string = CFStringCreateWithPascalString(kCFAllocatorDefault , &byteArray, CFStringBuiltInEncodings.UTF8.rawValue)
        // fail to fininsh
        CFShow(string)
//        let k = [UInt8]()
    }
    

    //MARK: - Converting to C strings
    func testCopyUTF8String(){
        print("\(#function):")
        let  string = "Hello"
        let cstring = [UInt8](string.utf8)
        let  result = String(bytes: cstring, encoding: String.Encoding.utf8)!
        
        print("\(result)")
    }
//    
//    static void testTreeInArray() {
//    PrintFunction();
//    CFTreeContext ctx = {0, (void*)CFSTR("Info"), CFRetain,
//    CFRelease, CFCopyDescription};
//    CFTreeRef tree = CFTreeCreate(NULL, &ctx);
//    NSArray *array = @[(__bridge id)tree];
//    
//    CFRelease(tree);
//    
//    NSLog(@"Array=%@", array);
//    }
    
    func testTreeInArray(){
        print("\(#function):")
        var info = "info"
        let ctx = CFTreeContext(version: CFIndex(0), info: &info, retain: nil  , release: nil, copyDescription: nil)
        let tree = CFTreeCreate(nil, [ctx])
        
        let array = Array(arrayLiteral: tree)
        print("tree = \(array)")
        
        

    }

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        testTypeMismatch()
        
         testCString()
        
        testPascalString()
        
        testCopyUTF8String()
        
        testTreeInArray()
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    


}

