
import UIKit

let cities = ["Paris": 2243,
            "Madrid": 3216,
            "Amsterdam": 881,
            "Berlin": 3397]

//let madridPopulation: Int = cities["Madrid"] 报错
let madridPopulation: Int? = cities["Madrid"]

if madridPopulation != nil {
    print("The population of Madrid is " +
        "\(madridPopulation! * 1000)")
    
} else {
    print("Unknown city: Madrid")
}

if let madridPopulation = cities["Madrid"] {
    print("The population of Madrid is " +
    "\(madridPopulation * 1000)")
} else {
    print("Unknown city: Madrid")
}

infix operator ??? { associativity right precedence 131}

func ???<T>(optional: T?, defaultValue: T) -> T {
    if let x = optional {
        return x
    }else {
        return defaultValue
    }
}
Optional.Some(1) ??? 2 + 1 //重复计算

func ???<T>(optional: T?, defaultValue: () -> T) -> T {
    if let x = optional {
        return x
    }else {
        return defaultValue()
    }
}
Optional.Some(1) ??? {1 + 1}

func ???<T>(optional: T?, @autoclosure defaultValue: () -> T) -> T {
    if let x = optional {
        return x
    }else {
        return defaultValue()
    }
}
Optional.Some(1) ?? 1 + 1

switch madridPopulation {
case 0?: print("Nobody in Madrid")
case (1..<1000)?: print("Less than a million in Madrid")
case .Some(let x): print("\(x) people in Madrid")
case .None: print("We don't know about Madrid")
}

/*************************************
optional Mapping
**************************************/

func incrementOptional(optional: Int?) -> Int? {
    guard let x = optional else {return nil}
    return x + 1
}

extension Optional {
    func myMap<U>(transform: Wrapped -> U) -> U? {
        guard let x = self else {return nil}
        return transform(x)
    }
}

/*************************************
Optional Binding Revisited
**************************************/

let x: Int? = 3
let y: Int? = nil
//let z: Int? = x + y error

func addOptionals(optionalX: Int?, optionalY: Int?) -> Int? {
    guard let x = optionalX, y = optionalY else {return nil}
    return x + y
}

let capitals = ["France": "Paris",
                "Spain": "Madrid",
                "The Netherlands": "Amsterdam",
                "Belgium": "Brussels"]

func populationOfCapital(country: String) -> Int? {
    guard let capital = capitals[country], population = cities[capital] else {return nil}
    return population * 1000
}

extension Optional {
    func myFlatMap<U>(f: Wrapped -> U?) -> U? {
        guard let x = self else {return nil}
        return f(x)
    }
}

func addOptionals2(optionalX: Int?, optionalY: Int?) -> Int? {
    return optionalX.myFlatMap() { x in
        optionalY.myFlatMap() { y in
            x + y
        }
    }
}

func populationOfCapital2(country: String) -> Int? {
    return capitals[country].myFlatMap() {capital in
        cities[capital].myFlatMap(){population in
            population * 1000
        }
    }
}

func populationOfCapital3(country: String) -> Int? {
    return capitals[country].myFlatMap {cities[$0]}.myFlatMap {$0 * 1000}
}



















