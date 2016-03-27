import UIKit



//protocol Smaller {
//    func smaller() -> Self?
//}
//
//extension Array: Smaller {
//    func smaller() -> [Element]? {
//        guard !self.isEmpty else {return nil}
//        return Array(dropFirst())
//    }
//}

func +<A>(l: AnyGenerator<A>, r: AnyGenerator<A>) -> AnyGenerator<A> {
    return anyGenerator {l.next() ?? r.next()}
}

func one<T>(x: T?) -> AnyGenerator<T> {
    return anyGenerator(GeneratorOfOne(x))
}

protocol Smaller {
    func smaller() -> AnyGenerator<Self>
}

extension Array {
    func generateSmallerByOne() -> AnyGenerator<[Element]> {
        var i = 0
        return anyGenerator {
            guard i < self.count else {return nil}
            var result = self
            result.removeAtIndex(i)
            i += 1
            return result
        }
    }
}
Array([1, 2, 3].generateSmallerByOne()).generate()

extension Array {
    var decompose : (head: Element, tail: [Element])? {
        return (count > 0) ? (self[0], Array(self[1..<count])) : nil }
}


extension AnyGenerator {
    func myMap<T>(f: Element -> T) -> AnyGenerator<T> {
        return anyGenerator {
            self.next().map(f)
        }

    }
}

extension Array {
    func smaller1() -> AnyGenerator<[Element]> {
        guard let (head, tail) = self.decompose else {
            return one(nil)
        }
        let tt = tail.smaller1().myMap {[head] + $0}.generate()
        let o =  one(tail)
        return o + tt
    }
}
Array([1, 2, 3].smaller1())

extension Int: Smaller {
    func smaller() -> AnyGenerator<Int> {
        let result: Int? = self < 0 ? nil : self.predecessor()
        return one(result)
    }
}

extension Array where Element: Smaller {
    func smaller() -> AnyGenerator<[Element]> {
        guard let (head, tail) = self.decompose else {
            return anyGenerator {return nil}
        }
        let gen1 = one(tail).generate()
        let gen2 = tail.smaller().myMap {[head] + $0}.generate()
        let gen3 = head.smaller().myMap {tail + [$0]}.generate()
        
        return gen1 + gen2 + gen3
    }
}
Array([1, 2, 3].smaller())




