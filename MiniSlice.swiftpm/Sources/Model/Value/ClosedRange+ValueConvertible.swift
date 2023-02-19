// Since Swift unfortunately lacks the ability to conform to a protocol multiple times with different generic bounds, we have to resort to runtime reflection

extension Range: ValueConvertible {
    init?(_ value: Value) {
        switch (value, String(describing: Bound.self)) {
        case (.intRange(let range), "Int"):
            self = range as! Range<Bound>
        case (.floatRange(let range), "Double"):
            self = range as! Range<Bound>
        default:
            return nil
        }
    }
    
    var asValue: Value {
        switch String(describing: Bound.self) {
        case "Int":
            return .intRange(self as! Range<Int>)
        case "Double":
            return .floatRange(self as! Range<Double>)
        default:
            fatalError("ValueConvertible.asValue is not implemented for \(type(of: self))")
        }
    }
}
