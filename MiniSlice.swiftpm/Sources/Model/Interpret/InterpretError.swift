enum InterpretError: Error, CustomStringConvertible {
    case variableNotInScope(String)
    case functionNotInScope(String)
    case cannotIterate(Expression<Any>)
    case binaryOperationTypesMismatch(Value, Value)
    case binaryOperatorNotImplemented(BinaryOperator)
    case ambiguousExpression(Expression<Any>, [Value])
    case invalidRange(Value, Value)
    
    var description: String {
        switch self {
        case .variableNotInScope(let name):
            return "The variable \(name) is not in scope"
        case .functionNotInScope(let name):
            return "The function \(name) is not in scope"
        case .cannotIterate(let expr):
            return "Cannot iterate over \(expr)"
        case .binaryOperationTypesMismatch(let lhs, let rhs):
            return "The types in the binary operation don't match: \(lhs) vs \(rhs)"
        case .binaryOperatorNotImplemented(let op):
            return "The binary operator \(op.pretty()) is not implemented yet"
        case .ambiguousExpression(let expr, let values):
            return "The expression \(expr) does not uniquely evaluate to one result: \(values)"
        case .invalidRange(let lower, let upper):
            return "Cannot form a range between \(lower) and \(upper)"
        }
    }
}
