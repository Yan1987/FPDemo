//
//  ViewController.swift
//  01Demo1
//
//  Created by wl on 16/3/20.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        test2()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func test1() {
        let blueSquare = square(1).fill(UIColor.blueColor())
        let redSquare = square(2).fill(UIColor.redColor())
        let greenCircle = circle(1).fill(UIColor.greenColor())
        let exa = blueSquare ||| redSquare ||| greenCircle
        let dView = DiagramView(frame: view.bounds, diagrame: exa)
        dView.backgroundColor = UIColor.whiteColor()
        view.addSubview(dView)
    }
    
    func test2() {
        let cities = ["Shanghai": 14.01,
            "Istanbul": 13.3,
            "Moscow": 10.56,
            "New York": 8.33,
            "Berlin": 3.43]
        
        let exa = barGraph(cities.keysAndValues)
        let dView = DiagramView(frame: view.bounds, diagrame: exa)
        dView.backgroundColor = UIColor.whiteColor()
        view.addSubview(dView)
    }

}




