
import UIKit

enum LookupError: ErrorType {
    case CapitalNotFound
    case PopulationNotFound
}

enum PopulationResult {
    case Success(Int)
    case Error(LookupError)
}

let exampleSuccess: PopulationResult = .Success(1000)

let cities = ["Paris": 2243,
    "Madrid": 3216,
    "Amsterdam": 881,
    "Berlin": 3397]

let capitals = ["France": "Paris",
    "Spain": "Madrid",
    "The Netherlands": "Amsterdam",
    "Belgium": "Brussels"]

func populationOfCapital(country: String) -> PopulationResult {
    guard let capital = capitals[country] else {
        return .Error(.CapitalNotFound)
    }
    
    guard let population = cities[capital] else {
        return .Error(.PopulationNotFound)
    }
    return .Success(population)
}

switch populationOfCapital("France") {
    case let .Success(population):
        print("France's capital has \(population) thousand inhabitants")
    case let .Error(error):
        print("Error: \(error)")
}

/*******************************
adding Generics
*******************************/

let mayors = [
    "Paris": "Hidalgo",
    "Madrid": "Carmena",
    "Amsterdam": "van der Laan",
    "Berlin": "Müller"
]

func mayorsOfCapital(country: String) -> String? {
    return capitals[country].flatMap {mayors[$0]}
}
mayorsOfCapital("France")


enum Result<T> {
    case Success(T)
    case Error(ErrorType)
}
enum Error: ErrorType {
    case CapitalNotFound
    case PopulationNotFound
    case MayorNotFound
}


func mayorsOfCapital2(country: String) -> Result<String> {
    return capitals[country].flatMap {capital in
        guard let mayor = mayors[capital] else {
            return .Error(Error.MayorNotFound)
        }
        return .Success(mayor)
    } ?? .Error(Error.CapitalNotFound)
}
mayorsOfCapital2("France")
mayorsOfCapital2("Francd")

func populationOfCapital2(country: String) -> Result<Int> {
    guard let capital = capitals[country] else {
        return .Error(Error.CapitalNotFound)
    }
    
    guard let population = cities[capital] else {
        return .Error(Error.PopulationNotFound)
    }
    return .Success(population)
}
populationOfCapital2("France")
populationOfCapital2("Francd")


func populationOfCapital3(country: String) throws -> Int {
    guard let capital = capitals[country] else {
        throw Error.CapitalNotFound
    }
    
    guard let population = cities[capital] else {
        throw Error.PopulationNotFound
    }
    return population
}

do {
    let population = try populationOfCapital3("France")
    print("France's population is \(population)")
} catch {
    print("Lookup error: \(error)")
}


func ??<T>(result: Result<T>, handleError: ErrorType -> T) -> T {
    switch result {
    case let .Success(value):
        return value
    case let .Error(error):
        return handleError(error)
    }
}



