//
//  CIImageProvider.swift
//  CoreImageDemo
//
//  Created by wl on 16/3/12.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit

// MARK: - 普通版


func blur(cImage: CIImage, radius: Double) -> CIImage {
    let parameter = [
        kCIInputRadiusKey : radius,
        kCIInputImageKey : cImage
    ]
    
    let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parameter)!
    
    return filter.outputImage!
}

func colorGenerator(color: UIColor) -> CIImage {

    let c = CIColor(color: color)
    let parameters = [kCIInputColorKey: c]
    guard let filter = CIFilter(name: "CIConstantColorGenerator",
        withInputParameters: parameters) else { fatalError() }
    guard let outputImage = filter.outputImage else { fatalError() }
    return outputImage
}

func compositeSourceOver(cImage: CIImage, overlay: CIImage) -> CIImage {
    let parameters = [
        kCIInputBackgroundImageKey: cImage,
        kCIInputImageKey: overlay
    ]
    guard let filter = CIFilter(name: "CISourceOverCompositing",
        withInputParameters: parameters) else { fatalError() }
    guard let outputImage = filter.outputImage else { fatalError() }
    let cropRect = cImage.extent
    return outputImage.imageByCroppingToRect(cropRect)
}

func colorOverlay(cImage: CIImage, color: UIColor) -> CIImage {
    let overlay = colorGenerator(color)
    return compositeSourceOver(cImage, overlay: overlay)
}


// MARK: - 高阶函数版

typealias Filter = CIImage -> CIImage

func blurF(radius: Double) -> Filter {
    return { image in
        let parameter = [
            kCIInputRadiusKey : radius,
            kCIInputImageKey : image
        ]
        let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parameter)!
        return filter.outputImage!
    }
}

func colorGeneratorF(color: UIColor) -> Filter {
    return { _ in
        let c = CIColor(color: color)
        let parameters = [kCIInputColorKey: c]
        guard let filter = CIFilter(name: "CIConstantColorGenerator",
            withInputParameters: parameters) else { fatalError() }
        guard let outputImage = filter.outputImage else {
            fatalError()
        }
        return outputImage
    }
}

func compositeSourceOverF(overlay: CIImage) -> Filter {
    return { image in
        let parameters = [
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlay
        ]
        guard let filter = CIFilter(name: "CISourceOverCompositing",
            withInputParameters: parameters) else { fatalError() }
        guard let outputImage = filter.outputImage else { fatalError() }
        let cropRect = image.extent
        return outputImage.imageByCroppingToRect(cropRect)
    }
}

func colorOverlayF(color: UIColor) -> Filter {
    return { image in
        let overlay = colorGeneratorF(color)(image)
        return compositeSourceOverF(overlay)(image)
    }
}

func composeFilters(filter1: Filter, _ filter2: Filter) -> Filter {
    return { image in filter2(filter1(image)) }
}



infix operator >>> { associativity left}

func >>> (filter1: Filter, filter2: Filter) -> Filter {
    return {img in filter1(filter2(img))}
}