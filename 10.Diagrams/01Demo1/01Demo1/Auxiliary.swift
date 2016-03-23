//
//  Auxiliary.swift
//  01Demo1
//
//  Created by wl on 16/3/20.
//  Copyright © 2016年 wl. All rights reserved.
//

import UIKit

struct Vector2D {
    let x: CGFloat
    let y: CGFloat
    var size: CGSize {
        return CGSize(width: x, height: y)
    }
}

extension CGSize {
    var point : CGPoint {
        return CGPointMake(self.width, self.height)
    }
}

extension Dictionary {
    var keysAndValues: [(Key, Value)] {
        var result: [(Key, Value)] = []
        for item in self {
            result.append(item)
        }
        return result
    }
}

func pointWise(f: (CGFloat, CGFloat) -> CGFloat,
            _ l: CGSize, _ r: CGSize ) -> CGSize {
    return CGSize(width: f(l.width, r.width),
        height: f(l.height, r.height))
}
func pointWise(f: (CGFloat, CGFloat) -> CGFloat,
            _ l: CGFloat, _ r: CGSize ) -> CGSize {
    return CGSize(width: f(l, r.width),
        height: f(l, r.height))
}
func pointWise(f: (CGFloat, CGFloat) -> CGFloat,
            _ l: CGPoint, _ r: CGPoint ) -> CGPoint {
    return CGPoint(x: l.x - r.x, y: l.y - r.y)
}

func isHorizontalEdge(edge: CGRectEdge) -> Bool {
    switch edge {
    case .MaxXEdge, .MinXEdge:
        return true
    default:
        return false
    }
}

func splitRect(rect: CGRect, sizeRatio: CGSize,
    edge: CGRectEdge)  -> (CGRect, CGRect) {
    let ratio = isHorizontalEdge(edge)
                ? sizeRatio.width
                : sizeRatio.height
    let multiplier = isHorizontalEdge(edge)
                ? rect.width
                : rect.height
    let distance: CGFloat = ratio * multiplier
    var mySlice: CGRect = CGRectZero
    var myRemainder: CGRect = CGRectZero
    CGRectDivide(rect, &mySlice, &myRemainder,
        distance, edge)
    return (mySlice, myRemainder)
}

func splitHorizontal(rect: CGRect,
    ratio: CGSize) -> (CGRect, CGRect) {
    return splitRect(rect, sizeRatio: ratio,
        edge: CGRectEdge.MinXEdge)
}
func splitVertical(rect: CGRect,
    ratio: CGSize) -> (CGRect, CGRect) {
        return splitRect(rect, sizeRatio: ratio,
            edge: CGRectEdge.MinYEdge)
}
func /(l: CGSize, r: CGSize) -> CGSize {
    return pointWise(/, l, r)
}


func *(l: CGFloat, r: CGSize) -> CGSize {
    return pointWise(*, l, r)
}
func *(l: CGSize, r: CGSize) -> CGSize {
    return pointWise(*, l, r)
}

func -(l: CGSize, r: CGSize) -> CGSize {
    return pointWise(-, l, r)
}
func -(l: CGPoint, r: CGPoint) -> CGPoint {
    return pointWise(-, l, r)
}



