// Since Swift unfortunately lacks the ability to conform to a protocol multiple times with different generic bounds, we have to resort to runtime reflection

extension Range: ValueConvertible {
    init?(_ value: Value) {
        switch value {
        case .intRange(let range) where Bound.self == Int.self:
            self = range as! Range<Bound>
        case .floatRange(let range) where Bound.self == Double.self:
            self = range as! Range<Bound>
        default:
            return nil
        }
    }
    
    var asValue: Value {
        if let self = self as? Range<Int> {
            return .intRange(self)
        } else if let self = self as? Range<Double> {
            return .floatRange(self)
        } else {
            fatalError("ValueConvertible.asValue is not implemented for \(type(of: self))")
        }
    }
}
