import UIKit


class CountdownGenerator: GeneratorType {
    var element: Int
    
    init<T>(array: [T]) {
        self.element = array.count - 1
    }
    
    func next() -> Int? {
        return element < 0 ? nil : element--
    }
}

let xs = ["A", "B", "C"]
let generator = CountdownGenerator(array: xs)
while let i = generator.next() {
    print("Element \(i) of the array is \(xs[i])")
}

class PowerGenerator: GeneratorType {
    var power: NSDecimalNumber = 1
    let two: NSDecimalNumber = 2
    
    func next() -> NSDecimalNumber? {
        power = power.decimalNumberByMultiplyingBy(two)
        return power
    }
}

extension PowerGenerator {
    func findPower(predicate: NSDecimalNumber -> Bool) -> NSDecimalNumber {
        while let x = next() {
            if predicate(x) {return x}
        }
        return 0
    }
}
PowerGenerator().findPower {$0.integerValue > 1000}



class FileLinesGenerator: GeneratorType {
    typealias Element = String
    
    var lines: [String] = []
    
    init(fileName: String) throws {
        let content: String = try String(contentsOfFile: fileName)
        let newLine = NSCharacterSet.newlineCharacterSet()
        lines = content.componentsSeparatedByCharactersInSet(newLine)
    }
    
    func next() -> Element? {
        guard !lines.isEmpty else { return nil}
        let newLine = lines.removeAtIndex(0)
        return newLine
    }
}



extension GeneratorType {
    mutating func find(predicate: Element -> Bool) -> Element? {
        while let x = self.next() {
            if predicate(x) {return x}
        }
        return nil
    }
}


class LimitGenerator<G: GeneratorType>: GeneratorType {
    var limit = 0
    var generator: G
    
    init(limit: Int, generator: G) {
        self.limit = limit
        self.generator = generator
    }
    
    func next() -> G.Element? {
        guard limit >= 0 else {return nil}
        limit -= 1
        return generator.next()
    }
}
let textG = CountdownGenerator(array: [1, 2, 3, 4, 5, 6])
let limitG = LimitGenerator(limit: 2, generator: textG)
while let item = limitG.next() {
    print(item)
}

extension Int {
    func countDown() -> AnyGenerator<Int> {
        var i = self
        return anyGenerator {return i < 0 ? nil : i--}
    }
}
for item in 4.countDown() {
    print(item)
}

/*******************
 Sequence
 ********************/
struct ReverseSequence<T>: SequenceType {
    var array: [T]
    
    init(array: [T]) {
        self.array = array
    }
    
    func generate() -> CountdownGenerator {
        return CountdownGenerator(array: array)
    }
}
let reverseSequence = ReverseSequence(array: xs)
let reverseGenerator = reverseSequence.generate()
while let i = reverseGenerator.next() {
    print("Index \(i) is \(xs[i])")
}

for i in reverseSequence {
    print("Index \(i) is \(xs[i])")
}

let reverseElements = ReverseSequence(array: xs).map {xs[$0]}
for x in reverseElements {
    print("Element is \(x)")
}




