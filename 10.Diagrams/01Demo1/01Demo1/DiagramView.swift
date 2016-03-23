//
//  DiagramView.swift
//  01Demo1
//
//  Created by wl on 16/3/20.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit

class DiagramView: UIView {
    
    let diagrame: Diagram
    
    init(frame: CGRect, diagrame: Diagram) {
        self.diagrame = diagrame
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
//        let context = UIGraphicsGetCurrentContext()!
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.draw(bounds, diagrame)
        
    }
    
    
    func figure1(context: CGContextRef) {
        UIColor.blueColor().setFill()
        CGContextFillRect(context, CGRect(x: 0, y: 37.5, width: 75, height: 75))
        UIColor.redColor().setFill()
        CGContextFillRect(context, CGRectMake(75.0, 0.0, 150.0, 150.0))
        UIColor.greenColor().setFill()
        CGContextFillEllipseInRect(context, CGRectMake(225.0, 37.5, 75.0, 75.0))
    }
}


