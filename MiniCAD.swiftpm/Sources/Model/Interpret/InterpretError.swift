enum InterpretError: Error, CustomStringConvertible {
    case variableNotInScope(String)
    case functionNotInScope(String)
    case cannotIterate(Expression<Any>)
    case cannotBranch(Expression<Any>)
    case binaryOperationTypesMismatch(Value, Value)
    case binaryOperatorNotImplemented(BinaryOperator)
    case ambiguousExpression(Expression<Any>, [Value])
    case ambiguousFunction(String)
    case notAFunction(String)
    case trailingBlockOnlySupportedOnBuiltIns(String)
    case invalidRange(Value, Value)
    case invalidArguments(String, expected: String, actual: String)
    case argumentCountMismatch(String, expected: Int, actual: Int)
    case duplicateParamNames(String)
    case maxRecursionDepthExceeded(Int)
    case maxIterationCountExceeded(Int, Int)
    
    var description: String {
        switch self {
        case .variableNotInScope(let name):
            return "The variable \(name) is not in scope"
        case .functionNotInScope(let name):
            return "The function \(name) is not in scope"
        case .cannotIterate(let expr):
            return "Cannot iterate over \(expr)"
        case .cannotBranch(let expr):
            return "Cannot branch over non-boolean \(expr)"
        case .binaryOperationTypesMismatch(let lhs, let rhs):
            return "The types in the binary operation don't match: \(lhs) vs \(rhs)"
        case .binaryOperatorNotImplemented(let op):
            return "The binary operator \(op.pretty()) is not implemented yet"
        case .ambiguousExpression(let expr, let values):
            return "The expression \(expr) does not uniquely evaluate to one result: \(values)"
        case .ambiguousFunction(let name):
            return "The function \(name) is ambiguous"
        case .notAFunction(let name):
            return "\(name) is not a function"
        case .trailingBlockOnlySupportedOnBuiltIns(let name):
            return "\(name) is not a built-in function and therefore does not support trailing blocks"
        case .invalidRange(let lower, let upper):
            return "Cannot form a range between \(lower) and \(upper)"
        case .invalidArguments(let funcName, let expected, let actual):
            return "\(funcName) expected \(expected), but got \(actual)"
        case .argumentCountMismatch(let funcName, let expected, let actual):
            return "\(funcName) expected \(expected) argument\(expected == 1 ? "" : "s"), but got \(actual)"
        case .duplicateParamNames(let funcName):
            return "The function \(funcName) has duplicate parameters"
        case .maxRecursionDepthExceeded(let maxRecursionDepth):
            return "The maximum recursion depth of \(maxRecursionDepth) has been exceeded"
        case .maxIterationCountExceeded(let iterationCount, let maxIterationCount):
            return "\(iterationCount) exceeds the maximum iteration count of \(maxIterationCount)"
        }
    }
}
