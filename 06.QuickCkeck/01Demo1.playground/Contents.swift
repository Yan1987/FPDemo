
import UIKit

protocol Arbitrary {
    static func arbitrary() -> Self
}

extension Int: Arbitrary {
    static func arbitrary() -> Int {
        return Int(arc4random())
    }
}
Int.arbitrary()


extension Int {
    static func random(from from: Int, to: Int) -> Int {
        return from + (Int(arc4random()) % (to - from))
    }
}
extension Character: Arbitrary {
    static func arbitrary() -> Character {
        return Character(UnicodeScalar(Int.random(from: 65, to: 90)))
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
}
String.arbitrary()

let numberOfIterations = 100

func check1<T: Arbitrary>(message: String, _ property: T -> Bool) -> () {
    for _ in 0..<numberOfIterations {
        let value = T.arbitrary()
        guard property(value) else {
            print("\"\(message)\" doesn't hold: \(value)")
            return
        }
    }
     print("\"\(message)\" passed \(numberOfIterations) tests.")
}


extension CGFloat: Arbitrary {
    static func arbitrary() -> CGFloat {
        let random: CGFloat = CGFloat(arc4random())
        let maxUint = CGFloat(UInt32.max)
        return 10000 * ((random - maxUint/2) / maxUint)
    }
}
extension CGSize: Arbitrary {
    var area: CGFloat {
        return width * height
    }
    static func arbitrary() -> CGSize {
        return CGSize(width: CGFloat.arbitrary(), height: CGFloat.arbitrary())
    }
}


check1("Area should be at least 0") {(size: CGSize) in size.area >= 0}
check1("Every string starts with Hello") { (s: String) in s.hasPrefix("Hello")}
































