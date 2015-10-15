//
//  JuliaOperation.swift
//  JuliaOp
//
//  Created by wj on 15/10/15.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
import CoreGraphics;

class JuliaOperation: NSOperation {
//    (long double)random()/LONG_MAX + I*(long double)random()/LONG_MAX;
//Double(random()/LONG_MAX) + Double(random()/LONG_MAX).i
    var c :Complex64 = 0.0 + 0.i
    
//    var blowup : Complex64 = 0.0 + 0.i
    var blowup:Complex64 = 0.0 + 0.i
    
    
    var width = 0
    var height = 0
    var contentScaleFactor: CGFloat = 0
    var rScale = 0
    var gScale = 0
    var bScale = 0
    var image : UIImage?
    
    
    func f(z:Complex64,c :Complex64)->Complex64{
        return z*z + c
    }
    
    override var description:String{ get{return "(\(c.real), \(c.imag))\(contentScaleFactor)"}}
    
    override func main(){
        let components = 4
//        var data = NSMutableData(length: width*height*components*sizeof(__uint8_t))!
//        let bits = data.mutableBytes
        let bits = UnsafeMutablePointer<Int>.alloc(width*height*components*sizeof(__uint8_t))
        let kScale:Double = 1.5
        
        for y in 0..<height{
            for x in 0..<width{
                if self.cancelled{
                    return
                }
                var iteration = 0
                let temx = (kScale*Double(x*2))/Double(width)-kScale
                let temy = (kScale*Double(y*2))/Double(width)-kScale

                var z:Complex64  = temx + temy.i
                while z.abs<0.8 && iteration < 256{
                    z=f(z,c: c)
                    iteration++
                }
                let offset = y*width*components + x*components
                
                bits[offset+0] = iteration * rScale
                bits[offset+1] = iteration * bScale
                bits[offset+2] = iteration * gScale
            }
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.NoneSkipLast.rawValue)
        
        let context = CGBitmapContextCreate(bits, width, height, 8, width * components, colorSpace, bitmapInfo.rawValue)
        
        let cgImage = CGBitmapContextCreateImage(context)
        image = UIImage(CGImage: cgImage!, scale: contentScaleFactor, orientation: UIImageOrientation.Up)
    }
}
