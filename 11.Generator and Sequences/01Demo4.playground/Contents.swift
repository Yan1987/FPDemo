
import UIKit

func +<A>(l: AnyGenerator<A>, r: AnyGenerator<A>) -> AnyGenerator<A> {
    return anyGenerator {l.next() ?? r.next()}
}

//func +<A>(l: AnySequence<A>, r:AnySequence<A>) -> AnySequence<A> {
//    return AnySequence(l.generate() + r.generate())
//}
func +<A>(l: AnySequence<A>, r:AnySequence<A>) -> AnySequence<A> {
    return AnySequence {l.generate() + r.generate()}
}
let s = AnySequence([1, 2, 3]) + AnySequence([4, 5, 6])
for x in s {
    print(x)
}
for x in s {
    print(x)
}

extension GeneratorType {
    mutating func myMap<T>(f: Element -> T) -> AnyGenerator<T> {
        return anyGenerator {
            self.next().map(f)
        }
    }
}

struct MyJoinedGenerator<Element>: GeneratorType {
    var generator: AnyGenerator<AnyGenerator<Element>>
    var current: AnyGenerator<Element>?
    
    init<G: GeneratorType where G.Element: GeneratorType,
        G.Element.Element == Element>(var _ g: G) {
        generator = g.myMap(anyGenerator)
        current = generator.next()
    }
    
    mutating func next() -> Element? {
        guard let c = current else {return nil}
        if let x = c.next() {
            return x
        }else {
            current = generator.next()
            return next()
        }
    }
}

extension SequenceType where Generator.Element: SequenceType {
    typealias NestedElement = Generator.Element.Generator.Element
    
    func join() -> AnySequence<NestedElement> {
        return AnySequence { () -> MyJoinedGenerator<NestedElement> in
            var generator = self.generate()
            return MyJoinedGenerator(generator.myMap { g in
                g.generate()
                })
        }
    }
}

extension SequenceType {
    func myMap<T>(f: Self.Generator.Element -> T) -> AnySequence<T> {
        var sourceGen = generate()
        return AnySequence(anyGenerator {
            sourceGen.next().map(f)
            })
    }
}

extension AnySequence {
    func myFlatMap<T, Seq: SequenceType where Seq.Generator.Element == T> (f: Element -> Seq) -> AnySequence<T> {
        return AnySequence<Seq>(self.myMap(f)).join()
    }
}




