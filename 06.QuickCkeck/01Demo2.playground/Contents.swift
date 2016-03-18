
import UIKit

extension String {
    func dropFirst() -> String {
        let index = self.startIndex.advancedBy(1)
        return self.substringFromIndex(index)
    }
}


protocol Smaller {
    func smaller() -> Self?
}

protocol Arbitrary: Smaller{
    static func arbitrary() -> Self
}



extension Int: Arbitrary {
    static func arbitrary() -> Int {
        return Int(arc4random())
    }
    
    func smaller() -> Int? {
        return self == 0 ? nil : self / 2
    }
    
    static func random(from from: Int, to: Int) -> Int {
        return from + (Int(arc4random()) % (to - from))
    }
}
Int.arbitrary()

extension Character: Arbitrary {
    static func arbitrary() -> Character {
        return Character(UnicodeScalar(Int.random(from: 65, to: 90)))
    }
    func smaller() -> Character? {
        return self
    }
}
Character.arbitrary()

func tabulate<T>(times: Int, transform: Int -> T) -> [T] {
    return (0..<times).map{transform($0)}
}

extension String: Arbitrary {
    static func arbitrary() -> String {
        let randomLength = Int.random(from: 0, to: 40)
        let randomCharacter =  tabulate(randomLength){_ in
            Character.arbitrary()
        }
        return String(randomCharacter)
    }
    func smaller() -> String? {
        return isEmpty ? nil : self.dropFirst()
    }

}
String.arbitrary()

let numberOfIterations = 10


func iterateWhile<T>(condition: T -> Bool,
    initialValue: T,
    next: T -> T?) -> T {
        if let x = next(initialValue) where condition(x) {
            return iterateWhile(condition, initialValue: x, next: next)
        }
    return initialValue
}

func check2<T: Arbitrary>(message: String, _ property: T -> Bool) -> () {
    for _ in 0..<numberOfIterations {
        let value = T.arbitrary()
        guard property(value) else {
            let smallerValue = iterateWhile({ !property($0)}, initialValue: value) {
                $0.smaller()
            }
            print("\"\(message)\" doesn't hold: \(smallerValue)")
            return
        }
    }
    print("\"\(message)\" passed \(numberOfIterations) tests.")
}

func qsort(var array: [Int]) -> [Int] {
    if array.isEmpty {return []}
    let pivot = array.removeAtIndex(0)
    let lesser = array.filter{$0 < pivot}
    let greater = array.filter{$0 >= pivot}
    return qsort(lesser) + [pivot] + qsort(greater)
    
}

extension Array: Smaller {
    func smaller() -> Array? {
        guard !isEmpty else {return nil}
        return Array(dropFirst())
    }

}

extension Array where Element: Arbitrary {
    static func arbitrary() -> [Element] {
        let randomLength = Int(arc4random() % 50)
        return tabulate(randomLength) {_ in Element.arbitrary()}
    }
}
// 这样是无法满足约束的
//check2("qsort should behave like sort"){ (x: [Int]) in
//    
//}


struct ArbitraryInstance<T> {
    let arbitrary: () -> T
    let small: T -> T?
}

func checkHelper<T>(arbitraryInstance: ArbitraryInstance<T>,
    _ property: T -> Bool, _ message: String) -> () {
        for _ in 0..<numberOfIterations {
            let value = arbitraryInstance.arbitrary()
            guard property(value) else {
                let smallerValue = iterateWhile({!property($0)},
                    initialValue: value) {arbitraryInstance.small($0)}
                print("\"\(message)\" doesn't hold: \(smallerValue)")
                return
            }
        }
         print("\"\(message)\" passed \(numberOfIterations) tests.")
}

func check<T: Arbitrary>(message: String, _ property: T -> Bool) -> () {
    let instance = ArbitraryInstance(arbitrary: {T.arbitrary()},
        small: {$0.smaller()})
    checkHelper(instance, property, message)
}

func check<T: Arbitrary>(message: String, _ property: [T] -> Bool) -> () {
    let instance = ArbitraryInstance(arbitrary: {[T].arbitrary()},
        small: {$0.smaller()})
    checkHelper(instance, property, message)
}

check("qsort should behave like sort") { (x: [Int]) in
    return qsort(x) == x.sort()
}
































