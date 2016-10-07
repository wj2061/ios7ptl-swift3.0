//
//  JuliaOperation.swift
//  JuliaOp
//
//  Created by wj on 15/10/15.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
import CoreGraphics;


class JuliaOperation: Operation {
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
    
    
    func f(_ z:Complex64,c :Complex64)->Complex64{
        return z*z + c
    }
    
    override var description:String{ get{return "(\(c.real), \(c.imag))\(contentScaleFactor)"}}
    
    override func main(){
        let components:Int = 4
       
        let size = MemoryLayout<__uint8_t>.size
        let count = width*height*components*size
        
        let bits = UnsafeMutablePointer<Int>.allocate(capacity:count)
        let kScale:Double = 1.5
        
        for y in 0..<height{
            for x in 0..<width{
                if self.isCancelled{
                    return
                }
                var iteration = 0
                let temx = (kScale*Double(x*2))/(Double(width)-kScale)
                let temy = (kScale*Double(y*2))/(Double(width)-kScale)

                var z:Complex64  = temx + temy.i
                while z.tuple.0 < blowup.tuple.0 && iteration < 256{
                    z=self.f(z,c: self.c)
                    iteration += 1
                }
                let offset = y*width*components + x*components
                
                bits[offset+0] = (iteration * rScale)
                bits[offset+1] = (iteration * bScale)
                bits[offset+2] = (iteration * gScale)
            }
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue)
        
        let context = CGContext(data: bits, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * components, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        let cgImage = context?.makeImage()
        image = UIImage(cgImage: cgImage!, scale: contentScaleFactor, orientation: UIImageOrientation.up)
    }
}
