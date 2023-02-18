enum ParseError: Error, CustomStringConvertible, Hashable {
    case expected(Token, actual: Token?)
    case expectedIdentifier(actual: Token?)
    case expectedExpression(actual: Token?)
    case expectedValue(actual: Token?)
    case couldNotParseIntLiteral
    case couldNotParseFloatLiteral
    case unimplementedOperator(BinaryOperator)
    
    var description: String {
        switch self {
        case let .expected(expected, actual: actual):
            return "Expected \(expected) but got \(actual.map { "\($0)" } ?? "nil")"
        case let .expectedIdentifier(actual: actual):
            return "Expected identifier but got \(actual.map { "\($0)" } ?? "nil")"
        case let .expectedExpression(actual: actual):
            return "Expected expression but got \(actual.map { "\($0)" } ?? "nil")"
        case let .expectedValue(actual: actual):
            return "Expected value but got \(actual.map { "\($0)" } ?? "nil")"
        case .couldNotParseIntLiteral:
            return "Could not parse int literal"
        case .couldNotParseFloatLiteral:
            return "Could not parse float literal"
        case let .unimplementedOperator(op):
            return "Operator \(op.pretty()) has not been implemented yet"
        }
    }
}
