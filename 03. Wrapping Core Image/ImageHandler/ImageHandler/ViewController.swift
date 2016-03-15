//
//  ViewController.swift
//  ImageHandler
//
//  Created by wl on 16/3/15.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 10, y: 50, width: 250, height: 150)
        view.addSubview(imageView)
        let image = UIImage(named: "img")!
//        imageView.image = image?.addTextWatermark("哈哈").addRoundedCorner(10, sizetoFit: imageView.bounds.size)
        let watermarkBox = watermark("这是水印")
        let roundedCornerBox = roundedCorner(10, sizetoFit: imageView.bounds.size)
        imageView.image = roundedCornerBox(image)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

