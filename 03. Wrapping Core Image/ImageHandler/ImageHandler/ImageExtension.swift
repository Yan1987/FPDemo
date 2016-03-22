//
//  ImageExtension.swift
//  ImageHandler
//
//  Created by wl on 16/3/15.
//  Copyright © 2016年 wl. All rights reserved.
//  普通版，提供参考

import UIKit

extension UIImage {
    
    /**
     添加简单的文字水印
     
     - parameter str: 水印内容
     */
    func addTextWatermark(str: String) -> UIImage {
        
        UIGraphicsBeginImageContext(self.size)

        self.drawInRect(CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let arrt = [
            NSFontAttributeName : UIFont.systemFontOfSize(50),
            NSForegroundColorAttributeName : UIColor.grayColor()
        ]
        NSString(string: str).drawAtPoint(CGPointZero, withAttributes: arrt)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndPDFContext()
        
        return newImage
    }

    /**
     添加圆角效果
     
     - parameter radius:    圆角大小
     - parameter sizetoFit: 希望的图片大小
     
     */
    func addRoundedCorner(radius: CGFloat, sizetoFit: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        CGContextAddPath(UIGraphicsGetCurrentContext(),
            UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners,
                cornerRadii: CGSize(width: radius, height: radius)).CGPath)
        CGContextClip(UIGraphicsGetCurrentContext())
        
        self.drawInRect(rect)
        CGContextDrawPath(UIGraphicsGetCurrentContext(), .FillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return output
    }
}