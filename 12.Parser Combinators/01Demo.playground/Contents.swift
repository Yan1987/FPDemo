import UIKit



func none<A>() -> AnySequence<A> {
    return AnySequence(GeneratorOfOne(nil))
}

func one<A>(x: A) -> AnySequence<A> {
    return AnySequence(GeneratorOfOne(x))
}

extension ArraySlice {
    var tail: ArraySlice<Element> {
        if isEmpty {
            return self
        }
        return self[(startIndex + 1)..<endIndex]
    }
    var decompose : (head: Element, tail: ArraySlice<Element>)? {
        return isEmpty ? nil : (self[startIndex], tail)
    }
}

extension String {
    var myCharacters: [Character] {
        var result: [Character] = []
        for c in self.characters {
            result += [c]
        }
        return result
    }
    var slice: ArraySlice<Character> {
        let res = myCharacters
        return res[0..<myCharacters.count]
    }
}

//struct JoinedGenerator
extension AnyGenerator {
    func myMap<T>(f: Element -> T) -> AnyGenerator<T> {
        return anyGenerator {
            self.next().map(f)
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
//
struct MyJoinedGenerator<A>: GeneratorType {
    typealias Element = A
    
    var generator: AnyGenerator<AnyGenerator<A>>
    var current: AnyGenerator<A>?
    
    init(_ g: AnyGenerator<AnyGenerator<A>>) {
        generator = g
        current = generator.next()
    }
    
    mutating func next() -> A? {
        guard let c = current else {
            return nil
        }
        if let x = c.next() {
            return x
        }else {
            current = generator.next()
            return next()
        }
    }
}

func join<A>(s: AnySequence<AnySequence<A>>) -> AnySequence<A> {
    return AnySequence {
        MyJoinedGenerator(s.generate().myMap {
            $0.generate()
            })
    }
}
struct Parser<Token, Result> {
    let p: ArraySlice<Token> -> AnySequence<(Result, ArraySlice<Token>)>
}
let t: Parser<Character, Character> = Parser { x in
    guard let (head, tail) = x.decompose
        else {
            return none()
    }
    return one((head, tail))
}

let str = "abc"
for (x, y) in t.p(str.slice) {
    print("\(x)===\(y)")
}

func paraseA() -> Parser<Character, Character> {
    let a: Character = "a"
    return Parser { x in
        guard let (head, tail) = x.decompose
            where head == a else {
                return none()
        }
        return one((a, tail))
    }
}



func testParser<A>(parser: Parser<Character, A>,
    input: String) -> String {
        var result: [String] = []
        for (x, s) in parser.p(input.slice) {
            result += ["Success, found \(x), remainder: \(Array(s))"]
        }
        return result.isEmpty ?
            "Parasing failed." : result.reduce("") {$0 + $1}
}

testParser(paraseA(), input: "abc")
testParser(paraseA(), input: "ebac")

func parseCharacter(character: Character)
    -> Parser<Character, Character> {
        return Parser { x in
            guard let (head, tail) = x.decompose
                where head == character else {
                    return none()
            }
            return one((character, tail))
        }
}
testParser(parseCharacter("t"), input: "test")

func satisfy<Token>(condition: Token -> Bool)
    -> Parser<Token, Token> {
        return Parser { x in
            guard let (head, tail) = x.decompose
                where condition(head) else {
                    return none()
            }
            return one((head,tail))
        }
}

/********************
 choice
 ***********************/
func token<Token: Equatable>(t: Token) -> Parser<Token, Token> {
    return satisfy {$0 == t}
}
func +<A>(l: AnySequence<A>, r: AnySequence<A>)
    -> AnySequence<A> {
        return join(AnySequence([l, r]))
}
infix operator <|> {associativity right precedence 130}
func <|> <Token, A>(l: Parser<Token, A>, r: Parser<Token, A>)
    -> Parser<Token, A> {
        return Parser {l.p($0) + r.p($0)}
}

let a: Character = "a"
let b: Character = "b"
testParser(token(a) <|> token(b), input: "bcd")

/********************
 sequence
 ***********************/
extension AnySequence {
    func myFlatMap<A>(f: Element -> AnySequence<A>) -> AnySequence<A> {
        return join(myMap(f))
    }
}
func sequence<Token, A, B>(l: Parser<Token, A>, _ r: Parser<Token, B>) -> Parser<Token, (A, B)> {
    return Parser { input in
        let leftResults = l.p(input)
        return leftResults.myFlatMap { (a, leftRest) in
            let rightResults = r.p(leftRest)
            return rightResults.myMap { (b, rightRest) in
                ((a, b), rightRest)
            }
        }
        
    }
}
let p: Parser<Character, (Character, Character)> = sequence(token(a), token(b))
testParser(p, input: "abcd")




