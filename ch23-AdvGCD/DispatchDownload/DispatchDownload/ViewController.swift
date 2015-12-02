//
//  ViewController.swift
//  DispatchDownload
//
//  Created by WJ on 15/12/1.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

let kHeaderDelimiterString = "\r\n\r\n"

class ViewController: UIViewController {
    lazy var headerDelimiter = kHeaderDelimiterString.dataUsingEncoding(NSUTF8StringEncoding)!
    
    func htons(value: CUnsignedShort) -> CUnsignedShort {
        return (value << 8) + (value >> 8);
    }
    
    func connectToHostName(hostName:String,port:Int) -> dispatch_fd_t{
        let s =  socket(PF_INET,SOCK_STREAM,0)
        guard s >= 0 else {   assert(false , "socket failed:\(errno)") }
        
        var sa = sockaddr_in()
        sa.sin_family = UInt8( AF_INET )
        sa.sin_port   = htons(CUnsignedShort(port))
        
        let he = gethostbyname(hostName)
        if he == nil{
            assert(false , "gethostbyname failure:\(errno)")
        }
        
        bcopy(he.memory.h_addr_list[0], &sa.sin_addr,Int( he.memory.h_length) )
        
        let cn = withUnsafePointer(&sa) {
            connect(s, UnsafePointer($0), socklen_t(sizeofValue(sa)))
        }
        
        if cn < 0{
            assert(false , "cn<0")
        }
        
        
//        var buffer = [CChar](count: 128, repeatedValue: 0)
//        if connect(s,UnsafeMutablePointer( &sa ), sizeof(sa) ) < 0 {
//            
//        }
        return s
    }
    
    func outputFilePathForPath(path:String)->String{
        return (NSTemporaryDirectory() as NSString ).stringByAppendingPathComponent((path as NSString).lastPathComponent)
    }
    
    func writeToChannel(channel:dispatch_io_t,writeData:dispatch_data_t,queue:dispatch_queue_t){
        dispatch_io_write(channel, 0, writeData, queue) { (done , remainingData, error) -> Void in
            assert(error == 0, "File write error:\(error )")
            var unwrittenDataLength = 0
            if remainingData != nil{
                unwrittenDataLength = dispatch_data_get_size(remainingData)
            }
            print("Wrote \(dispatch_data_get_size(writeData) - unwrittenDataLength) bytes")
        }
    }

    func handleDoneWithChannels(channels:[dispatch_io_t]){
        print("Done Downloading")
        for channel in channels{
            dispatch_io_close(channel, 0)
        }
    }
    
    func findHeaderInData(newData:dispatch_data_t,
                     previousData:dispatch_data_t,
                     writeChannel:dispatch_io_t,
                            queue:dispatch_queue_t)->dispatch_data_t?{
        let  preData = dispatch_data_create_concat(previousData, newData)
        let  mappedData = dispatch_data_create_map(preData, nil, nil)
        var  headerData :dispatch_data_t?
        var  bodyData   :dispatch_data_t?
        dispatch_data_apply(mappedData) { (region , offset , buffer , size ) -> Bool in
            var bf = buffer
            let search = NSData(bytesNoCopy: &bf, length: size, freeWhenDone: false)
            let  r     = search.rangeOfData(self.headerDelimiter, options: [], range: NSMakeRange(0, search.length))
            if r.location != NSNotFound{
                headerData = dispatch_data_create_subrange(region , 0, r.location)
                let body_offset = NSMaxRange(r)
                let body_size   = size - body_offset
                bodyData        = dispatch_data_create_subrange(region , body_offset, body_size)
            }
            return false
       }
       if bodyData != nil{
            writeToChannel(writeChannel, writeData: bodyData!, queue: queue)
       }
    return headerData
    }
    
    func printHeader(headerData:dispatch_data_t){
        print("\nHeader:\n\n")
        dispatch_data_apply(headerData) { (region , offset , buffer , size ) -> Bool in
            fwrite(buffer, size, 1, stdout)
            return true
        }
        print("\n\n")
    }
    
    func readFromChannel(readChannel:dispatch_io_t,writeChannel:dispatch_io_t,queue:dispatch_queue_t){
        let previousData = dispatch_data_empty
        var headerData  : dispatch_data_t?
        dispatch_io_read(readChannel, 0,Int.max, queue) { (serverReadDone, serverReadData, serverReadError) -> Void in
            assert(serverReadError == 0, "Server read error:\(serverReadError)")
            if serverReadData != nil{
                self.handleDoneWithChannels([writeChannel,readChannel])
            }else{
                if headerData == nil{
                    headerData = self.findHeaderInData(serverReadData, previousData: previousData, writeChannel: writeChannel, queue: queue)
                    if headerData != nil{
                        self.printHeader(headerData!)
                    }
                }
                else{
                    self.writeToChannel(writeChannel, writeData: serverReadData, queue: queue)
                }
            }
        }
    }
    
    func requestDataForHostName(hostName:String,path:String)->dispatch_data_t{
        let  getString = "GET \(path) HTTP/1.1\r\nHost: \(hostName)\r\n\r\n"
        print("Request:\n\(getString)" )
        let getData = getString.dataUsingEncoding(NSUTF8StringEncoding)
        return dispatch_data_create(getData!.bytes, getData!.length, nil, _dispatch_data_destructor_free)
    }
    
    func HTTPDownloadContentsFromHostName(hostName:String,port:Int,path:String){
        let queue = dispatch_get_main_queue()
        let socket = connectToHostName(hostName, port: port)
        let serverChannel = dispatch_io_create(DISPATCH_IO_STREAM, socket, queue) { (error ) -> Void in
            assert(error == 0, "Failed socket:\(error )")
            print("Closing connection")
            close(socket)
        }
        let requestData = requestDataForHostName(hostName, path: path)
        let writePath   = outputFilePathForPath(path)
        print("Writing to \(writePath)")
        
        let fileChannel = dispatch_io_create_with_path(DISPATCH_IO_STREAM, writePath, O_WRONLY|O_CREAT|O_TRUNC, S_IRWXU, queue, nil)
        dispatch_io_write(serverChannel, 0, requestData, queue) { (serverWriteDone, serverWriteData, error ) -> Void in
            assert(error == 0, "Failed socket:\(error )")
            if serverWriteDone{
                self.readFromChannel(serverChannel, writeChannel: fileChannel, queue: queue)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HTTPDownloadContentsFromHostName("upload.wikimedia.org",
                                     port: 80,
                                     path: "/wikipedia/commons/9/97/The_Earth_seen_from_Apollo_17.jpg")
    }
}

