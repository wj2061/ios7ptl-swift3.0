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
    lazy var headerDelimiter = kHeaderDelimiterString.data(using: String.Encoding.utf8)!
    
    func htons(_ value: CUnsignedShort) -> CUnsignedShort {
        return (value << 8) + (value >> 8);
    }
    
    func connectToHostName(_ hostName:String,port:Int) -> Int32{
        let s =  socket(PF_INET,SOCK_STREAM,0)
        guard s >= 0 else {   assert(false , "socket failed:\(errno)") }
        
        var sa = sockaddr_in()
        sa.sin_family = UInt8( AF_INET )
        sa.sin_port   = htons(CUnsignedShort(port))
        
        let he = gethostbyname(hostName)
        if he == nil{
            assert(false , "gethostbyname failure:\(errno)")
        }
        
        bcopy(he?.pointee.h_addr_list[0], &sa.sin_addr,Int( (he?.pointee.h_length)!) )
        
        let cn = withUnsafePointer(to: &sa) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                connect(s, UnsafePointer($0), socklen_t(MemoryLayout.size(ofValue: sa)))
            }
        }
        
        
        if cn < 0{
            assert(false , "cn<0")
        }
        
        return s
    }
    
    func outputFilePathForPath(_ path:String)->String{
        return (NSTemporaryDirectory() as NSString ).appendingPathComponent((path as NSString).lastPathComponent)
    }
    
    func writeToChannel(_ channel:DispatchIO,writeData:DispatchData,queue:DispatchQueue){
        channel.write(offset: 0, data: writeData, queue: queue) { (done , remainingData, error) -> Void in
            assert(error == 0, "File write error:\(error )")
            var unwrittenDataLength = 0
            if remainingData != nil{
                unwrittenDataLength = (remainingData?.count)!
            }
            print("Wrote \(writeData.count - unwrittenDataLength) bytes")
        }
    }

    func handleDoneWithChannels(_ channels:[DispatchIO]){
        print("Done Downloading")
        for channel in channels{
            channel.close(flags: DispatchIO.CloseFlags(rawValue: 0))
        }
    }
    
    func findHeaderInData(_ newData:DispatchData,
                   previousData:inout DispatchData,
                     writeChannel:DispatchIO,
                            queue:DispatchQueue)->DispatchData?{

        let  mappedData = __dispatch_data_create_concat(previousData as __DispatchData, newData as __DispatchData)
        var  headerData :__DispatchData?
        var  bodyData   :__DispatchData?
        
        
        __dispatch_data_apply(mappedData) { (region, offset, buffer, size) -> Bool in
            var bf = buffer
            let search = NSData(bytesNoCopy: &bf, length: size, freeWhenDone: false)
            let  r     = search.range(of: self.headerDelimiter, options: [], in: NSMakeRange(0, search.length))
            if r.location != NSNotFound{
                headerData = __dispatch_data_create_subrange(region, 0, r.location)
                let body_offset = NSMaxRange(r)
                let body_size   = size - body_offset
                bodyData        = __dispatch_data_create_subrange(region, body_offset, body_size)
            }
            return false
        }
       if bodyData != nil{
            writeToChannel(writeChannel, writeData: bodyData! as DispatchData, queue: queue)
       }
    return headerData! as DispatchData
    }
    
    func printHeader(_ headerData:DispatchData){
        print("\nHeader:\n\n")
        
        __dispatch_data_apply(headerData as __DispatchData) { (region, offset, buffer, size) -> Bool in
            fwrite(buffer, size, 1, stdout)
            return true
        }
        print("\n\n")
    }
    
    func readFromChannel(_ readChannel:DispatchIO,writeChannel:DispatchIO,queue:DispatchQueue){
        var previousData = DispatchData.empty
        var headerData  : DispatchData?
        readChannel.read(offset: 0,length: Int.max, queue: queue) { (serverReadDone, serverReadData, serverReadError) -> Void in
            assert(serverReadError == 0, "Server read error:\(serverReadError)")
            if serverReadData != nil{
                self.handleDoneWithChannels([writeChannel,readChannel])
            }else{
                if headerData == nil{
                    headerData = self.findHeaderInData(serverReadData!, previousData: &previousData, writeChannel: writeChannel, queue: queue)
                    if headerData != nil{
                        self.printHeader(headerData!)
                    }
                }
                else{
                    self.writeToChannel(writeChannel, writeData: serverReadData!, queue: queue)
                }
            }
        }
    }
    
    func requestDataForHostName(_ hostName:String,path:String)->DispatchData{
        let  getString = "GET \(path) HTTP/1.1\r\nHost: \(hostName)\r\n\r\n"
        print("Request:\n\(getString)" )
        let getData = getString.data(using: String.Encoding.utf8)
        
        return DispatchData(referencing:getData!)
    }
    
    func HTTPDownloadContentsFromHostName(_ hostName:String,port:Int,path:String){
        let queue = DispatchQueue.main
        let socket = connectToHostName(hostName, port: port)
        let serverChannel = DispatchIO(__type: DispatchIO.StreamType.stream.rawValue, fd: socket, queue: queue) { (error) in
            assert(error == 0, "Failed socket:\(error )")
            print("Closing connection")
            close(socket)
        }

        let requestData = requestDataForHostName(hostName, path: path)
        let writePath   = outputFilePathForPath(path)
        print("Writing to \(writePath)")
        
        
        let fileChannel = DispatchIO(__type: DispatchIO.StreamType.stream.rawValue, path: writePath, oflag: O_WRONLY|O_CREAT|O_TRUNC, mode: S_IRWXU, queue: queue) {(error) in
            
            }
        serverChannel.write(offset: 0, data: requestData, queue: queue) { (serverWriteDone, serverWriteData, error ) -> Void in
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


extension DispatchData {
    
    init(referencing data: Data) {
        guard !data.isEmpty else {
            self = .empty
            return
        }
        
        // will perform a copy if needed
        let nsData = data as NSData
        
        if let dispatchData = ((nsData as AnyObject) as? DispatchData) {
            self = dispatchData
        } else {
            self = .empty
            nsData.enumerateBytes { (bytes, byteRange, _) in
                let innerData = Unmanaged.passRetained(nsData)
                let buffer = UnsafeBufferPointer(start: bytes.assumingMemoryBound(to: UInt8.self), count: byteRange.length)
                let chunk = DispatchData(bytesNoCopy: buffer, deallocator: .custom(nil, innerData.release))
                append(chunk)
            }
        }
    }
    
}
