import UIKit


indirect enum Tree<T> {
    case Leaf
    case Node(Tree<T>, T, Tree<T>)
}
let three: [Int] = Array(GeneratorOfOne(3))
let empty: [Int] = Array(GeneratorOfOne(nil))

func one<T>(x: T?) -> AnyGenerator<T> {
    return anyGenerator(GeneratorOfOne(x))
}

func +<A>(l: AnyGenerator<A>, r: AnyGenerator<A>) -> AnyGenerator<A> {
    return anyGenerator {l.next() ?? r.next()}
}

extension Tree {
    var inOrder: AnyGenerator<T> {
        switch self {
        case Tree.Leaf:
            return anyGenerator {return nil}
        case let Tree.Node(left, x, right):
            return left.inOrder + one(x) + right.inOrder
        }
    }
}
let tree4 = Tree.Node(Tree.Leaf, 4, Tree.Leaf)
let tree3 = Tree.Node(Tree.Leaf, 3, Tree.Leaf)
let tree2 = Tree.Node(tree4, 2, Tree.Leaf)
let tree1 = Tree.Node(tree2, 1, tree3)
for x in tree1.inOrder {
    print(x)
}






