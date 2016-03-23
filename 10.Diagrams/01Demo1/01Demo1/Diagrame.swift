//
//  Diagrame.swift
//  01Demo1
//
//  Created by wl on 16/3/20.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit

enum Primitive {
    case Ellipes
    case Rectangle
    case Text(String)
}

indirect enum Diagram {
    case Prim(CGSize, Primitive)
    case Beside(Diagram, Diagram)
    case Below(Diagram, Diagram)
    case Attributed(Attribute, Diagram)
    case Align(Vector2D, Diagram)
}

enum Attribute {
    case FillColor(UIColor)
}

extension Diagram {
    var size: CGSize {
        switch self {
        case .Prim(let size, _):
            return size
        case .Attributed(_, let x):
            return x.size
        case .Beside(let l , let r):
            return CGSize(width: l.size.width + r.size.width,
                height: max(l.size.height, r.size.height))
        case .Below(let l, let r):
            return CGSize(width: max(l.size.width, r.size.width),
                height: l.size.height + r.size.height)
        case .Align(_, let r):
            return r.size
        }
    }
}


extension CGSize {
    func fit(vector: Vector2D, _ rect: CGRect) -> CGRect {
        let scaleSize = rect.size / self
        let scale = min(scaleSize.width, scaleSize.height)
        let size = scale * self
        let space = vector.size * (size - rect.size)

        return CGRect(origin: rect.origin - space.point, size: size)
    }
}

extension CGContextRef {
    func draw(bounds: CGRect, _ diagram: Diagram) {
        switch diagram {
        case .Prim(let size, .Ellipes):
            let frame = size.fit(Vector2D(x: 0.5, y: 0.5), bounds)
            CGContextFillEllipseInRect(self, frame)
        case .Prim(let size, .Rectangle):
            let frame = size.fit(Vector2D(x: 0.5, y: 0.5), bounds)
            CGContextFillRect(self, frame)
        case .Prim(let size, .Text(let text)):
            let frame = size.fit(Vector2D(x: 0.5, y: 0.5), bounds)
            let font = UIFont.systemFontOfSize(12)
            let attributes = [NSFontAttributeName : font]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            attributedText.drawInRect(frame)
        case .Attributed(.FillColor(let color), let d):
            CGContextSaveGState(self)
            color.set()
            draw(bounds, d)
            CGContextRestoreGState(self)
        case .Beside(let left, let right):
            let (lFrame, rFrame) = splitHorizontal(bounds, ratio: left.size / diagram.size)
            draw(lFrame, left)
            draw(rFrame, right)
        case .Below(let top, let bottom):
            let (lFrame, rFrame) = splitVertical(bounds, ratio: top.size / diagram.size)
            draw(lFrame, top)
            draw(rFrame, bottom)
        case .Align(let vec, let diagram):
            let frame = diagram.size.fit(vec, bounds)
            draw(frame, diagram)
        }
    }
}

func rect(width: CGFloat, height: CGFloat) -> Diagram {
    return .Prim(CGSize(width: width, height: height), .Rectangle)
}

func circle(diameter: CGFloat) -> Diagram {
    return .Prim(CGSize(width: diameter, height: diameter), .Ellipes)
}

func text(theText: String, width: CGFloat, height: CGFloat) -> Diagram {
    return .Prim(CGSize(width: width, height: height), .Text(theText))
}

func square(side: CGFloat) -> Diagram {
    return rect(side, height: side)
}


infix operator ||| { associativity left }
func ||| (l: Diagram, r: Diagram) -> Diagram {
    return Diagram.Beside(l, r)
}

infix operator --- {associativity left}
func --- (l: Diagram, r: Diagram) -> Diagram {
    return Diagram.Below(l, r)
}

extension Diagram {
    func fill(color: UIColor) -> Diagram {
        return .Attributed(.FillColor(color), self)
    }
    
    func alignTop() -> Diagram {
        return .Align(Vector2D(x: 0.5, y:  0), self)
    }
    
    func alignBottom() -> Diagram {
        return .Align(Vector2D(x: 0.5, y: 1), self)
    }
}


let empty: Diagram = rect(0, height: 0)
func hcat(diagrams: [Diagram]) -> Diagram {
    return diagrams.reduce(empty, combine: |||)
}
func barGraph(input: [(String, Double)]) -> Diagram {
    let values: [CGFloat] = input.map {CGFloat($0.1)}
    let nValue = normalize(values)
    let bars = hcat(nValue.map { (x: CGFloat) -> Diagram in
        return rect(1, height: 3 * x)
            .fill(UIColor.blackColor())
            .alignBottom()
        })
    let labels = hcat(input.map { x in
        return text(x.0, width: 1, height: 0.3).alignTop()
        })
    return bars --- labels
}

func normalize(input: [CGFloat]) -> [CGFloat] {
    let maxVal = input.reduce(0) {max($0, $1)}
    return input.map {$0 / maxVal}
}
