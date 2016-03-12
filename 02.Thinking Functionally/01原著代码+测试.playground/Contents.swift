



import AVKit



typealias Distance = Double

struct Position {
    var x: Double
    var y: Double
}

extension Position {
    func inRange(target: Position, range: Distance) -> Bool {
        return sqrt(target.x * target.x + target.y * target.y) <= range
    }
}


struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}

extension Ship {
    func canEngageShip(target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange
    }
}

extension Ship {
    func canSafelyEngageShip(target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange && targetDistance > unsafeRange
    }
}

extension Ship {
    func canSafelyEngageShip1(target: Ship, friendly: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        let friendlyDx = friendly.position.x - target.position.x
        let friendlyDy = friendly.position.y - target.position.y
        let friendlyDistance = sqrt(friendlyDx * friendlyDx +
            friendlyDy * friendlyDy)
        return targetDistance <= firingRange
            && targetDistance > unsafeRange
            && (friendlyDistance > unsafeRange)
    }
}

extension Position {
    func minus(p: Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
    var length: Double {
        return sqrt(x * x + y * y)
    }
}

extension Ship {
    func canSafelyEngageShip2(target: Ship, friendly: Ship) -> Bool {
        let targetDistance = target.position.minus(position).length
        let friendlyDistance = friendly.position.minus(target.position).length
        return targetDistance <= firingRange
            && targetDistance > unsafeRange
            && (friendlyDistance > unsafeRange)
    }
}




/**************************************/
 
 /// Region 是 (Position -> Bool) 这一种类型， 他和Int、String是一样的意义。
typealias Region = Position -> Bool


func circle(radius: Distance) -> Region {
    return { point in point.length <= radius }
}
/// circleT的类型是Region
let circleT = circle(10)
circleT(Position(x: 1, y: 1))
circleT(Position(x: 10, y: 10))
circle(10)(Position(x: 10, y: 10))

func circle2(radius: Distance, center: Position) -> Region {
    return { point in point.minus(center).length <= radius }
}

func shift(region: Region, offset: Position) -> Region {
    return { point in region(point.minus(offset)) }
}


func invert(region: Region) -> Region {
    return {point in !region(point)}
}
let invertT = invert(circle(10))
invertT(Position(x: 1, y: 1))
invertT(Position(x: 10, y: 10))

// 返回一两个Region相交的Region,
func intersection(region1: Region, region2: Region) -> Region{
    return { point in region1(point) && region2(point)}
}

func union(region1: Region, region2: Region) -> Region {
    return { point in region1(point) || region2(point)}
}

func difference(region: Region, minusRegion: Region) -> Region {
    return intersection(region, region2: invert(minusRegion))
}

extension Ship {
    func canSafelyEngageShip(target: Ship, friendly: Ship) -> Bool {
        let rangeRegion = difference(circle(firingRange),
            minusRegion: circle(unsafeRange))
        let firingRegion = shift(rangeRegion, offset: position)
        
        let friendlyRegion = shift(circle(unsafeRange),
            offset: friendly.position)
        
        let resultRegion = difference(firingRegion, minusRegion: friendlyRegion)
        return resultRegion(target.position)
    }
}
/*测试用例*/
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
