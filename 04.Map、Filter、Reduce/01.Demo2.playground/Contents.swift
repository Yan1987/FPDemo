
import Foundation


func noOp<T>(x: T) -> T {
    return x
}

func noOpAny(x: Any) -> Any {
    return x
}

noOp(1)
noOp("hello")
noOpAny(1)
noOpAny("hello")

//func noOpWrong<T>(x: T) -> T {
//    return 0
//}Error

func noOpAnyWrong(x: Any) -> Any {
    return 0
}
noOpAnyWrong("Hi")



