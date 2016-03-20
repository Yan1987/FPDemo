
import UIKit


func empty<T>() -> [T] {
    return []
}

func isEmpty<T>(set: [T]) -> Bool {
    return set.isEmpty
}

func contains<T: Equatable>(x: T, _ set: [T]) -> Bool {
    return  set.contains(x)
}

func insert<T: Equatable>(x: T, _ set: [T]) -> [T] {
    return contains(x, set) ? set : [x] + set
}

/******************
 另一种实现
 ******************/

indirect enum BinarySearchTree<T: Comparable> {
    case Leaf
    case Node(BinarySearchTree<T>, T, BinarySearchTree<T>)
}

let leaf: BinarySearchTree<Int> = .Leaf
let five: BinarySearchTree<Int> = .Node(leaf, 5, leaf)

extension BinarySearchTree {
    init(_ value: T) {
        self = .Node(.Leaf, value, .Leaf)
    }
    init() {
        self = .Leaf
    }
}

extension BinarySearchTree {
    var count: Int {
        switch self {
        case .Leaf:
            return 0
        case let .Node(left, _, right):
            return 1 + left.count + right.count
        }
    }
}

extension BinarySearchTree where T: Comparable {
    var elements: [T] {
        switch self {
        case .Leaf:
            return []
        case let .Node(left, x, right):
            return left.elements + [x] + right.elements
        }
    }
}

extension BinarySearchTree {
    var isEmpty: Bool {
        if case .Leaf = self {
            return true
        }
        return false
    }
}

extension Array {
    func all(condition: Element -> Bool) -> Bool {
        for x in self {
            if !condition(x) {return false}
        }
        return true
    }
}

extension BinarySearchTree where T: Comparable {
    var isBST: Bool {
        switch self {
        case .Leaf:
            return true
        case let .Node(left, x, right):
            return left.elements.all {y in y < x}
                && right.elements.all{y in y > x}
                && left.isBST
                && right.isBST
        }
    }
}

extension BinarySearchTree {
    func contains(x: T) -> Bool {
        switch self {
        case .Leaf:
            return false
        case let .Node(_, y, _) where x == y:
            return true
        case let .Node(left, y, _) where x < y:
            return left.contains(x)
        case let .Node(_, y, right) where x > y:
            return right.contains(x)
        default:
            fatalError("The impossible occurred")
        }
    }
}

extension BinarySearchTree {
    mutating func insert(x: T) {
        switch self {
        case .Leaf:
            self = BinarySearchTree(x)
        case .Node(var left, let y, var right):
            if x < y { left.insert(x) }
            if x > y { right.insert(x) }
            self = .Node(left, y, right)
        }
    }
}

let myTree: BinarySearchTree<Int> = BinarySearchTree()
var copied = myTree
copied.insert(5)
(myTree.elements, copied.elements)




























