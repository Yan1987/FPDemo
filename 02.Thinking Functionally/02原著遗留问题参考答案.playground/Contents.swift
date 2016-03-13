/*
原著在第二章节提示我们可以这样定义
struct Region {
    let lookup: Position -> Bool
}
使用起来将更具可以读性列如
rangeRegion.shift(ownPosition).difference(friendlyRegion)

*************************

这里提供我的实现方式，但这并不是唯一且最好的方式，
因为笔者也是FP的初学者，所以仅仅当做参考如果您有更加
优雅的实现方式，请您多多赐教^_^
*/

/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，请您多多赐教。
*   邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import AVKit

typealias Distance = Double

struct Position {
    var x: Double
    var y: Double
}

struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}

extension Position {
    func minus(p: Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
    var length: Double {
        return sqrt(x * x + y * y)
    }
}


struct Region {
    let lookup: Position -> Bool
}

func circle(radius: Distance) -> Region {
    return Region(){$0.length <= radius}
}
extension Region {
}

circle(5).lookup(Position(x: 0, y: 6))
circle(5).lookup(Position(x: 0, y: 5))

extension Region {
    static func circle2(radius: Distance, offset: Position) -> Region {
        return Region(){$0.minus(offset).length <= radius}
    }
}


extension Region {
    func shift(offset: Position) -> Region {
        return Region(){self.lookup($0.minus(offset))}
    }
}
circle(5).shift(Position(x: 5, y: 0)).lookup(Position(x: 0, y: 0))
circle(5).shift(Position(x: 5, y: 0)).lookup(Position(x: 10, y: 0))
circle(5).shift(Position(x: 5, y: 0)).lookup(Position(x: 11, y: 0))

extension Region {
    func invert() -> Region {
        return Region(){!self.lookup($0)}
    }
}
circle(5).invert().lookup(Position(x: 0, y: 5))
circle(5).invert().lookup(Position(x: 0, y: 6))

extension Region {
    func intersection(region: Region) -> Region {
       return Region(){self.lookup($0) && region.lookup($0)}
    }
    
    func union(region: Region) -> Region {
        return Region(){self.lookup($0) || region.lookup($0)}
    }
    
    func difference(region: Region) -> Region {
        return Region(){self.lookup($0) && region.invert().lookup($0)}
    }
}
let otherRegion = circle(5).shift(Position(x: 5, y: 0))
circle(5).intersection(otherRegion).lookup(Position(x: 5.1, y: 0))
circle(5).intersection(otherRegion).lookup(Position(x: 2, y: 0))

circle(5).union(otherRegion).lookup(Position(x: 6, y: 0))
circle(5).union(otherRegion).lookup(Position(x: 10.1, y: 0))

circle(5).difference(otherRegion).lookup(Position(x: 2, y: 0))
circle(5).difference(otherRegion).lookup(Position(x: -1, y: 0))
circle(5).difference(otherRegion).lookup(Position(x: 6, y: 0))

extension Ship {
    func canSafelyEngageShip(target: Ship, friendly: Ship) -> Bool {
        let friendlyRagion = circle(unsafeRange).shift(friendly.position)
        
       return circle(firingRange)
            .difference(circle(unsafeRange))
            .shift(position)
            .difference(friendlyRagion)
            .lookup(target.position)
    }
}

let myShip = Ship(position: Position(x: 10, y: 0),
    firingRange: 10,
    unsafeRange: 5)

let canEngageShip = Ship(position: Position(x: 19.9, y: 0),
    firingRange: 10,
    unsafeRange: 5)

let cannotEngageShip = Ship(position: Position(x: 20.1, y: 0),
    firingRange: 10,
    unsafeRange: 5)

let unsafelyEngageShip = Ship(position: Position(x: 14.9, y: 0),
    firingRange: 10,
    unsafeRange: 5)



let safelyFriendlyShip = Ship(position: Position(x: 0, y: 0),
    firingRange: 10,
    unsafeRange: 5)

let unsafelyFriendlyShip = Ship(position: Position(x: 15.1, y: 0),
    firingRange: 10,
    unsafeRange: 5)

myShip.canSafelyEngageShip(canEngageShip, friendly: safelyFriendlyShip)
myShip.canSafelyEngageShip(cannotEngageShip, friendly: safelyFriendlyShip)
myShip.canSafelyEngageShip(unsafelyEngageShip, friendly: safelyFriendlyShip)

myShip.canSafelyEngageShip(canEngageShip, friendly: unsafelyFriendlyShip)

//more...
