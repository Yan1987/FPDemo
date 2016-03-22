//
//  HighOrderWay.swift
//  ImageHandler
//
//  Created by wl on 16/3/15.
//  Copyright © 2016年 wl. All rights reserved.
//  使用高阶函数的版本，提供参考

import UIKit

typealias ImageBox = UIImage -> UIImage


func watermark(str: String) -> ImageBox {
    return { img in
        UIGraphicsBeginImageContext(img.size)
        
        img.drawInRect(CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height))
        let arrt = [
            NSFontAttributeName : UIFont.systemFontOfSize(50),
            NSForegroundColorAttributeName : UIColor.grayColor()
        ]
        NSString(string: str).drawAtPoint(CGPointZero, withAttributes: arrt)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndPDFContext()
        
        return newImage

    }

}


func roundedCorner(radius: CGFloat, sizetoFit: CGSize) -> ImageBox {
    return { image in
        
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        CGContextAddPath(UIGraphicsGetCurrentContext(),
            UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners,
                cornerRadii: CGSize(width: radius, height: radius)).CGPath)
        CGContextClip(UIGraphicsGetCurrentContext())
        
        image.drawInRect(rect)
        CGContextDrawPath(UIGraphicsGetCurrentContext(), .FillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return output
        
    }
}
//自定义操作符只能在全局范围定义
infix operator >>> {associativity left}

func >>> (imageBox1: ImageBox, imageBox2: ImageBox) -> ImageBox {
    return {img in imageBox2(imageBox1(img))}
}


