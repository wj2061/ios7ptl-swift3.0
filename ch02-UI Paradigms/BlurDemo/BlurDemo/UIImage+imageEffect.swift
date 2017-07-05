//
//  UIImage+imageEffect.swift
//  BlurDemo
//
//  Created by WJ on 2017/7/5.
//  Copyright © 2017年 wj. All rights reserved.
//

import Foundation
import Accelerate
import UIKit

extension UIImage{
    
    func applyLightEffect() -> UIImage?{
        let tintColor = UIColor(white: 1.0, alpha: 0.3);
        return self.applyBlur(blurRadius: 30, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil);
    }
    
    func applyExtraLightEffect() -> UIImage?{
        let tintColor = UIColor(white: 0.97, alpha: 0.82);
        return self.applyBlur(blurRadius: 20, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil);
    }
    
    func applyDarkEffect() -> UIImage? {
        let tintColor = UIColor(white: 0.11, alpha: 0.73);
        return self.applyBlur(blurRadius: 20, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil);
    }
    
    func applyTintEffect(tintColor:UIColor) -> UIImage?{
        let EffectColorAlpha = 0.6;
        var effectColor = tintColor;
        let componentCount = tintColor.cgColor.numberOfComponents;
        if componentCount == 2 {
            var b:CGFloat = 0;
            if tintColor.getWhite(&b, alpha: nil){
                effectColor = UIColor(white: b, alpha: CGFloat(EffectColorAlpha))
            }
        }else{
            var r:CGFloat = 0;
            var g:CGFloat = 0;
            var b:CGFloat = 0;
            if tintColor.getRed(&r, green: &g, blue: &b, alpha: nil) {
                effectColor = UIColor(red: r, green: g, blue: b, alpha: CGFloat(EffectColorAlpha));
            }
        }
        return self.applyBlur(blurRadius: 10, tintColor: effectColor, saturationDeltaFactor: -1.0, maskImage: nil)
    }
    

    func applyBlur(blurRadius:CGFloat, tintColor:UIColor?,  saturationDeltaFactor:CGFloat, maskImage: UIImage?) -> UIImage?{
        // Check pre-conditions.
        guard self.size.width >= 1 && self.size.height >= 1 else {
            print("*** error: invalid size: (\(String(format:"%.2f",self.size.width)) x \(String(format:"%.2f",self.size.width) )). Both dimensions must be >= 1: \(self)");
            return nil;
        }
        
        guard (self.cgImage != nil) else {
            print("*** error: image must be backed by a CGImage: \(self)");
            return nil;
        }
        
        guard maskImage == nil || maskImage?.cgImage != nil else {
            print("*** error: maskImage must be backed by a CGImage: \(String(describing: maskImage))");
            return nil;
        }
        
        let imageRect = CGRect(origin: .zero, size: self.size);
        var effectImage = self;
        
        let hasBlur = blurRadius > CGFloat.ulpOfOne
        let hasSaturationChange = fabs(saturationDeltaFactor - 1.0) > CGFloat.ulpOfOne;
        if hasBlur || hasSaturationChange {
            UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale);
            let effectInContext = UIGraphicsGetCurrentContext()!;
            effectInContext.scaleBy(x: 1.0, y: -1.0);
            effectInContext.translateBy(x: 0, y: -self.size.height);
            effectInContext.draw(self.cgImage!, in: imageRect);
            
            var effectInBuffer = vImage_Buffer(data: effectInContext.data,
                                               height: vImagePixelCount(effectInContext.height),
                                               width: vImagePixelCount(effectInContext.width),
                                               rowBytes: effectInContext.bytesPerRow);
            
            UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
            let effectOutContext = UIGraphicsGetCurrentContext()!;
            var effectOutBuffer = vImage_Buffer(data: effectOutContext.data,
                                                height: vImagePixelCount(effectOutContext.height),
                                                width: vImagePixelCount(effectOutContext.width),
                                                rowBytes: effectOutContext.bytesPerRow)
            
            if hasBlur {
                // A description of how to compute the box kernel width from the Gaussian
                // radius (aka standard deviation) appears in the SVG spec:
                // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                //
                // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                // successive box-blurs build a piece-wise quadratic convolution kernel, which
                // approximates the Gaussian kernel to within roughly 3%.
                //
                // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                //
                // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                //
                let inputRadius = blurRadius * UIScreen.main.scale;
                var radius = UInt32(inputRadius * 3.0 * sqrt(2 * CGFloat.pi) / 4 + 0.5);
                
                if radius%2 != 1 {
                    radius += 1; // force radius to be odd so that the three box-blur methodology works.
                }
                
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius,nil ,vImage_Flags(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius,nil ,vImage_Flags(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius,nil ,vImage_Flags(kvImageEdgeExtend))
            }
            var effectImageBuffersAreSwapped = false;
            if hasSaturationChange {
                let s = saturationDeltaFactor;
                let floatingPointSaturationMatrix:[CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                                      0,                    0,                    0,  1,
                ]
                
                let divisor:Int32 = 256;
                let matrixSize = floatingPointSaturationMatrix.count;
                var saturationMatrix = [Int16](repeating: 0, count: matrixSize);
                for i in 0...matrixSize-1{
                    saturationMatrix[i] = Int16(roundf(Float(floatingPointSaturationMatrix[i]*CGFloat(divisor))))
                }
                if hasBlur{
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, &saturationMatrix, divisor, nil, nil,vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true;
                }else{
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, &saturationMatrix, divisor, nil, nil,vImage_Flags(kvImageNoFlags))
                }
            }
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!;
            }
            UIGraphicsEndImageContext();

            
            if effectImageBuffersAreSwapped{
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!;
            }
            UIGraphicsEndImageContext();

        }
        
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let outputContext = UIGraphicsGetCurrentContext()!;
        outputContext.scaleBy(x: 1.0, y: -1.0);
        outputContext.translateBy(x: 0, y: -self.size.height);
        
        // Draw base image.
        outputContext.draw(self.cgImage!, in: imageRect);
        
        // Draw effect image.
        if hasBlur {
            outputContext.saveGState();
            if let image = maskImage{
                outputContext.clip(to: imageRect,mask: image.cgImage!);
            }
            outputContext.draw(effectImage.cgImage!, in: imageRect);
            outputContext.restoreGState();
        }
        
        // Add in color tint.
        if let color = tintColor {
            outputContext.saveGState();
            outputContext.setFillColor(color.cgColor);
            outputContext.fill(imageRect);
            outputContext.restoreGState();
        }
        
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return  outputImage;
        
    }
    
    
}
