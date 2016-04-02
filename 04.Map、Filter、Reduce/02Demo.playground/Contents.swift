
import Foundation
/****************************
    测试
 ****************************/
let test1: [Int?] = [1, nil, 2, nil, nil, 3]
let test2 = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

let t1 = test1.flatMap {$0}
print(t1)
let t2 = test2.flatMap {$0}
print(t2)

/****************************
 自定义flatMap
 *****************************/

extension Array {
    func myFlatMap<T>(transform: Element -> T?) -> [T] {
        var result: [T] = []
        for x in self {
            if let new = transform(x) {
                result.append(new)
            }
        }
        return result
    }
}
extension Array {
    func myFlatMap<S: SequenceType>(transform: Element -> S?) -> [S.Generator.Element] {
        var result: [S.Generator.Element] = []
        for x in self {
            if let new = transform(x) {
                result.appendContentsOf(new)
            }
        }
        return result
    }
}
let myT1 = test1.myFlatMap {$0}
let myT2 = test2.myFlatMap {$0}
print(myT1)
print(myT2)

/****************************
    练习
 ****************************/

/****************************
    小明帮妈妈去超市买东西，
    妈妈给了小明一张采购单，
    写一个程序打印出小明在
    超市里买到的所有东西(购物清单)
*****************************/

let supermarket = [
    "radish" : 3.6,
    "apple" : 2.1,
    "orange" : 4.1,
    "banana" : 5.3
]

struct Goods {
    let name: String
    let amount: Double
    let price: Double

    var totalPrice: Double {
        return (price ?? 0) * Double(amount)
    }
}

extension Goods {
    init(_ name: String, amount: Double) {
        self.name = name
        self.amount = amount
        self.price = 0
    }
}

let radish = Goods("radish",amount: 3.1)
let apple = Goods("apple", amount: 23.2)
let orange = Goods("orange", amount: 6.6)
let spinach = Goods("spinach", amount: 8.2)
let watermelon = Goods("watermelon", amount: 12.5)
let chocolate = Goods("banana", amount: 15.3)

extension Goods {
    func goodsWithPrice(price: Double) -> Goods? {
        guard price > 0 else {
            return nil
        }
        return Goods(name: name, amount: amount, price: price)
    }
}

let list = [radish, apple, orange, spinach, watermelon, chocolate]
let shoppingList = list.flatMap {
    return $0.goodsWithPrice(supermarket[$0.name] ?? 0)
    }.reduce("Goods:\t price\t total\t priceTotal") { result, goods in
        let goodsInfo = goods.name + "\t \(goods.price)"
            + "\t\(goods.amount)" + "\t\(goods.amount * goods.price)"
        return result + "\n" + goodsInfo
}
print(shoppingList)

