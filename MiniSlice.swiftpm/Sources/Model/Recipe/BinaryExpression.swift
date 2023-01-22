/// The syntax-tree for a 2-ary infix operator expression.
indirect enum BinaryExpression: Hashable, CustomStringConvertible {
    case range(Expression, Expression)
    case closedRange(Expression, Expression)
    
    var description: String {
        switch self {
        case let .range(lower, upper):
            return "\(lower)..<\(upper)"
        case let .closedRange(lower, upper):
            return "\(lower)...\(upper)"
        }
    }
}
