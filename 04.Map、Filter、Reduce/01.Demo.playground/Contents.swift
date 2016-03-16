//: Playground - noun: a place where people can play

import UIKit

/****************************************
 Map
*****************************************/

// 我们想让一个数组全部增加1，我们很快可以写出下面这个
func incrementArray(xs: [Int]) -> [Int] {
    var result: [Int] = []
    for x in xs {
        result.append(x + 1)
    }
    return result
}

//同样我们想让一个数组全部*2，可以写出下面这个
func doubleArray(xs: [Int]) -> [Int] {
    var result: [Int] = []
    for x in xs {
        result.append(x * 2)
    }
    return result
}

// 更具上面两个函数，我们可以抽象出这样一个新的函数应对上面两种情况
func computeIntArray(xs: [Int], transform: Int -> Int) -> [Int] {
    var result: [Int] = []
    for x in xs {
        result.append(transform(x))
    }
    return result
}

func doubleArray2(xs: [Int]) -> [Int] {
    return computeIntArray(xs) {$0 * 2}
}
// 但如果我们想判断一个数组中是否是偶数呢，利用上面的？
//func isEvenArray(xs: [Int]) -> [Bool] {
//    computeIntArray(xs) {$0 % 2 == 0}
//}Error

// 仿照computeIntArray，我们可能会写出这个函数来达成我们的目标
func computeBoolArray(xs: [Int], transform: Int -> Bool) -> [Bool] {
    var result: [Bool] = []
    for x in xs {
        result.append(transform(x))
    }
    return result
}

// 上面的函数不具扩展性，假如我们又想将其转为String类型的呢？继续写一个computeStringArray? 其实不用，我们可以利用泛型优雅的解决

func genericComputeArray1<T>(xs: [Int], transform: Int -> T) -> [T] {
    var result: [T] = []
    for x in xs {
        result.append(transform(x))
    }
    return result
}


//进一步抽象
func myMap<Element, T>(xs: [Element], transform: Element -> T) -> [T] {
    var result: [T] = []
    for x in xs {
        result.append(transform(x))
    }
    return result
}

extension Array {
    func myMap<T>(transform: Element -> T) -> [T] {
        var result: [T] = []
        for x in self {
            result.append(transform(x))
        }
        return result
    }
}

[1, 2, 3, 4].myMap(){$0 + 1}

/****************************************
Filter
*****************************************/
let exampleFiles = ["README.md", "HelloWorld.swift", "HelloSwift.swift", "FlappyBird.swift"]

func getSwiftFiles(files: [String]) -> [String] {
    var result: [String] = []
    for file in files {
        if file.hasSuffix(".swift") {
            result.append(file)
        }
    }
    return result
}
getSwiftFiles(exampleFiles)

extension Array {
    func myFilter(includeElement: Element -> Bool) -> [Element] {
        var result: [Element] = []
        for x in self where includeElement(x) {
                result.append(x)
        }
        return result
    }
}
exampleFiles.myFilter() {$0.hasSuffix(".md")}

/****************************************
 Reduce
 *****************************************/
func sum(xs: [Int]) -> Int {
    var result: Int = 0
    for x in xs {
        result += x
    }
    return result
}

func product(xs: [Int]) -> Int {
    var result: Int = 0
    for x in xs {
        result = result * x
    }
    return result
}

func prettyPrintArray(xs: [String]) -> String {
    var result: String = "Entries in the array xs:\n"
    for x in xs {
        result=" "+result+x+"\n"
    }
    return result
}

extension Array {
    func myReduce<T>(initial: T, combine: (T, Element) -> T) -> T {
        var result = initial
        for x in self {
            result = combine(result, x)
        }
        return result
    }
}


[1, 2, 3, 4].myReduce(0, combine: +)

func flatten<T>(xss: [[T]]) -> [T] {
    var result: [T] = []
    for xs in xss {
        result += xs
    }
    return result
}


func flattenUsingReduce<T>(xss: [[T]]) -> [T] {
    return xss.myReduce([], combine: +)
}
flattenUsingReduce([[1,2],[1,2],[1,2]])

/****************************************
Redefine map and filter
*****************************************/

extension Array {
    func mapUsingReduce<T>(transform: Element -> T) -> [T] {
        return myReduce([]) {result, x in
            return result + [transform(x)]
        }
    }
    
    func filterUsingReduce(includeElement: Element -> Bool) -> [Element] {
        return myReduce([]) {result, x in
            return includeElement(x) ? result + [x] : result
        }
    }
}

/****************************************
使用
*****************************************/

struct City {
    let name: String
    let population: Int
}

let paris = City(name: "Paris", population: 2243)
let madrid = City(name: "Madrid", population: 3216)
let amsterdam = City(name: "Amsterdam", population: 811)
let berlin = City(name: "Berlin", population: 3397)
let cities = [paris, madrid, amsterdam, berlin]

extension City {
    func cityByScalingPopulation() -> City {
        return City(name: name, population: population * 1000)
    }
}

cities.myFilter(){$0.population > 1000}
    .myMap(){$0.cityByScalingPopulation()}
    .myReduce("City Population"){result, x in
        return result+"\n" + "\(x.name): " + "\(x.population)"
    }









