import UIKit


func autocomplete(history: [String], textEntered: String) -> [String] {
    return history.filter { $0.hasPrefix(textEntered) }
}


struct Trie<T: Hashable> {
    let isElement: Bool
    let children: [T: Trie<T>]
}


extension Trie {
    init() {
        isElement = false
        children = [:]
    }
}

extension Trie {
    var elements: [[T]] {
        var result: [[T]] = isElement ? [[]] : []
        for (key, value) in children {
            result += value.elements.map { [key] + $0 }
        }
        return result
    }
}

extension Array {
    var decompose: (head: Element, tail: [Element])? {
        return isEmpty ? nil : (self[0], Array(self[1..<count]))
    }
}
func sum(xs: [Int]) -> Int {
    guard let (head, tail) = xs.decompose else {
        return 0
    }
    return head + sum(tail)
}
func qsort(xs: [Int]) -> [Int] {
    guard let (pivot, rest) = xs.decompose else {
        return []
    }
    let lesser = rest.filter {$0 < pivot}
    let greater = rest.filter {$0 >= pivot}
    return qsort(lesser) + [pivot] + qsort(greater)
}

extension Trie {
    func lookup(key: [T]) -> Bool {
        guard let (head, tail) = key.decompose else {
            return isElement
        }
        guard let subtrie = children[head] else {
            return false
        }
        return subtrie.lookup(tail)
    }
}

extension Trie {
    func withPrefix(prefix: [T]) -> Trie<T>? {
        guard let (head, tail) = prefix.decompose else {
            return self
        }
        guard let remainder = children[head] else {
            return nil
        }
        return remainder.withPrefix(tail)
    }
}

extension Trie {
    func autocomplete(key: [T]) -> [[T]] {
        return withPrefix(key)?.elements ?? []
    }
}

extension Trie {
    init(_ key: [T]) {
        if let (head, tail) = key.decompose {
            let children = [head: Trie(tail)]
            self = Trie(isElement: false, children: children)
        }else {
            self = Trie(isElement: true, children: [:])
        }
    }
}

extension Trie {
    func insert(key: [T]) -> Trie<T> {
        guard let (head, tail) = key.decompose else {
            return Trie(isElement: true, children: children)
        }
        var newChildren = children
        if let nextChildren = children[head] {
            newChildren[head] = nextChildren.insert(tail)
        }else {
            newChildren[head] = Trie(tail)
        }
        
        return Trie(isElement: isElement, children: newChildren)
    }
}

func buildStringTrie(word: [String]) -> Trie<Character> {
    let emptyTrie = Trie<Character>()
    return word.reduce(emptyTrie) { trie, word in
        trie.insert(Array(word.characters))
    }
}

func autocompleteString(knownWords: Trie<Character>,
    word: String) -> [String] {
    let chars = Array(word.characters)
    let completed = knownWords.autocomplete(chars)
    return completed.map { chars in
        word + String(chars)
    }
}

let contents = ["cat", "car", "cart", "dog"]
let trieWords = buildStringTrie(contents)
autocompleteString(trieWords, word: "car")



















