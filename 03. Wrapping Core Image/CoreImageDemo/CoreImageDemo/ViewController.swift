//
//  ViewController.swift
//  CoreImageDemo
//
//  Created by wl on 16/3/12.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        testBlurWithOverlayF()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func testBlur() {
        let url = NSURL(string: "http://img2.3lian.com/2014/f5/158/d/86.jpg")!
        let image = CIImage(contentsOfURL: url)!
        
        let blurRadius = 5.0
        let blurredImage = blur(image, radius: blurRadius)
        
        imageView.image = UIImage(CIImage: blurredImage)
    }
    
    func testOverlay() {
        let url = NSURL(string: "http://img2.3lian.com/2014/f5/158/d/86.jpg")!
        let image = CIImage(contentsOfURL: url)!
        
        let overlayColor = UIColor.redColor().colorWithAlphaComponent(0.2)
        let overlaidImage = colorOverlay(image, color: overlayColor)
        imageView.image = UIImage(CIImage: overlaidImage)
    }

    
    func testBlurWithOverlay() {
        let url = NSURL(string: "http://img2.3lian.com/2014/f5/158/d/86.jpg")!
        let image = CIImage(contentsOfURL: url)!
        
        let blurRadius = 5.0
        let blurredImage = blur(image, radius: blurRadius)
        let overlayColor = UIColor.redColor().colorWithAlphaComponent(0.2)
        let overlaidImage = colorOverlay(blurredImage, color: overlayColor)
        
        imageView.image = UIImage(CIImage: overlaidImage)
    }
    
    
    func testBlurF() {
        let url = NSURL(string: "http://img2.3lian.com/2014/f5/158/d/86.jpg")!
        let image = CIImage(contentsOfURL: url)!
        
        let blurRadius = 5.0
        let blurredImage = blurF(blurRadius)
        
        imageView.image = UIImage(CIImage: blurredImage(image))
    }
    func testOverlayF() {
        let url = NSURL(string: "http://img2.3lian.com/2014/f5/158/d/86.jpg")!
        let image = CIImage(contentsOfURL: url)!
        let overlayColor = UIColor.redColor().colorWithAlphaComponent(0.2)
        let overlaidImage = colorOverlayF(overlayColor)(image)
        imageView.image = UIImage(CIImage: overlaidImage)
    }
    
    func testBlurWithOverlayF() {
        let url = NSURL(string: "http://img2.3lian.com/2014/f5/158/d/86.jpg")!
        let image = CIImage(contentsOfURL: url)!
        
        let blurRadius = 5.0
        let blurredImage = blurF(blurRadius)(image)
        let overlayColor = UIColor.redColor().colorWithAlphaComponent(0.2)
        
        let overlaidImage = colorOverlayF(overlayColor)(blurredImage)
        
//        let myFilter = blurF(blurRadius) >>> colorOverlayF(overlayColor)
//        myFilter(image)
        
        imageView.image = UIImage(CIImage: overlaidImage)
    }

}

