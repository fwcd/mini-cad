// Since Swift unfortunately lacks the ability to conform to a protocol multiple times with different generic bounds, we have to resort to runtime reflection

extension ClosedRange: ValueConvertible {
    init?(_ value: Value) {
        switch (value, String(describing: Bound.self)) {
        case (.closedIntRange(let range), "Int"):
            self = range as! ClosedRange<Bound>
        case (.closedFloatRange(let range), "Double"):
            self = range as! ClosedRange<Bound>
        default:
            return nil
        }
    }
    
    var asValue: Value {
        switch String(describing: Bound.self) {
        case "Int":
            return .closedIntRange(self as! ClosedRange<Int>)
        case "Double":
            return .closedFloatRange(self as! ClosedRange<Double>)
        default:
            fatalError("ValueConvertible.asValue is not implemented for \(type(of: self))")
        }
    }
}
